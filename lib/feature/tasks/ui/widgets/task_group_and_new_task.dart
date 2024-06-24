import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dubli/core/utils/app_colors.dart';
import 'package:dubli/core/utils/app_styles.dart';
import 'package:dubli/core/widgets/app_bottom.dart';
import 'package:dubli/feature/tasks/logic/tasks_cubit.dart';

class TaskGroupAndNewTask extends StatelessWidget {
  const TaskGroupAndNewTask({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController taskNameController = TextEditingController();
    TextEditingController taskDateController = TextEditingController();
    TextEditingController taskPriorityController = TextEditingController();
    TextEditingController taskNoteController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Task Groups',
            style: AppStyle.font18Whitemedium.copyWith(
              fontWeight: FontWeight.w400,
            ),
          ),
          CustomBottom(
            bottomHeight: 40,
            bottomWidth: 80,
            bottomtext: 'Add',
            textBottomStyle: const TextStyle(
              fontSize: 13,
              fontFamily: 'Raleway',
              color: ColorManager.primaryColor,
            ),
            backgroundColor: ColorManager.darkyellowColor,
            onPressed: () {
              _showAddTaskDialog(
                  context,
                  taskNameController,
                  taskDateController,
                  taskPriorityController,
                  taskNoteController);
            },
          ),
        ],
      ),
    );
  }

  void _showAddTaskDialog(
      BuildContext context,
      TextEditingController taskNameController,
      TextEditingController taskDateController,
      TextEditingController taskPriorityController,
      TextEditingController taskNoteController) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Task Group Title'),
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  TextField(
                    controller: taskNameController,
                    decoration: const InputDecoration(labelText: 'Task Name'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                final String name = taskNameController.text.trim();
                final String date = taskDateController.text.trim();
                final String priorityText = taskPriorityController.text.trim();
                final String note = taskNoteController.text.trim();

                if (name.isEmpty ||
                    date.isEmpty ||
                    priorityText.isEmpty ||
                    note.isEmpty) {
                  // Show an error message if any field is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All fields are required.')),
                  );
                  return;
                }

                final int? priority = int.tryParse(priorityText);
                if (priority == null) {
                  // Show an error message if priority is not a valid integer
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Priority must be a valid number.')),
                  );
                  return;
                }

                BlocProvider.of<TasksCubit>(context).addTask(
                  '123', // Replace with actual taskListId if needed
                  name,
                  date,
                  priority,
                  note,
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
