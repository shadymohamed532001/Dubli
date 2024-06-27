import 'package:dubli/core/widgets/app_bottom.dart';
import 'package:dubli/feature/tasks/logic/tasks_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/app_colors.dart';

class BuildAddTasksDropdown extends StatefulWidget {
  const BuildAddTasksDropdown(
      {super.key,
      this.onPressed,
      required this.addController,
      required this.id});

  final void Function()? onPressed;
  final TextEditingController addController;
  final String id;

  @override
  State<BuildAddTasksDropdown> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<BuildAddTasksDropdown> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          builder: (context) {
            return AlertDialog(
              title: const Text('Add Task Group'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: widget.addController,
                    decoration: const InputDecoration(
                      hintText: 'Enter task name',
                    ),
                  ),
                  TextField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      hintText: 'Select Date',
                    ),
                    onTap: () => _selectDate(context),
                  ),
                  TextField(
                    controller: _timeController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      hintText: 'Select Time',
                    ),
                    onTap: () => _selectTime(context),
                  ),
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        String taskName = widget.addController.text.trim();
                        String taskDate = _dateController.text.trim();
                        String taskTime = _timeController.text.trim();

                        if (taskName.isNotEmpty &&
                            taskDate.isNotEmpty &&
                            taskTime.isNotEmpty) {
                          final taskDateTime = '$taskDate $taskTime';
                          BlocProvider.of<TasksCubit>(context).addTask(
                            widget.id,
                            taskName,
                            taskDateTime,
                          );
                          widget.onPressed!();
                          widget.addController.clear();
                          _dateController.clear();
                          _timeController.clear();
                        }
                      },
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
