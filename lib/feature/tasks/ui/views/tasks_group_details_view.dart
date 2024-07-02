import 'package:dupli/core/utils/app_colors.dart';
import 'package:dupli/feature/tasks/data/models/all_tasks_name_model.dart';
import 'package:dupli/feature/tasks/logic/tasks_cubit.dart';
import 'package:dupli/feature/tasks/ui/widgets/tasks_group_details_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskGroupDetailsView extends StatelessWidget {
  const TaskGroupDetailsView({super.key, required this.taskModel});

  final TaskGroupModel taskModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
            BlocProvider.of<TasksCubit>(context).getTasksListName();
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: ColorManager.whiteColor,
          ),
        ),
        centerTitle: true,
        title: Text(
          taskModel.name,
        ),
      ),
      body: TasksGroupDetailsViewBody(
        taskGroupModel: taskModel,
      ),
    );
  }
}
