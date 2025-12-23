import 'package:flutter/material.dart';
import 'package:slack_clone/features/homeScreen/presentation/chat_screen_view.dart';

class ChatScreenView extends StatelessWidget {
  final String channelId;
  final String channelName;

  const ChatScreenView({
    super.key,
    required this.channelId,
    required this.channelName,
  });

  @override
  Widget build(BuildContext context) {
    return ChatScreen(
      channelId: channelId,
      channelName: channelName,
    );
  }
}
