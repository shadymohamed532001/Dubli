// ignore_for_file: library_private_types_in_public_api
import 'package:dubli/core/utils/app_styles.dart';
import 'package:dubli/feature/tasks/data/models/all_tasks_name_model.dart';
import 'package:dubli/feature/tasks/logic/tasks_cubit.dart';
import 'package:dubli/feature/tasks/ui/widgets/build_add_task.dart';
import 'package:dubli/feature/tasks/ui/widgets/tasks_group_details_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TasksGroupDetailsViewBody extends StatefulWidget {
  const TasksGroupDetailsViewBody({super.key, required this.taskGroupModel});
  final TaskGroupModel taskGroupModel;

  @override
  State<TasksGroupDetailsViewBody> createState() =>
      _TasksGroupDetailsViewBodyState();
}

class _TasksGroupDetailsViewBodyState extends State<TasksGroupDetailsViewBody> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<TasksCubit>(context).getTasks(widget.taskGroupModel.id);
  }

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<TasksCubit>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BuildAddTasksDropdown(
                addController: cubit.addTaskController,
                onPressed: () {},
                id: widget.taskGroupModel.id,
              )
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: BlocConsumer<TasksCubit, TasksState>(
              listener: (context, state) {
                if (state is AddTaskSuccess) {
                  cubit.getTasks(widget.taskGroupModel.id);
                }
              },
              builder: (context, state) {
                if (state is GetAllTasksLoading || state is AddTaskLoading) {
                  return const Center(
                    child: SpinKitThreeBounce(
                      color: Colors.white,
                      size: 30.0,
                    ),
                  );
                } else if (state is GetAllTasksErrorState) {
                  return Center(
                    child: Text(
                      'No tasks Found',
                      style: AppStyle.font22Whitesemibold,
                    ),
                  );
                } else if (state is GetAllTasksSuccessState) {
                  return ListView.builder(
                    itemCount: cubit.allTasks.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TasksGroupDetailsItem(
                          isDone: cubit.allTasks[index].done,
                          allTaskModel: cubit.allTasks[index],
                          taskGroupModel: widget.taskGroupModel,
                        ),
                      );
                    },
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
