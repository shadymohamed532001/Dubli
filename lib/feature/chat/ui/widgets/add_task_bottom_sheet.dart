import 'package:flutter/material.dart';

class AddTaskBottomSheet extends StatelessWidget {
  final Function(String) onTaskAdded;

  const AddTaskBottomSheet({
    super.key,
    required this.onTaskAdded,
  });

  @override
  Widget build(BuildContext context) {
    String taskTitle = '';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            onChanged: (value) {
              taskTitle = value;
            },
            decoration: const InputDecoration(
              labelText: 'Task Title',
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (taskTitle.isNotEmpty) {
                Navigator.pop(context);
                onTaskAdded(taskTitle);
              }
            },
            child: const Text('Add Task'),
          ),
          const SizedBox(
            height: 200,
          ),
        ],
      ),
    );
  }
}
