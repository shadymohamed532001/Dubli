import 'package:dubli/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class DoneTasksView extends StatelessWidget {
  const DoneTasksView({super.key, required this.tasks});

  final List<Map<String, dynamic>> tasks;

  @override
  Widget build(BuildContext context) {
    return tasks.isEmpty
        ? Center(
            child: Text(
              "No Done Tasks",
              style: AppStyle.font22Whiteregular,
            ),
          )
        : ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return ListTile(
       title: Text(
                  tasks[index]['fields']['name'] ?? 'No Title',
                  style: AppStyle.font22Whitesemibold,
                ),
                subtitle: Text(
                  tasks[index]['fields']['date'] ?? 'No Description',
                  style: AppStyle.font30Whitesemibold,
                ),
              );
            },
          );
  }
}
