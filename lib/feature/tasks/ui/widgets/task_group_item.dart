import 'package:dubli/core/helper/naviagtion_extentaions.dart';
import 'package:dubli/core/routing/routes.dart';
import 'package:dubli/core/utils/app_colors.dart';
import 'package:dubli/core/utils/app_image_assets.dart';
import 'package:dubli/feature/tasks/data/models/all_tasks_name_model.dart';
import 'package:dubli/feature/tasks/logic/tasks_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  final Task taskModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: CustomListTile(
        onTap: () {
          context.navigateTo(routeName: Routes.tasksViewsDetailsRoute);
        },
        imageAssetName: ImagesAssetsManager.applogoImage,
        subtitle: count.toString(),
        title: title,
        trailing: Column(
          children: [
            GestureDetector(
              onTap: () {
                BlocProvider.of<TasksCubit>(context).updateTaskListName(
                  newName: 'shadyyyyyy',
                  taskListId: taskModel.id,
                );
              },
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
              onTap: () {
                BlocProvider.of<TasksCubit>(context)
                    .deleteTaskList(taskListId: taskModel.id);
              },
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
}
