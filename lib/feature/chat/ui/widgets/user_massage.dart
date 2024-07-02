import 'package:dupli/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class UserMessage extends StatelessWidget {
  const UserMessage({super.key, required this.massage});
  final String? massage;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: ColorManager.darkyellowColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          massage!,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
