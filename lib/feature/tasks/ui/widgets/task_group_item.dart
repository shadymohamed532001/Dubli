import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dupli/core/helper/naviagtion_extentaions.dart';
import 'package:dupli/core/routing/routes.dart';
import 'package:dupli/core/utils/app_colors.dart';
import 'package:dupli/core/utils/app_image_assets.dart';
import 'package:dupli/feature/tasks/data/models/all_tasks_name_model.dart';
import 'package:dupli/feature/tasks/logic/tasks_cubit.dart';
import '../../../../core/widgets/custom_list_tile.dart';

class TaskGroupItem extends StatelessWidget {
  const TaskGroupItem({
    super.key,
    required this.title,
    required this.count,
    required this.taskModel,
  });

  final String title;
  final int count;
  final TaskGroupModel taskModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: CustomListTile(
        onTap: () {
          context.navigateTo(
            routeName: Routes.tasksGroupViewsDetailsRoute,
            arguments: taskModel,
          );
        },
        imageAssetName: getImageAsset(taskModel.name),
        subtitle: count.toString(),
        title: title,
        trailing: Column(
          children: [
            GestureDetector(
              onTap: () => _showUpdateDialog(context),
              child: const Icon(
                Icons.edit,
                color: ColorManager.whiteColor,
                size: 20,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () => _showDeleteConfirmationDialog(context),
              child: const Icon(
                Icons.delete,
                color: ColorManager.whiteColor,
                size: 20,
              ),
            )
          ],
        ),
      ),
    );
  }

  String getImageAsset(String taskName) {
    if (taskName == 'Study Plan by Dupli') {
      return ImagesAssetsManager.applogoImage;
    } else if (taskName == 'Tasks added by chatbot') {
      return ImagesAssetsManager.applogoImage;
    } else {
      return ImagesAssetsManager.clipboardImage;
    }
  }

  void _showUpdateDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Task Name'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter new task name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
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
                      BlocProvider.of<TasksCubit>(context).updateTaskListName(
                        newName: newName,
                        taskListId: taskModel.id,
                      );
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text('Update'),
                ),
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
                    BlocProvider.of<TasksCubit>(context)
                        .deleteTaskList(taskListId: taskModel.id);
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
