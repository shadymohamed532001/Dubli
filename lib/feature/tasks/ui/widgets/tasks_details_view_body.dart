import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:dubli/core/utils/app_colors.dart';
import 'package:dubli/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class TasksDetailsViewBody extends StatefulWidget {
  const TasksDetailsViewBody({super.key});

  @override
  State<TasksDetailsViewBody> createState() => _TasksDetailsViewBodyState();
}

class _TasksDetailsViewBodyState extends State<TasksDetailsViewBody> {
  DateTime today = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 20, top: 20),
          child: DatePicker(
            DateTime.now(),
            height: 100,
            width: 80,
            initialSelectedDate: today,
            selectionColor: ColorManager.darkyellowColor,
            dayTextStyle: AppStyle.font14Whitesemibold,
            monthTextStyle: AppStyle.font14Whitesemibold,
            dateTextStyle: AppStyle.font14Whitesemibold,
            onDateChange: (selectedDate) {
              setState(() {
                today = selectedDate;
              });
            },
          ),
        )
      ],
    );
  }
}
