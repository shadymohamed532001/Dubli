import 'package:dubli/feature/tasks/ui/widgets/add_task_view_body.dart';
import 'package:flutter/material.dart';

class AddTasksView extends StatelessWidget {
  const AddTasksView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AddTasksViewBody(),
    );
  }
}
