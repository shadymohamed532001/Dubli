import 'package:dubli/core/helper/naviagtion_extentaions.dart';
import 'package:dubli/core/routing/routes.dart';
import 'package:dubli/core/utils/app_colors.dart';
import 'package:dubli/core/utils/app_styles.dart';
import 'package:dubli/core/widgets/app_bottom.dart';
import 'package:dubli/feature/tasks/logic/tasks_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TaskCompletedCircleIndicator extends StatelessWidget {
  const TaskCompletedCircleIndicator({super.key});

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
                    bottomtext: 'View tasks')
              ],
            ),
            Expanded(
              child: SizedBox(
                child: CircularPercentIndicator(
                  animation: true,
                  animationDuration: 1000,
                  radius: 90,
                  lineWidth: 20,
                  percent:
                      BlocProvider.of<TasksCubit>(context).precentNum / 100,
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
                        '${BlocProvider.of<TasksCubit>(context).precentNum}%',
                        style: AppStyle.font40Whitesemibold
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
