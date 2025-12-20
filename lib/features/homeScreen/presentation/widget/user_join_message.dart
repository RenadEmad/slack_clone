import 'package:flutter/material.dart';

class UserJoinMessage extends StatelessWidget {
  const UserJoinMessage();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(child: Text('S')),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Slack bot',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  "Your workspace is on a free trial through January 9th V. "
                  "Now's a good time to make sure your whole team is here.",
                  style: TextStyle(color: Colors.black.withOpacity(0.9)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}