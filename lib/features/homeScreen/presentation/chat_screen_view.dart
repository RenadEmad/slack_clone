// import 'package:flutter/material.dart';
// import 'package:slack_clone/features/homeScreen/presentation/widget/chat_input_bar.dart';
// import 'package:slack_clone/features/homeScreen/presentation/widget/message_group.dart';
// import 'package:slack_clone/features/homeScreen/presentation/widget/system_message.dart';
// import 'package:slack_clone/features/homeScreen/presentation/widget/user_join_message.dart';
// import 'package:slack_clone/features/homeScreen/presentation/widget/work_flow_message.dart';

// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key});

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _controller = TextEditingController();

//   final List<MessageModel> _messages = [
//     MessageModel(text: 'Hello Renad ', isMe: false, username: 'Slack Bot'),
//     MessageModel(text: 'Feeling great!', isMe: false, username: 'Slack Bot'),
//     MessageModel(text: 'Hi! How are you?', isMe: true, username: 'Renad'),
//     MessageModel(text: 'I am fine, thanks!', isMe: true, username: 'Renad'),
//     MessageModel(text: 'Who are you', isMe: true, username: 'Renad'),
//   ];

//   void _sendMessage() {
//     if (_controller.text.trim().isEmpty) return;

//     setState(() {
//       _messages.add(
//         MessageModel(
//           text: _controller.text.trim(),
//           isMe: true,
//           username: 'Renad',
//         ),
//       );
//     });

//     _controller.clear();
//   }

//   List<List<MessageModel>> _groupMessages(List<MessageModel> messages) {
//     List<List<MessageModel>> grouped = [];
//     for (var message in messages) {
//       if (grouped.isEmpty || grouped.last.first.username != message.username) {
//         grouped.add([message]);
//       } else {
//         grouped.last.add(message);
//       }
//     }
//     return grouped;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final groupedMessages = _groupMessages(_messages);

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         leading: const BackButton(color: Colors.black),
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: const [
//             Text(
//               '# team-',
//               style: TextStyle(
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 2),
//             Text(
//               '2 members • 4 tabs',
//               style: TextStyle(color: Colors.grey, fontSize: 12),
//             ),
//           ],
//         ),
//         actions: const [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 12),
//             child: Icon(Icons.headphones, color: Colors.black),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView(
//               padding: const EdgeInsets.all(16),
//               children: [
//                 const SystemMessage(),
//                 const SizedBox(height: 12),
//                 const UserJoinMessage(),
//                 const SizedBox(height: 12),
//                 const WorkflowMessage(),
//                 const SizedBox(height: 12),
//                 ...groupedMessages.map(
//                   (group) => MessageGroup(messages: group),
//                 ),
//               ],
//             ),
//           ),
//           ChatInputBar(controller: _controller, onSend: _sendMessage),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:slack_clone/main.dart';
import 'package:slack_clone/features/homeScreen/presentation/widget/chat_input_bar.dart';
import 'package:slack_clone/features/homeScreen/presentation/widget/message_group.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  late RealtimeChannel messagesSubscription;

  @override
  void initState() {
    super.initState();
    fetchMessages();
    subscribeToMessages();
  }

  /// 🔹 جلب الرسائل الخاصة بالقناة
  Future<void> fetchMessages() async {
    final response = await supabase
        .from('messages')
        .select()
        .eq('channel_id', widget.channelId)
        .order('created_at');

    setState(() {
      _messages.clear();
      _messages.addAll(
        response.map<MessageModel>(
          (e) => MessageModel(
            text: e['content'],
            isMe: e['sender_id'] == supabase.auth.currentUser!.id,
            username: e['sender_name'] ?? 'User',
          ),
        ),
      );
    });
  }

  /// 🔹 Realtime
  void subscribeToMessages() {
    messagesSubscription = supabase
        .channel('messages:${widget.channelId}')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'channel_id',
            value: widget.channelId,
          ),
          callback: (payload) {
            final data = payload.newRecord;
            setState(() {
              _messages.add(
                MessageModel(
                  text: data['content'],
                  isMe:
                      data['sender_id'] ==
                      supabase.auth.currentUser!.id,
                  username: data['sender_name'] ?? 'User',
                ),
              );
            });
          },
        )
        .subscribe();
  }

  /// 🔹 إرسال رسالة
  Future<void> sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final user = supabase.auth.currentUser!;
    _controller.clear();

    await supabase.from('messages').insert({
      'channel_id': widget.channelId,
      'content': text,
      'sender_id': user.id,
      'sender_name': user.email, // أو username
    });
  }

  List<List<MessageModel>> groupMessages(List<MessageModel> messages) {
    List<List<MessageModel>> grouped = [];
    for (var msg in messages) {
      if (grouped.isEmpty ||
          grouped.last.first.username != msg.username) {
        grouped.add([msg]);
      } else {
        grouped.last.add(msg);
      }
    }
    return grouped;
  }

  @override
  void dispose() {
    supabase.removeChannel(messagesSubscription);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groupedMessages = groupMessages(_messages);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          '# ${widget.channelName}',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: groupedMessages.length,
              itemBuilder: (_, index) {
                return MessageGroup(
                  messages: groupedMessages[index],
                );
              },
            ),
          ),
          ChatInputBar(
            controller: _controller,
            onSend: sendMessage,
          ),
        ],
      ),
    );
  }
}
