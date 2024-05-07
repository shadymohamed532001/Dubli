import 'package:dubli/feature/tasks/ui/widgets/tasks_view_body.dart';
import 'package:flutter/material.dart';

class TasksView extends StatelessWidget {
  const TasksView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: TasksViewBody(),
    );
  }
}
