import 'package:dubli/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class ReminderViewBody extends StatelessWidget {
  const ReminderViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'ReminderViewBody',
          style: AppStyle.font18Whitemedium,
        ),
        const Row()
      ],
    );
  }
}
