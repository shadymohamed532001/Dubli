import 'package:dubli/feature/chat/ui/widgets/chat_bot_message.dart';
import 'package:dubli/feature/chat/ui/widgets/user_massage.dart';
import 'package:flutter/material.dart';

class MessagesWidget extends StatelessWidget {
  final String sender;
  final String message;
  final String timestamp;

  const MessagesWidget({
    super.key,
    required this.sender,
    required this.message,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          sender == 'user' ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            timestamp,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
        ),
        sender == 'user'
            ? UserMessage(massage: message)
            : ChatBotMessage(massage: message)
      ],
    );
  }
}
