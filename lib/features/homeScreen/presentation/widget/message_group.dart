import 'package:flutter/material.dart';

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
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: getAvatarColor(firstMessage.username),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              firstMessage.username[0],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.end,
                  //   children: [
                  //     Text(
                  //       firstMessage.username,
                  //       style: const TextStyle(
                  //         fontWeight: FontWeight.w900,
                  //         fontSize: 18,
                  //       ),
                  //     ),
                  //     const SizedBox(width: 8),
                  //     Padding(
                  //       padding: const EdgeInsets.only(bottom: 2),
                  //       child: Text(
                  //         firstMessage.formattedTime,
                  //         style: const TextStyle(
                  //           color: Colors.grey,
                  //           fontSize: 12,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Row(
                    children: [
                      Text(
                        firstMessage.username,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          color: firstMessage.isMe ? Colors.blue : Colors.black,
                        ),
                      ),

                      if (firstMessage.isMe) ...[
                        const SizedBox(width: 6),
                        Text(
                          '(You)',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],

                      const SizedBox(width: 9),

                      Text(
                        firstMessage.formattedTime,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 2),

                  ...messages.map(
                    (msg) => Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        msg.text,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 6),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class MessageModel {
//   final String text;
//   final bool isMe;
//   final String username;
//  final String time;
//    MessageModel({
//     required this.text,
//     required this.isMe,
//     required this.username,
//     required this.time,

//   });
// }

class MessageModel {
  final String text;
  final String username;
  final bool isMe;
  final DateTime createdAt;

  MessageModel({
    required this.text,
    required this.username,
    required this.isMe,
    required this.createdAt,
  });

  // String get formattedTime {
  //   if (createdAt == null) return '';
  //   return '${createdAt!.hour}:${createdAt!.minute.toString().padLeft(2, '0')}';
  // }
  String get formattedTime {
    return '${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')}';
  }
}
