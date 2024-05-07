import 'package:dubli/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class FocusViewBody extends StatelessWidget {
  const FocusViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Focus View',
          style: AppStyle.font18Whitemedium,
        ),
        const Row()
      ],
    );
  }
}
