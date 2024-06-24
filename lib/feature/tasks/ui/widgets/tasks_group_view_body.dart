import 'package:dubli/feature/tasks/ui/widgets/build_add_tasks_drop_down.dart';
import 'package:dubli/feature/tasks/ui/widgets/task_group_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dubli/feature/tasks/logic/tasks_cubit.dart';
import 'package:dubli/feature/tasks/ui/widgets/task_completed_circle_indicator.dart';
import 'package:dubli/core/utils/app_styles.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TasksGroupViewBody extends StatefulWidget {
  const TasksGroupViewBody({super.key});

  @override
  State<TasksGroupViewBody> createState() => _TasksGroupViewBodyState();
}

class _TasksGroupViewBodyState extends State<TasksGroupViewBody> {
  @override
  void initState() {
    BlocProvider.of<TasksCubit>(context).getTasksListName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TasksCubit, TasksState>(
      listener: (context, state) {
        if (state is AddTaskListSuccess) {
          BlocProvider.of<TasksCubit>(context).getTasksListName();
        }
      },
      builder: (context, state) {
        var cubit = BlocProvider.of<TasksCubit>(context);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: TaskCompletedCircleIndicator(),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Task Groups',
                        style: AppStyle.font18Whitemedium.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      BuildAddTasksDropdown(
                        addController: cubit.addTaskGroupNameController,
                        onPressed: () {
                          cubit.addTaskListWithName(
                            name: cubit.addTaskGroupNameController.text.trim(),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
              if (state is GetTaskListNameSuccess)
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: TaskGroupItem(
                          title: state.tasks[index].name,
                          count: state.tasks[index].count,
                          taskModel: state.tasks[index],
                        ),
                      );
                    },
                    childCount: state.tasks.length,
                  ),
                )
              else if (state is GetTaskListNameLoading)
                const SliverToBoxAdapter(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SpinKitThreeBounce(
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
