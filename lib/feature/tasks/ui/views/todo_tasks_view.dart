
import 'package:dubli/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class TodoTasksView extends StatelessWidget {
  const TodoTasksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Todo Screen",
        style: AppStyle.font22Whiteregular,
      ),
    );
  }
}