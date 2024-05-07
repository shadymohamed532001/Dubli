import 'package:dubli/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class FontWeightHelper {
  static const FontWeight thin = FontWeight.w100;
  static const FontWeight extralight = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semibold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extrabold = FontWeight.w800;
}

class AppStyle {
  // Black Color Styles

  static TextStyle font32blacksemibold = const TextStyle(
    fontSize: 32,
    fontWeight: FontWeightHelper.semibold,
    color: Colors.black,
  );
  static TextStyle font14blacksemibold = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeightHelper.semibold,
    color: Colors.black,
  );

  static TextStyle font20blacksemibold = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static TextStyle font16blacksemibold = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeightHelper.semibold,
    color: Colors.black,
  );
  static TextStyle font16blackmedium = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeightHelper.medium,
    color: Colors.black,
  );
  static TextStyle font14blackmedium = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeightHelper.medium,
    color: Colors.black,
  );

  // Grey Color Styles

  static TextStyle font14Greyregular = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Color(0xffA7A6A5),
  );
  static TextStyle font16Greyregular = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Color(0xffA7A6A5),
  );
  static TextStyle font14Greymedium = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Color(0xffA7A6A5),
  );
  static TextStyle font12Greymedium = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Color(0xff909090),
  );

  // Primary Color Styles
  static TextStyle font14Primaryregular = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: ColorManager.primaryColor,
  );
  static TextStyle font14Primarysemibold = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: ColorManager.primaryColor,
  );
  static TextStyle font18Primaryregular = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeightHelper.regular,
    color: ColorManager.primaryColor,
  );
  static TextStyle font30Primarymedium = const TextStyle(
    fontSize: 30,
    fontWeight: FontWeightHelper.medium,
    color: ColorManager.primaryColor,
  );
  // White Color Styles

  static TextStyle font14Whitesemibold = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  static TextStyle font15Whiteregular = const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );
  static TextStyle font16Whitesemibold = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
    static TextStyle font22Whitesemibold = const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  static TextStyle font18Whitemedium = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeightHelper.medium,
    color: Colors.white,
  );
  static TextStyle font30Whitesemibold = const TextStyle(
    fontSize: 30,
    fontWeight: FontWeightHelper.regular,
    color: ColorManager.whiteColor,
  );
  static TextStyle font40Whitesemibold = const TextStyle(
    fontSize: 40,
    fontWeight: FontWeightHelper.regular,
    color: ColorManager.whiteColor,
  );
  static TextStyle font70Whitesemibold = const TextStyle(
    fontSize: 70,
    fontWeight: FontWeightHelper.regular,
    color: ColorManager.whiteColor,
  );
  static TextStyle font80Whitesemibold = const TextStyle(
    fontSize: 80,
    fontWeight: FontWeightHelper.regular,
    color: ColorManager.whiteColor,
  );
}
