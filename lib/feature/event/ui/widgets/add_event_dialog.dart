import 'dart:developer';

import 'package:dubli/core/utils/app_colors.dart';
import 'package:dubli/feature/event/logic/event_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AddEventDialog extends StatefulWidget {
  const AddEventDialog({super.key});

  @override
  _AddEventDialogState createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
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

  void _onAddEventPressed() {
    final String startDateTime =
        '${DateFormat('yyyy-MM-dd').format(startDate!)}T${formatTime(starttimeOfDay)}';
    final String endDateTime =
        '${DateFormat('yyyy-MM-dd').format(endDate!)}T${formatTime(endtimeOfDay)}';

    BlocProvider.of<EventCubit>(context).addEvent(
      endEventTime: endDateTime,
      startEventTime: startDateTime,
      eventName: BlocProvider.of<EventCubit>(context).titleController.text,
      eventDescription:
          BlocProvider.of<EventCubit>(context).noteController.text,
      reminder: selectedReminder!,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Center(child: Text('Add Event')),
      content: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
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
              controller: BlocProvider.of<EventCubit>(context).titleController,
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
              controller: BlocProvider.of<EventCubit>(context).noteController,
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              startDate != null
                                  ? DateFormat('dd/MM/yyyy').format(startDate!)
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              endDate != null
                                  ? DateFormat('dd/MM/yyyy').format(endDate!)
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
            Row(children: [
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
                          color: Colors.black.withOpacity(0.5), // Border color
                          width: 1, // Border width
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
            ])
          ],
        )),
      ),
      actions: [
        Center(
          child: TextButton(
            style:
                TextButton.styleFrom(backgroundColor: const Color(0xff072247)),
            onPressed: _onAddEventPressed,
            child:
                const Text('Add Event', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
