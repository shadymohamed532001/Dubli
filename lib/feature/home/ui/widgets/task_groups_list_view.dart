import 'package:dubli/feature/home/ui/widgets/task_group_item.dart';
import 'package:flutter/material.dart';

class TaskGroupsListView extends StatelessWidget {
  const TaskGroupsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: 11,
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.only(
            top: 8,
          ),
          child: TaskGroupItem(),
        );
      },
    );
  }
}
