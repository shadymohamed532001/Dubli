// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../utils/app_colors.dart';

void showTouster({
  required String massage,
  required ToustState state,
}) {
  Fluttertoast.showToast(
    msg: massage,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.TOP_RIGHT,
    timeInSecForIosWeb: 2,
    backgroundColor: showsToustColor(state),
    textColor: ColorManager.whiteColor,
    fontSize: 16.0,
  );
}

enum ToustState {
  SUCCESS,
  ERROR,
  WARNING,
}

Color showsToustColor(ToustState state) {
  Color? color;

  switch (state) {
    case ToustState.SUCCESS:
      color = ColorManager.darkyellowColor;
      break;
    case ToustState.ERROR:
      color = ColorManager.redColor;
      break;
    case ToustState.WARNING:
      color = ColorManager.greyColor;
      break;
  }
  return color;
}
