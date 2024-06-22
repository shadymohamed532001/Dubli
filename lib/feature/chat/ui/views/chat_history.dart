import 'package:dubli/core/utils/app_colors.dart';
import 'package:dubli/feature/chat/ui/widgets/chat_history_body.dart';
import 'package:flutter/material.dart';

class ChatHistory extends StatelessWidget {
  const ChatHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Chat History",
          style: TextStyle(
            color: ColorManager.whiteColor,
          ),
        ),
      ),
      body: const ChatHistoryBody(),
    );
  }
}
