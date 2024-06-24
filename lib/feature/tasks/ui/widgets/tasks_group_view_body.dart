import 'package:dubli/feature/tasks/ui/widgets/task_group_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dubli/feature/tasks/logic/tasks_cubit.dart';
import 'package:dubli/feature/tasks/ui/widgets/task_completed_circle_indicator.dart';
import 'package:dubli/core/widgets/app_bottom.dart';
import 'package:dubli/core/utils/app_styles.dart';
import 'package:dubli/core/utils/app_colors.dart';
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
                      _buildAddDropdown(context),
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

  Widget _buildAddDropdown(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return CustomBottom(
      bottomHeight: 40,
      bottomWidth: 70,
      bottomtext: 'Add',
      textBottomStyle: const TextStyle(
        fontSize: 13,
        fontFamily: 'Raleway',
        color: ColorManager.primaryColor,
      ),
      backgroundColor: ColorManager.darkyellowColor,
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Add Task Group'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Enter group name',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  String groupName = controller.text.trim();
                  if (groupName.isNotEmpty) {
                    BlocProvider.of<TasksCubit>(context)
                        .addTaskListWithName(name: groupName);
                    controller.clear();
                  }
                },
                child: const Text('Add'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
  }
}
