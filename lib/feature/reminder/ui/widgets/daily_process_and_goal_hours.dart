// ignore_for_file: library_private_types_in_public_api

import 'package:dupli/core/utils/app_colors.dart';
import 'package:dupli/core/utils/app_styles.dart';
import 'package:dupli/feature/reminder/logic/reminder_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DailyProcessAndGoalHours extends StatefulWidget {
  const DailyProcessAndGoalHours({super.key});

  @override
  _DailyProcessAndGoalHoursState createState() =>
      _DailyProcessAndGoalHoursState();
}

class _DailyProcessAndGoalHoursState extends State<DailyProcessAndGoalHours> {
  int dailyGoal = 3;

  @override
  void initState() {
    super.initState();
    // Fetch the focus data when the widget is initialized
    context.read<ReminderCubit>().getFocus();
  }

  // void _showGoalInputDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       int newGoal = dailyGoal;
  //       return AlertDialog(
  //         title: const Text('Change Daily Goal'),
  //         content: TextField(
  //           keyboardType: TextInputType.number,
  //           decoration: const InputDecoration(hintText: "Enter new daily goal"),
  //           onChanged: (value) {
  //             newGoal = int.tryParse(value) ?? dailyGoal;
  //           },
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('Cancel'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           TextButton(
  //             child: const Text('Save'),
  //             onPressed: () {
  //               setState(() {
  //                 dailyGoal = newGoal;
  //               });
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReminderCubit, ReminderState>(
      builder: (context, state) {
        if (state is GetFocusLoading) {
          return const SizedBox(
            width: double.infinity,
            height: 300,
            child: Center(
              child: CircularProgressIndicator(
                color: ColorManager.darkyellowColor,
              ),
            ),
          );
        } else if (state is GetFocusError) {
          return Center(child: Text(state.error));
        } else if (state is GetFocusSuccess) {
          final focusData = state.focus['documents'];
          final yesterday = focusData[0]['fields']['yesterday'];
          final streak = focusData[0]['fields']['streak'];
          final dailyGoal = focusData[0]['fields']['goal'];

          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xffBAC1CB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Progress',
                  style: AppStyle.font16blackmedium.copyWith(
                    fontWeight: FontWeightHelper.regular,
                    fontSize: 20,
                    color: const Color(0xff072247),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Center(
                  child: CircleAvatar(
                    radius: 95,
                    backgroundColor: const Color(0xff777777),
                    child: CircleAvatar(
                      radius: 80,
                      backgroundColor: const Color(0xff072247),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Daily Goal',
                            style: AppStyle.font22Whitesemibold,
                          ),
                          GestureDetector(
                            child: Text(
                              dailyGoal,
                              style: AppStyle.font30Whitesemibold,
                            ),
                          ),
                          Text(
                            'Mins',
                            style: AppStyle.font22Whitesemibold,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Yesterday\n$yesterday\n Mins',
                      style: AppStyle.font20blacksemibold.copyWith(
                        color: const Color(0xff072247),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    Text(
                      'Streak\n $streak\n Day',
                      style: AppStyle.font20blacksemibold.copyWith(
                        color: const Color(0xff072247),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              ],
            ),
          );
        }
        return Container(); // Default empty container
      },
    );
  }
}
