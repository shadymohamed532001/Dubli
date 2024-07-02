// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:dupli/core/helper/naviagtion_extentaions.dart';
import 'package:dupli/core/routing/routes.dart';
import 'package:dupli/core/utils/app_colors.dart';
import 'package:dupli/core/utils/app_styles.dart';
import 'package:dupli/core/widgets/app_bottom.dart';
import 'package:dupli/feature/tasks/logic/tasks_cubit.dart';

class TaskCompletedCircleIndicator extends StatefulWidget {
  const TaskCompletedCircleIndicator({super.key});

  @override
  State<TaskCompletedCircleIndicator> createState() =>
      _TaskCompletedCircleIndicatorState();
}

class _TaskCompletedCircleIndicatorState
    extends State<TaskCompletedCircleIndicator> {
  int _percentage = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTaskCompletionPercentage(
      date: DateTime.now().toString(),
    );
  }

  Future<void> _fetchTaskCompletionPercentage({required String date}) async {
    // Replace 'date' with the actual date you want to fetch tasks for
    int percentage = await calculateDoneTasksPercentage(context, date);
    setState(() {
      _percentage = percentage;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: ColorManager.darkGreyColor,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Row(
          children: [
            Column(
              children: [
                Text(
                  'Your today\'s task\nalmost done!',
                  style: AppStyle.font18Whitemedium.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomBottom(
                  bottomHeight: 40,
                  bottomWidth: 120,
                  backgroundColor: ColorManager.darkyellowColor,
                  onPressed: () {
                    
                    context.navigateTo(
                        routeName: Routes.tasksViewsDetailsRoute);
                  },
                  bottomtext: 'View tasks',
                  textBottomStyle: AppStyle.font14Greyregular
                      .copyWith(color: ColorManager.primaryColor),
                ),
              ],
            ),
            Expanded(
              child: CircularPercentIndicator(
                animation: true,
                animationDuration: 1000,
                radius: 90,
                lineWidth: 20,
                percent: _percentage / 100,
                progressColor: ColorManager.darkyellowColor,
                backgroundColor: ColorManager.darkGreyColor,
                circularStrokeCap: CircularStrokeCap.round,
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Completed',
                      style: AppStyle.font18Whitemedium,
                    ),
                    Text(
                      _isLoading ? '0%' : '$_percentage%',
                      style: AppStyle.font40Whitesemibold
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<int> calculateDoneTasksPercentage(
    BuildContext context, String date) async {
  print('inside calculateDoneTasksPercentage');
  // Dummy implementation, replace with your actual task fetching logic
  List<Map<String, dynamic>> doneTasks =
      await BlocProvider.of<TasksCubit>(context).getTasksByDateDone(date);
  List<Map<String, dynamic>> undoneTasks =
      await BlocProvider.of<TasksCubit>(context).getTasksByDateUndone(date);
  int undoneTasksCount = undoneTasks.length;
  int doneTasksCount = doneTasks.length;
  int totalTasks = doneTasksCount + undoneTasksCount;

  // Check if totalTasks is zero to avoid division by zero
  if (totalTasks == 0) {
    return 0;
  }

  double percentageDone = (doneTasksCount / totalTasks) * 100;
  int percent = percentageDone.ceil();
  print("percent: $percent");
  return percent;
}
