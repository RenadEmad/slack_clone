// import 'package:flutter/material.dart';

// class DirectMessageRow extends StatelessWidget {
//   final String username;
//   final String lastMessage;
//   final String otherUserId;
//   final VoidCallback onTap;
//   final String formattedTime;

//   const DirectMessageRow({
//     super.key,
//     required this.username,
//     required this.lastMessage,
//     required this.otherUserId,
//     required this.onTap,
//     required this.formattedTime,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       onTap: onTap,
//       leading: CircleAvatar(
//         child: Text(username.substring(0, 2).toUpperCase()),
//       ),
//       title: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(username, style: const TextStyle(fontWeight: FontWeight.bold)),
//           Text(formattedTime, style: const TextStyle(color: Colors.grey, fontSize: 12)),
//         ],
//       ),
//       subtitle: Text(lastMessage, overflow: TextOverflow.ellipsis),
//     );
//   }
// }

// class DirectMessageRowModel {
//   final String otherUserId;
//   final String otherUsername;
//   final String lastMessage;
//   final DateTime lastMessageTime;

//   DirectMessageRowModel({
//     required this.otherUserId,
//     required this.otherUsername,
//     required this.lastMessage,
//     required this.lastMessageTime,
//   });
// }
