import 'package:dubli/feature/tasks/ui/widgets/task_group_item.dart';
import 'package:flutter/material.dart';

class EventsListView extends StatelessWidget {
  const EventsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: 11,
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.only(top: 8, left: 8, right: 8),
          child: TaskGroupItem(),
        );
      },
    );
  }
}
