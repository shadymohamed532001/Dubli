import 'package:dubli/core/utils/app_colors.dart';
import 'package:dubli/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.onChanged,
    this.onFieldSubmitted,
    this.onSaved,
    required this.hintText,
    this.maxLine = 1,
    this.filled,
    this.fillColor,
    this.controller,
    required this.obscureText,
    this.suffixIcon,
    this.prefixIcon,
    this.keyboardType,
    this.validator,
    this.decoration, this.hintStyle,  this.endable,
  });

  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final String hintText;
  final int? maxLine;
  final bool obscureText;
  final bool? filled;
  final TextEditingController? controller;
  final Color? fillColor;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final InputDecoration? decoration;
  final TextStyle? hintStyle ;

  final bool  ?endable  ;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled:endable ,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      maxLines: maxLine,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 16),
      controller: controller,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      onSaved: onSaved,
      validator: validator,
      decoration: (decoration ??
      
          InputDecoration(
            suffixIcon: suffixIcon,
            suffixIconColor: const Color.fromARGB(255, 101, 98, 98),
            prefixIcon: prefixIcon,
            filled: true,
            fillColor: fillColor ??
                ColorManager
                    .darkGreyColor, // Using provided fillColor or default grey color
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: ColorManager.primaryColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: ColorManager.primaryColor,
              ),
            ),
            errorBorder: buildOutlineInputBorder(width: 1),
            focusedErrorBorder: buildOutlineInputBorder(width: 2),
            hintText: hintText,
            hintStyle: hintStyle ?? AppStyle.font14Primaryregular,
          )),
    );
  }
}

OutlineInputBorder buildOutlineInputBorder({required double width}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide(
      width: width,
      color: ColorManager.primaryColor,
    ),
  );
}
