import 'package:flutter/material.dart';

class SystemMessage extends StatelessWidget {
  const SystemMessage();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            '# team-',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'You created this channel December 11th, 2025.\n'
            'This is the very beginning of the #team- channel.\n\n'
            'Purpose: This channel is for everything #new-channel.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
