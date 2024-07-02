import 'dart:developer';
import 'package:dupli/core/utils/app_colors.dart';
import 'package:dupli/feature/chat/logic/cubit/chat_cubit.dart';
import 'package:dupli/feature/event/logic/event_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:dupli/feature/tasks/logic/tasks_cubit.dart';

class AddEventBottomSheet extends StatefulWidget {
  const AddEventBottomSheet({super.key});

  @override
  State<AddEventBottomSheet> createState() => _AddEventBottomSheetState();
}

class _AddEventBottomSheetState extends State<AddEventBottomSheet> {
  final TextEditingController dateController = TextEditingController();

  TimeOfDay starttimeOfDay = TimeOfDay.now();
  TimeOfDay endtimeOfDay = TimeOfDay.now();
  DateTime? startDate;
  DateTime? endDate;
  String? selectedReminder = 'Never';
  final List<String> reminderItem = ["Daily", "Weekly", "Monthly", "Never"];

  String formatTime(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dateTime = DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    final formattedTime = DateFormat('HH:mm:ss').format(dateTime);
    return formattedTime;
  }

  Future<void> getStartTimeFromUser() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: starttimeOfDay,
    );

    if (pickedTime != null) {
      setState(() {
        starttimeOfDay = pickedTime;
      });
    } else {
      log('Time is not selected');
    }
  }

  Future<void> getEndTimeFromUser() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: endtimeOfDay,
    );

    if (pickedTime != null) {
      setState(() {
        endtimeOfDay = pickedTime;
      });
    } else {
      log('Time is not selected');
    }
  }

  Future<void> getDateFromUser({required bool isStartDate}) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? (startDate ?? DateTime.now())
          : (endDate ?? DateTime.now()),
      firstDate: isStartDate ? DateTime.now() : DateTime(DateTime.now().year),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          startDate = pickedDate;
          // Ensure end date is not before start date
          if (endDate != null && endDate!.isBefore(startDate!)) {
            endDate = startDate; // Reset end date if it's before start date
          }
        } else {
          // Ensure start date is not after end date
          if (startDate != null && startDate!.isAfter(pickedDate)) {
            // Show an error message or handle as needed
            log('End date cannot be before start date.');
          } else {
            endDate = pickedDate;
          }
        }
      });
    } else {
      log('Date is not selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksCubit, TasksState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(
              top: 8,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              left: 16,
              right: 16),
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Text(
                        'Name',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  TextFormField(
                    controller:
                        BlocProvider.of<ChatCubit>(context).titleController,
                    decoration: InputDecoration(
                      hintText: 'Add Event',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: BlocProvider.of<ChatCubit>(context)
                        .descriptionController,
                    decoration: InputDecoration(
                      hintText: 'Event Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Reminder',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedReminder,
                    items: reminderItem.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontSize: 16,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedReminder = newValue;
                      });
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          16,
                        ),
                      ),
                      filled: true,
                      hintText: 'Select Frequency',
                      hintStyle: TextStyle(
                        color: Colors.grey.withOpacity(0.1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Text(
                                'Start Date',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: ColorManager.blackColor
                                      .withOpacity(0.7), // Border color
                                  width: 1, // Border width
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    startDate != null
                                        ? DateFormat('dd/MM/yyyy')
                                            .format(startDate!)
                                        : 'Select Date',
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.5),
                                      fontSize: 16,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      getDateFromUser(isStartDate: true);
                                    },
                                    child: Icon(
                                      Icons.calendar_month,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Text(
                                'End Date',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: ColorManager.blackColor
                                      .withOpacity(0.7), // Border color
                                  width: 1, // Border width
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    endDate != null
                                        ? DateFormat('dd/MM/yyyy')
                                            .format(endDate!)
                                        : 'Select Date',
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.5),
                                      fontSize: 16,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      getDateFromUser(isStartDate: false);
                                    },
                                    child: Icon(
                                      Icons.calendar_month,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Text(
                                'Start Time',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.black
                                      .withOpacity(0.5), // Border color
                                  width: 1, // Border width
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    starttimeOfDay.format(context),
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.5),
                                      fontSize: 16,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      getStartTimeFromUser();
                                    },
                                    child: Icon(
                                      Icons.schedule,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Text(
                                'End Time',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.black.withOpacity(0.5),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    endtimeOfDay.format(context),
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.5),
                                      fontSize: 16,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      getEndTimeFromUser();
                                    },
                                    child: Icon(
                                      Icons.schedule,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xff072247),
                        ),
                        onPressed: () {
                          final String startDateTime =
                              '${DateFormat('yyyy-MM-dd').format(startDate!)}T${formatTime(starttimeOfDay)}';
                          final String endDateTime =
                              '${DateFormat('yyyy-MM-dd').format(endDate!)}T${formatTime(endtimeOfDay)}';
                          BlocProvider.of<EventCubit>(context).addEvent(
                            endEventTime: endDateTime,
                            startEventTime: startDateTime,
                            eventName: BlocProvider.of<ChatCubit>(context)
                                .titleController
                                .text,
                            eventDescription:
                                BlocProvider.of<ChatCubit>(context)
                                    .descriptionController
                                    .text,
                            reminder: selectedReminder!,
                          );
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Add Event',
                          style: TextStyle(color: ColorManager.whiteColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 80,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
