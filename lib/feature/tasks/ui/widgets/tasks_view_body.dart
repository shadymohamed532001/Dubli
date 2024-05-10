import 'package:dubli/feature/tasks/ui/widgets/task_completed_circle_indicator.dart';
import 'package:dubli/feature/tasks/ui/widgets/task_group_and_new_task.dart';
import 'package:dubli/feature/tasks/ui/widgets/task_groups_list_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TasksViewBody extends StatelessWidget {
  const TasksViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: TaskCompletedCircleIndicator(),
          ),
          SliverToBoxAdapter(
            child: TaskGroupAndNewTask(),
          ),
          TaskGroupsListView(),
        ],
      ),
    );
  }
}
