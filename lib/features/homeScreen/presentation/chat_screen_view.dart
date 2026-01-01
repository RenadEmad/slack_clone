import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:slack_clone/features/homeScreen/presentation/widget/chat_input_bar.dart';

class ChatScreen extends StatefulWidget {
  final String channelId;
  final String channelName;

  const ChatScreen({
    super.key,
    required this.channelId,
    required this.channelName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<MessageModel> _messages = [];
  bool isLoading = true;
  late RealtimeChannel messagesSubscription;

  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    fetchMessages();
    subscribeToMessages();
  }

  Future<void> fetchMessages() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      log('No user logged in');
      setState(() => isLoading = false);
      return;
    }

    try {
      final response = await supabase
          .from('messages')
          .select('content, sender_id, created_at, profiles!inner(username)')
          .eq('channel_id', widget.channelId)
          .order('created_at', ascending: true);

      setState(() {
        _messages.clear();
        _messages.addAll(
          response.map<MessageModel>((e) {
            return MessageModel(
              text: e['content'] ?? 'no content',
              isMe: e['sender_id'] == user.id,
              username: e['profiles']?['username'] ?? 'no username',
              createdAt: DateTime.parse(e['created_at']),
            );
          }),
        );
        isLoading = false;
      });
    } catch (e) {
      log('Error fetching messages: $e');
      setState(() => isLoading = false);
    }
  }

  void subscribeToMessages() {
    messagesSubscription = supabase
        .channel('public:messages')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          callback: (payload) {
            if (payload.newRecord['channel_id'] == widget.channelId) {
              final userId = supabase.auth.currentUser?.id;
              final msg = MessageModel(
                text: payload.newRecord['content'] ?? 'no content',
                isMe: payload.newRecord['sender_id'] == userId,
                username:
                    payload.newRecord['profiles']?['username'] ?? 'no username',
                createdAt: DateTime.parse(payload.newRecord['created_at']),
              );

              setState(() {
                _messages.add(msg);
                _messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
              });
            }
          },
        )
        .subscribe();
  }

  Future<void> sendMessage(String content) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      await supabase.from('messages').insert({
        'channel_id': widget.channelId,
        'sender_id': user.id,
        'content': content,
        'created_at': DateTime.now().toIso8601String(),
      });
      _controller.clear();
    } catch (e) {
      log('Send message error: $e');
    }
  }

  @override
  void dispose() {
    supabase.removeChannel(messagesSubscription);
    _controller.dispose();
    super.dispose();
  }

  // === تجميع الرسائل المتتالية لنفس المستخدم ===
  List<Widget> buildMessageGroups(List<MessageModel> messages) {
    List<Widget> groups = [];
    if (messages.isEmpty) return groups;

    List<MessageModel> currentGroup = [messages.first];

    for (int i = 1; i < messages.length; i++) {
      if (messages[i].username == currentGroup.last.username) {
        // نفس الشخص
        currentGroup.add(messages[i]);
      } else {
        // شخص مختلف
        groups.add(MessageGroup(messages: currentGroup));
        currentGroup = [messages[i]];
      }
    }

    groups.add(MessageGroup(messages: currentGroup));
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('# ${widget.channelName}')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: _messages.isEmpty
                      ? const Center(child: Text('No messages yet 👋'))
                      : ListView(
                          padding: const EdgeInsets.all(16),
                          children: buildMessageGroups(_messages),
                        ),
                ),
                ChatInputBar(
                  controller: _controller,
                  onSend: () {
                    final text = _controller.text.trim();
                    if (text.isEmpty) return;
                    sendMessage(text);
                  },
                ),
              ],
            ),
    );
  }
}

// ================= MESSAGE MODEL =================
class MessageModel {
  final String text;
  final bool isMe;
  final String username;
  final DateTime createdAt;

  MessageModel({
    required this.text,
    required this.isMe,
    required this.username,
    required this.createdAt,
  });

