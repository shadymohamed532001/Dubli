import 'package:dupli/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ChatBotMessage extends StatelessWidget {
  const ChatBotMessage({super.key, required this.massage});
  final String massage;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: ColorManager.greyColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25)),
        child: Text(
          massage,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
