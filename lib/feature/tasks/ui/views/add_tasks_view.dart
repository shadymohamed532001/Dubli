import 'package:dupli/core/helper/naviagtion_extentaions.dart';
import 'package:dupli/feature/tasks/ui/widgets/add_task_view_body.dart';
import 'package:flutter/material.dart';

class AddTasksView extends StatelessWidget {
  const AddTasksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            context.pop();
          },
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: const AddTasksViewBody(),
    );
  }
}
