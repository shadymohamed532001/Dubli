import 'package:dubli/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';

class SettingsOptionItem extends StatelessWidget {
  const SettingsOptionItem({super.key, required this.tittle, this.onTap});
  final String tittle;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          tittle,
          style: AppStyle.font18Whitemedium,
        ),
        GestureDetector(
          onTap: onTap,
          child: const Icon(
            Icons.arrow_forward_ios,
            color: ColorManager.whiteColor,
          ),
        )
      ],
    );
  }
}
