import 'package:dubli/core/utils/app_colors.dart';
import 'package:dubli/feature/tasks/ui/widgets/build_add_tasks_group_name.dart';
import 'package:dubli/feature/tasks/ui/widgets/task_group_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    super.initState();
    BlocProvider.of<TasksCubit>(context).getTasksListName();
    BlocProvider.of<TasksCubit>(context)
        .calculateDoneTasksPercentage(DateTime.now().toString());
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
                      BuildAddTasksGroupNameDropdown(
                        addController: cubit.addTaskGroupNameController,
                        onPressed: () {
                          cubit.addTaskListWithName(
                            cubit.addTaskGroupNameController.text.trim(),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
              if (state is GetTaskListNameSuccess)
                state.tasks.isNotEmpty
                    ? SliverList(
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
                    : SliverToBoxAdapter(
                        child: Center(
                          child: Text(
                            'No task groups found. Please add some tasks.',
                            style: AppStyle.font22Whitesemibold,
                            textAlign: TextAlign.center,
                          ),
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
                )
              else if (state is GetTaskListNameError)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width / 2.2,
                    ),
                    child: const Center(
                      child: Text(
                        'NO Task Group Found',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ColorManager.whiteColor,
                        ),
                      ),
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