  String get formattedTime {
    return '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
  }
}

// ================= MESSAGE GROUP =================
class MessageGroup extends StatelessWidget {
  final List<MessageModel> messages;
  const MessageGroup({super.key, required this.messages});

  Color getAvatarColor(String name) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
    ];
    return colors[name.hashCode % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final firstMessage = messages.first;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: firstMessage.isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!firstMessage.isMe) ...[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: getAvatarColor(firstMessage.username),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                firstMessage.username.substring(0, 2).toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: firstMessage.isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (!firstMessage.isMe)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      firstMessage.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ...messages.map(
                  (msg) => Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: msg.isMe
                            ? Colors.blue.withOpacity(0.15)
                            : Colors.grey.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: msg.isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            msg.text,
                            style: TextStyle(
                              fontSize: 14,
                              color: msg.isMe
                                  ? Colors.blue[800]
                                  : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            msg.formattedTime,
                            style: TextStyle(
                              fontSize: 10,
                              color: msg.isMe
                                  ? Colors.blueGrey
                                  : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (firstMessage.isMe) ...[
            const SizedBox(width: 8),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: getAvatarColor(firstMessage.username),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                firstMessage.username.substring(0, 2).toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}














// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:slack_clone/features/homeScreen/presentation/widget/chat_input_bar.dart';

// class ChatScreen extends StatefulWidget {
//   final String channelId;
//   final String channelName;

//   const ChatScreen({
//     super.key,
//     required this.channelId,
//     required this.channelName,
//   });

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _controller = TextEditingController();
//   final List<MessageModel> _messages = [];
//   bool isLoading = true;
//   late RealtimeChannel messagesSubscription;

//   final supabase = Supabase.instance.client;

//   @override
//   void initState() {
//     super.initState();
//     fetchMessages();
//     subscribeToMessages();
//   }

//   Future<void> fetchMessages() async {
//     final user = supabase.auth.currentUser;
//     if (user == null) {
//       log('No user logged in');
//       setState(() => isLoading = false);
//       return;
//     }

//     try {
//       final response = await supabase
//           .from('messages')
//           .select('content, sender_id, created_at, profiles!inner(username)')
//           .eq('channel_id', widget.channelId)
//           .order('created_at', ascending: true);

//       log('Fetched messages raw: $response');

//       setState(() {
//         _messages.clear();
//         _messages.addAll(
//           response.map<MessageModel>((e) {
//             log('Message item: $e');
//             return MessageModel(
//               text: e['content'] ?? 'no content',
//               isMe: e['sender_id'] == user.id,
//               username: e['profiles']?['username'] ?? 'no username',
//               createdAt: DateTime.parse(e['created_at']),
//             );
//           }),
//         );
//         isLoading = false;
//       });

//       log('Messages list length: ${_messages.length}');
//     } catch (e) {
//       log('Error fetching messages: $e');
//       setState(() => isLoading = false);
//     }
//   }

//   void subscribeToMessages() {
//     messagesSubscription = supabase
//         .channel('public:messages')
//         .onPostgresChanges(
//           event: PostgresChangeEvent.insert,
//           schema: 'public',
//           table: 'messages',
//           callback: (payload) {
//             log('Realtime payload: $payload');
//             if (payload.newRecord['channel_id'] == widget.channelId) {
//               final userId = supabase.auth.currentUser?.id;
//               final msg = MessageModel(
//                 text: payload.newRecord['content'] ?? 'no content',
//                 isMe: payload.newRecord['sender_id'] == userId,
//                 username:
//                     payload.newRecord['profiles']?['username'] ?? 'no username',
//                 createdAt: DateTime.parse(payload.newRecord['created_at']),
//               );

//               setState(() {
//                 _messages.add(msg);
//                 _messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
//               });
//             }
//           },
//         )
//         .subscribe();
//   }

//   Future<void> sendMessage(String content) async {
//     final user = supabase.auth.currentUser;
//     if (user == null) {
//       log('Cannot send: no user');
//       return;
//     }

//     try {
//       final res = await supabase.from('messages').insert({
//         'channel_id': widget.channelId,
//         'sender_id': user.id,
//         'content': content,
//         'created_at': DateTime.now().toIso8601String(),
//       });

//       log('Insert response: $res');

//       _controller.clear();
//     } catch (e) {
//       log('Send message error: $e');
//     }
//   }

//   @override
//   void dispose() {
//     supabase.removeChannel(messagesSubscription);
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('# ${widget.channelName}')),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 Expanded(
//                   child: _messages.isEmpty
//                       ? const Center(child: Text('No messages yet 👋'))
//                       : ListView.builder(
//                           padding: const EdgeInsets.all(16),
//                           itemCount: _messages.length,
//                           itemBuilder: (_, index) {
//                             return MessageBubble(message: _messages[index]);
//                           },
//                         ),
//                 ),
//                 ChatInputBar(
//                   controller: _controller,
//                   onSend: () {
//                     final text = _controller.text.trim();
//                     if (text.isEmpty) return;
//                     sendMessage(text);
//                   },
//                 ),
//               ],
//             ),
//     );
//   }
// }

// class MessageModel {
//   final String text;
//   final bool isMe;
//   final String username;
//   final DateTime createdAt;

//   MessageModel({
//     required this.text,
//     required this.isMe,
//     required this.username,
//     required this.createdAt,
//   });
// }

// // ================= MESSAGE BUBBLE =================
// class MessageBubble extends StatelessWidget {
//   final MessageModel message;

//   const MessageBubble({super.key, required this.message});

//   Color _generateColor(String username) {
//     // لون ثابت لكل يوزر حسب الاسم
//     final hash = username.hashCode;
//     final r = (hash & 0xFF0000) >> 16;
//     final g = (hash & 0x00FF00) >> 8;
//     final b = (hash & 0x0000FF);
//     return Color.fromARGB(255, r, g, b).withOpacity(0.8);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isMe = message.isMe;

//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: isMe
//             ? MainAxisAlignment.end
//             : MainAxisAlignment.start,
//         children: [
//           if (!isMe) ...[
//             // مربع اول حرفين من اسم اليوزر
//             Container(
//               width: 36,
//               height: 36,
//               decoration: BoxDecoration(
//                 color: _generateColor(message.username),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               alignment: Alignment.center,
//               child: Text(
//                 message.username.substring(0, 2).toUpperCase(),
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 8),
//           ],
//           // محتوى الرسالة
//           Flexible(
//             child: Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: isMe ? Colors.blue[400] : Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 4,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   if (!isMe)
//                     Text(
//                       message.username,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 13,
//                       ),
//                     ),
//                   const SizedBox(height: 2),
//                   Text(
//                     message.text,
//                     style: TextStyle(
//                       color: isMe ? Colors.white : Colors.black87,
//                       fontSize: 15,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     '${message.createdAt.hour.toString().padLeft(2, '0')}:${message.createdAt.minute.toString().padLeft(2, '0')}',
//                     style: TextStyle(
//                       fontSize: 10,
//                       color: isMe ? Colors.white70 : Colors.grey[600],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           if (isMe) const SizedBox(width: 36), // نفس المسافة للشكل المتناسق
//         ],
//       ),
//     );
//   }
// }































// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:slack_clone/features/homeScreen/presentation/widget/chat_input_bar.dart';

// class ChatScreen extends StatefulWidget {
//   final String channelId;
//   final String channelName;

//   const ChatScreen({
//     super.key,
//     required this.channelId,
//     required this.channelName,
//   });

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _controller = TextEditingController();
//   final List<MessageModel> _messages = [];
//   bool isLoading = true;
//   late RealtimeChannel messagesSubscription;

//   final supabase = Supabase.instance.client;

//   @override
//   void initState() {
//     super.initState();
//     fetchMessages();
//     subscribeToMessages();
//   }

//   Future<void> fetchMessages() async {
//     final user = supabase.auth.currentUser;
//     if (user == null) {
//       log('No user logged in');
//       setState(() => isLoading = false);
//       return;
//     }

//     try {
//       final response = await supabase
//           .from('messages')
//           .select('content, sender_id, created_at, profiles!inner(username)')
//           .eq('channel_id', widget.channelId)
//           .order('created_at', ascending: true);

//       log('Fetched messages raw: $response');

//       setState(() {
//         _messages.clear();
//         _messages.addAll(
//           response.map<MessageModel>((e) {
//             log('Message item: $e');
//             return MessageModel(
//               text: e['content'] ?? 'no content',
//               isMe: e['sender_id'] == user.id,
//               username: e['profiles']?['username'] ?? 'no username',
//               createdAt: DateTime.parse(e['created_at']),
//             );
//           }),
//         );
//         isLoading = false;
//       });

//       log('Messages list length: ${_messages.length}');
//     } catch (e) {
//       log('Error fetching messages: $e');
//       setState(() => isLoading = false);
//     }
//   }

//   void subscribeToMessages() {
//     messagesSubscription = supabase
//         .channel('public:messages')
//         .onPostgresChanges(
//           event: PostgresChangeEvent.insert,
//           schema: 'public',
//           table: 'messages',
//           callback: (payload) {
//             log('Realtime payload: $payload');
//             if (payload.newRecord['channel_id'] == widget.channelId) {
//               final userId = supabase.auth.currentUser?.id;
//               final msg = MessageModel(
//                 text: payload.newRecord['content'] ?? 'no content',
//                 isMe: payload.newRecord['sender_id'] == userId,
//                 username:
//                     payload.newRecord['profiles']?['username'] ?? 'no username',
//                 createdAt: DateTime.parse(payload.newRecord['created_at']),
//               );

//               setState(() {
//                 _messages.add(msg);
//                 _messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
//               });
//             }
//           },
//         )
//         .subscribe();
//   }

//   Future<void> sendMessage(String content) async {
//     final user = supabase.auth.currentUser;
//     if (user == null) {
//       log('Cannot send: no user');
//       return;
//     }

//     try {
//       final res = await supabase.from('messages').insert({
//         'channel_id': widget.channelId,
//         'sender_id': user.id,
//         'content': content,
//         'created_at': DateTime.now().toIso8601String(),
//       });

//       log('Insert response: $res');

//       _controller.clear();
//     } catch (e) {
//       log('Send message error: $e');
//     }
//   }

//   @override
//   void dispose() {
//     supabase.removeChannel(messagesSubscription);
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('# ${widget.channelName}')),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 Expanded(
//                   child: _messages.isEmpty
//                       ? const Center(child: Text('No messages yet 👋'))
//                       : ListView.builder(
//                           padding: const EdgeInsets.all(16),
//                           itemCount: _messages.length,
//                           itemBuilder: (_, index) {
//                             final msg = _messages[index];
//                             return ListTile(
//                               title: Text(msg.username),
//                               subtitle: Text(msg.text),
//                               trailing: msg.isMe
//                                   ? const Icon(Icons.check)
//                                   : null,
//                             );
//                           },
//                         ),
//                 ),
//                 ChatInputBar(
//                   controller: _controller,
//                   onSend: () {
//                     final text = _controller.text.trim();
//                     if (text.isEmpty) return;
//                     sendMessage(text);
//                   },
//                 ),
//               ],
//             ),
//     );
//   }
// }

// class MessageModel {
//   final String text;
//   final bool isMe;
//   final String username;
//   final DateTime createdAt;

//   MessageModel({
//     required this.text,
//     required this.isMe,
//     required this.username,
//     required this.createdAt,
//   });
// }
