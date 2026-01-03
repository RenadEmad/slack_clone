import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:slack_clone/core/utils/powersync.dart';
import 'package:slack_clone/features/homeScreen/presentation/widget/message_group.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:slack_clone/features/homeScreen/presentation/widget/chat_input_bar.dart';

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

// Future<void> logout() async {
//   await Supabase.instance.client.auth.signOut();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _controller = TextEditingController();
//   final List<MessageModel> _messages = [];
//   bool isLoading = true;
//   late RealtimeChannel messagesSubscription;

//   final supabase = Supabase.instance.client;

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   fetchMessages();
//   //   subscribeToMessages();
//   // }
// Stream<List<MessageModel>> watchMessages({
//   required String channelId,
//   required String currentUserId,
// }) {
//   return db.watch(
//     '''
//     SELECT
//       m.content,
//       m.sender_id,
//       m.created_at,
//       p.username
//     FROM messages m
//     JOIN profiles p ON p.user_id = m.sender_id
//     WHERE m.channel_id = ?
//     ORDER BY m.created_at ASC
//     ''',
//     parameters: [channelId],
//   ).map((rows) {
//     return rows.map<MessageModel>((row) {
//       return MessageModel(
//         text: row['content'] as String,
//         isMe: row['sender_id'] == currentUserId,
//         username: row['username'] as String,
//         createdAt: DateTime.parse(row['created_at'] as String),
//       );
//     }).toList();
//   });
// }

// late Stream<List<MessageModel>> messagesStream;

// @override
// void initState() {
//   super.initState();
//   final userId = supabase.auth.currentUser!.id;

//   messagesStream = watchMessages(
//     channelId: widget.channelId,
//     currentUserId: userId,
//   );
// }

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

//       setState(() {
//         _messages.clear();
//         _messages.addAll(
//           response.map<MessageModel>((e) {
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
//     if (user == null) return;

//     try {
//       await supabase.from('messages').insert({
//         'channel_id': widget.channelId,
//         'sender_id': user.id,
//         'content': content,
//         'created_at': DateTime.now().toIso8601String(),
//       });
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

//   List<Widget> buildMessageGroups(List<MessageModel> messages) {
//     List<Widget> groups = [];
//     if (messages.isEmpty) return groups;

//     List<MessageModel> currentGroup = [messages.first];

//     for (int i = 1; i < messages.length; i++) {
//       if (messages[i].username == currentGroup.last.username) {
//         currentGroup.add(messages[i]);
//       } else {
//         groups.add(MessageGroup(messages: currentGroup));
//         currentGroup = [messages[i]];
//       }
//     }

//     groups.add(MessageGroup(messages: currentGroup));
//     return groups;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('# ${widget.channelName}')),
//       body:Expanded(
//   child: StreamBuilder<List<MessageModel>>(
//     stream: messagesStream,
//     builder: (context, snapshot) {
//       if (!snapshot.hasData) {
//         return const Center(child: CircularProgressIndicator());
//       }

//       final messages = snapshot.data!;

//       if (messages.isEmpty) {
//         return const Center(child: Text('No messages yet 👋'));
//       }

//       return ListView(
//         padding: const EdgeInsets.all(16),
//         children: buildMessageGroups(messages),
//       );
//     },
//   ),
// ),

//     );
//   }
// }

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

  List<Widget> buildMessageGroups(List<MessageModel> messages) {
    List<Widget> groups = [];
    if (messages.isEmpty) return groups;

    List<MessageModel> currentGroup = [messages.first];

    for (int i = 1; i < messages.length; i++) {
      if (messages[i].username == currentGroup.last.username) {
        currentGroup.add(messages[i]);
      } else {
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
