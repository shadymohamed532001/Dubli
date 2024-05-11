import 'package:dubli/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class AllTasksView extends StatelessWidget {
  const AllTasksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "All Screen",
        style: AppStyle.font22Whiteregular,
      ),
    );
  }
}