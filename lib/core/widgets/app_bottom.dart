import 'package:dubli/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomBottom extends StatelessWidget {
  const CustomBottom({
    super.key,
    required this.onPressed,
    this.backgroundColor,
    required this.bottomtext,
    this.bottomWidth,
    this.bottomHeight,
    this.textBottomStyle,
  });

  final void Function() onPressed;
  final Color? backgroundColor;
  final String bottomtext;
  final double? bottomWidth;
  final double? bottomHeight;
  final TextStyle? textBottomStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: bottomWidth ?? double.infinity,
      height: bottomHeight ?? 50,
      child: TextButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          backgroundColor: backgroundColor,
          shape: const StadiumBorder(
            side: BorderSide(
              color: ColorManager.primaryColor,
            ),
          ),
        ),
        child: Text(
          bottomtext,
          style: textBottomStyle,
        ),
      ),
    );
  }
}
