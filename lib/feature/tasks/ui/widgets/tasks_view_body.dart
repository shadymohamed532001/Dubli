import 'package:dubli/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class TasksViewBody extends StatelessWidget {
  const TasksViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Tasks View',
          style: AppStyle.font18Whitemedium,
        ),
        const Row()
      ],
    );
  }
}
