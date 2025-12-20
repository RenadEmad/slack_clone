
import 'package:flutter/material.dart';

class WorkflowMessage extends StatelessWidget {
  const WorkflowMessage();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16),
              SizedBox(width: 6),
              Text(
                'Weekly icebreakers',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text('Happy Monday! How was your weekend?'),
        ],
      ),
    );
  }
}
