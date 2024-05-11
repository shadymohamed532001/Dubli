
import 'package:dubli/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class DoneTasksView extends StatelessWidget {
  const DoneTasksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Done Screen",
        style: AppStyle.font22Whiteregular,
      ),
    );
  }
}