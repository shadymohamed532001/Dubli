import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:dubli/core/utils/app_colors.dart';
import 'package:dubli/core/utils/app_styles.dart';
import 'package:dubli/feature/tasks/ui/views/all_tasks_view.dart';
import 'package:dubli/feature/tasks/ui/views/done_tasks_view.dart';
import 'package:dubli/feature/tasks/ui/views/todo_tasks_view.dart';
import 'package:dubli/feature/tasks/ui/widgets/add_tasks_botton.dart';
import 'package:dubli/feature/tasks/ui/widgets/list_of_all_and_todo_and_done.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TasksDetailsViewBody extends StatefulWidget {
  const TasksDetailsViewBody({super.key});

  @override
  State<TasksDetailsViewBody> createState() => _TasksDetailsViewBodyState();
}

class _TasksDetailsViewBodyState extends State<TasksDetailsViewBody> {
  DateTime today = DateTime.now();
  int currentIndex = 0;

  final List<Widget> screens = [
    const AllTasksView(),
    const TodoTasksView(),
    const DoneTasksView(),
  ];
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
        ),
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: ListOfAllAndTodoAndDone(
                  currentIndex: currentIndex,
                  onTap: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                ),
              ),
              const AddTasksBotton()
            ],
          ),
        ),
        Expanded(
          child: screens[currentIndex],
        ),
      ],
    );
  }
}


