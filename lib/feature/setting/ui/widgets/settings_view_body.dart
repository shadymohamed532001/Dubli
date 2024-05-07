import 'package:dubli/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class SettingsViewBody extends StatelessWidget {
  const SettingsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Settings View',
          style: AppStyle.font18Whitemedium,
        ),
        const Row()
      ],
    );
  }
}
