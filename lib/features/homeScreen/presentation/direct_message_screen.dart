// import 'package:flutter/material.dart';
// import 'package:slack_clone/features/homeScreen/presentation/view/direct_message_screen_view.dart';
// import 'package:slack_clone/features/homeScreen/presentation/widget/direct_message_row.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'direct_message_screen.dart';

// class DirectMessagesScreen extends StatefulWidget {
//   const DirectMessagesScreen({super.key});

//   @override
//   State<DirectMessagesScreen> createState() => _DirectMessagesScreenState();
// }

// class _DirectMessagesScreenState extends State<DirectMessagesScreen> {
//   final supabase = Supabase.instance.client;
//   List<DirectMessageRowModel> dmList = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchDirectMessages();
//   }

//   Future<void> fetchDirectMessages() async {
//     final userId = supabase.auth.currentUser!.id;

//     final response = await supabase
//         .from('direct_messages')
//         .select('*, profiles_sender(username), profiles_receiver(username)')
//         .or('sender_id.eq.$userId,receiver_id.eq.$userId')
//         .order('created_at', ascending: false);

//     Map<String, DirectMessageRowModel> grouped = {};

//     for (var msg in response) {
//       String otherId = msg['sender_id'] == userId
//           ? msg['receiver_id']
//           : msg['sender_id'];
//       String otherUsername = msg['sender_id'] == userId
//           ? msg['profiles_receiver']['username']
//           : msg['profiles_sender']['username'];

//       if (!grouped.containsKey(otherId)) {
//         grouped[otherId] = DirectMessageRowModel(
//           otherUserId: otherId,
//           otherUsername: otherUsername,
//           lastMessage: msg['content'],
//           lastMessageTime: DateTime.parse(msg['created_at']),
//         );
//       }
//     }

//     setState(() {
//       dmList = grouped.values.toList();
//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Direct Messages')),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: dmList.length,
//               itemBuilder: (_, index) {
//                 final dm = dmList[index];
//                 return DirectMessageRow(
//                   username: dm.otherUsername,
//                   lastMessage: dm.lastMessage,
//                   otherUserId: dm.otherUserId,
//                   formattedTime:
//                       '${dm.lastMessageTime.hour}:${dm.lastMessageTime.minute.toString().padLeft(2,'0')}',
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => DirectMessageScreenView(
//                           otherUserId: dm.otherUserId,
//                           otherUsername: dm.otherUsername,
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//     );
//   }
// }
