import 'package:dupli/feature/tasks/ui/widgets/tasks_details_view_body.dart';
import 'package:flutter/material.dart';

class TasksListView extends StatelessWidget {
  const TasksListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Task List',
        ),
      ),
      body: const TasksDetailsViewBody(),
    );
  }
}
