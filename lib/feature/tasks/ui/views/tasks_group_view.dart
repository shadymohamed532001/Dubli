import 'package:dubli/feature/tasks/ui/widgets/tasks_group_view_body.dart';
import 'package:flutter/material.dart';

class TasksGroupView extends StatelessWidget {
  const TasksGroupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Task List',
        ),
      ),
      body: const TasksGroupViewBody(),
    );
  }
}
