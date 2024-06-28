import 'package:dubli/core/utils/app_colors.dart';
import 'package:dubli/core/utils/app_styles.dart';
import 'package:dubli/feature/tasks/data/models/all_task_model.dart';
import 'package:dubli/feature/tasks/data/models/all_tasks_name_model.dart';
import 'package:dubli/feature/tasks/logic/tasks_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TasksGroupDetailsItem extends StatefulWidget {
  const TasksGroupDetailsItem({
    super.key,
    required this.isDone,
    required this.allTaskModel,
    required this.taskGroupModel,
  });

  final bool isDone;
  final AllTaskModel allTaskModel;
  final TaskGroupModel taskGroupModel;

  @override
  State<TasksGroupDetailsItem> createState() => _TasksGroupDetailsItemState();
}

class _TasksGroupDetailsItemState extends State<TasksGroupDetailsItem> {
  bool isDone = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColorManager.darkGreyColor,
          width: 2,
        ),
        color: Colors.transparent,
      ),
      child: Row(
        children: [
          Checkbox(
            activeColor: ColorManager.darkyellowColor,
            value: widget.isDone,
            onChanged: (bool? value) {
              setState(() {
                isDone = value!;
              });

              BlocProvider.of<TasksCubit>(context).toggleTaskDone(
                  widget.taskGroupModel.id, widget.allTaskModel.id);
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateFormat(
                  'dd/MM/yyyy, h:mm a',
                ).format(widget.allTaskModel.date),
                style: AppStyle.font15Whiteregular,
              ),
              Text(
                widget.allTaskModel.name,
                style: AppStyle.font15Whiteregular,
              ),
            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => _showUpdateDialog(
                      context, widget.taskGroupModel, widget.allTaskModel),
                  child: const Icon(
                    Icons.edit,
                    color: ColorManager.whiteColor,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _showDeleteConfirmationDialog(context),
                  child: const Icon(
                    Icons.delete,
                    color: ColorManager.whiteColor,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showUpdateDialog(
    BuildContext context,
    TaskGroupModel taskGroupModel,
    AllTaskModel allTaskModel,
  ) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Task Name'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter new task name',
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    final newName = controller.text;
                    if (newName.isNotEmpty) {
                      BlocProvider.of<TasksCubit>(context).updateTask(
                        taskListId: taskGroupModel.id,
                        taskId: allTaskModel.id,
                        name: controller.text,
                        date: allTaskModel.date.toString(),

                        // Todo: update date
                      );
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text('Update'),
                )
              ],
            )
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    BlocProvider.of<TasksCubit>(context).deleteTask(
                      taskId: widget.allTaskModel.id,
                      taskListId: widget.taskGroupModel.id,
                    );
                    Navigator.of(context).pop();
                  },
                  child: const Text('Delete'),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
