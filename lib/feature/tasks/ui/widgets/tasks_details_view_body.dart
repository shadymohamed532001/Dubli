// ignore_for_file: avoid_print

import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:dubli/core/utils/app_colors.dart';
import 'package:dubli/core/utils/app_styles.dart';
import 'package:dubli/feature/tasks/logic/tasks_cubit.dart';
import 'package:dubli/feature/tasks/ui/views/all_tasks_view.dart';
import 'package:dubli/feature/tasks/ui/views/done_tasks_view.dart';
import 'package:dubli/feature/tasks/ui/views/todo_tasks_view.dart';
import 'package:dubli/feature/tasks/ui/widgets/list_of_all_and_todo_and_done.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class TasksDetailsViewBody extends StatefulWidget {
  const TasksDetailsViewBody({super.key});

  @override
  State<TasksDetailsViewBody> createState() => _TasksDetailsViewBodyState();
}

class _TasksDetailsViewBodyState extends State<TasksDetailsViewBody> {
  DateTime today = DateTime.now();
  int currentIndex = 0;
  List<Map<String, dynamic>> tasks = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchTasksForCurrentIndex();
  }

  Future<void> fetchTasksForCurrentIndex() async {
    setState(() {
      isLoading = true;
    });

    List<Map<String, dynamic>> fetchedTasks;

    DateTime adjustedDate = today.subtract(const Duration(days: 2));
    String dateString = DateFormat('yyyy-MM-dd').format(adjustedDate.toUtc());

    switch (currentIndex) {
      case 0:
        fetchedTasks = await BlocProvider.of<TasksCubit>(context)
            .getTasksByDate(dateString);
        break;
      case 1:
        fetchedTasks = await BlocProvider.of<TasksCubit>(context)
            .getTasksByDateUndone(dateString);
        break;
      case 2:
        fetchedTasks = await BlocProvider.of<TasksCubit>(context)
            .getTasksByDateDone(dateString);
        break;
      default:
        fetchedTasks = [];
    }

    setState(() {
      tasks = fetchedTasks;
      isLoading = false;
    });
  }

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

                print(today);
                
                fetchTasksForCurrentIndex();
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
                      fetchTasksForCurrentIndex();
                    });
                  },
                  loading: isLoading,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: getCurrentView(),
        ),
      ],
    );
  }

  Widget getCurrentView() {
    switch (currentIndex) {
      case 0:
        return AllTasksView(tasks: tasks);
      case 1:
        return TodoTasksView(tasks: tasks);
      case 2:
        return DoneTasksView(tasks: tasks);
      default:
        return Container();
    }
  }
}
