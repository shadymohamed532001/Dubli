import 'package:dubli/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ChatTextFiled extends StatelessWidget {
  const ChatTextFiled({
    super.key,
    required TextEditingController controller,
  }) : _controller = controller;

  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Write a message..',
          hintStyle: const TextStyle(
            color: ColorManager.greyColor,
            fontSize: 14,
          ),
          filled: true,
          fillColor: const Color(0xFFECE4E4),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(60),
            borderSide: const BorderSide(
              color: Color(0xFFECE4E4),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(60),
            borderSide: const BorderSide(
              color: Color(0xFFECE4E4),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(60),
            borderSide: const BorderSide(
              color: Color(0xFFECE4E4),
            ),
          ),
        ),
      ),
    );
  }
}
