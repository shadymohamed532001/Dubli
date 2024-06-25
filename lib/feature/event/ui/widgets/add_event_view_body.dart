import 'dart:developer';
import 'package:dubli/core/helper/validators_helper.dart';
import 'package:dubli/core/utils/app_colors.dart';
import 'package:dubli/core/utils/app_styles.dart';
import 'package:dubli/core/widgets/app_bottom.dart';
import 'package:dubli/core/widgets/app_text_formfield.dart';
import 'package:dubli/feature/event/logic/event_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AddEventViewBody extends StatefulWidget {
  const AddEventViewBody({super.key});

  @override
  State<AddEventViewBody> createState() => _AddEventViewBodyState();
}

class _AddEventViewBodyState extends State<AddEventViewBody> {
  TimeOfDay starttimeOfDay = TimeOfDay.now();
  TimeOfDay endtimeOfDay = TimeOfDay.now();
  DateTime? startDate;
  DateTime? endDate;
  String? selectedReminder = 'Never';
  final List<String> reminderItem = ["Daily", "Weekly", "Monthly", "Never"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocConsumer<EventCubit, EventState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = BlocProvider.of<EventCubit>(context);
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: cubit.formKey,
              autovalidateMode: cubit.autovalidateMode,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Event',
                    style: AppStyle.font22Whiteregular,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Title',
                    style: AppStyle.font18Whitemedium,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  CustomTextFormField(
                    controller: cubit.titleController,
                    hintStyle: TextStyle(
                      color: Colors.grey.withOpacity(0.6),
                    ),
                    obscureText: false,
                    hintText: 'Enter Title here',
                    fillColor: ColorManager.whiteColor,
                    validator: (text) {
                      return MyValidatorsHelper.tittleValidator(text);
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Note',
                    style: AppStyle.font18Whitemedium,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  CustomTextFormField(
                    controller: cubit.noteController,
                    hintStyle: TextStyle(
                      color: Colors.grey.withOpacity(0.6),
                    ),
                    obscureText: false,
                    hintText: 'Enter Note here',
                    fillColor: ColorManager.whiteColor,
                    validator: (text) {
                      return MyValidatorsHelper.noteValidator(text);
                    },
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
                            Text(
                              'Start Date',
                              style: AppStyle.font18Whitemedium,
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            CustomTextFormField(
                              obscureText: false,
                              hintText: startDate != null
                                  ? DateFormat('dd/MM/yyyy').format(startDate!)
                                  : 'Select Date',
                              fillColor: ColorManager.whiteColor,
                              hintStyle: TextStyle(
                                color: Colors.grey.withOpacity(0.6),
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  getDateFromUser(isStartDate: true);
                                },
                                child: Icon(
                                  Icons.calendar_month,
                                  color: Colors.grey.withOpacity(0.6),
                                ),
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
                            Text(
                              'End Date',
                              style: AppStyle.font18Whitemedium,
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            CustomTextFormField(
                              obscureText: false,
                              hintText: endDate != null
                                  ? DateFormat('dd/MM/yyyy').format(endDate!)
                                  : 'Select Date',
                              fillColor: ColorManager.whiteColor,
                              hintStyle: TextStyle(
                                color: Colors.grey.withOpacity(0.6),
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  getDateFromUser(isStartDate: false);
                                },
                                child: Icon(
                                  Icons.calendar_month,
                                  color: Colors.grey.withOpacity(0.6),
                                ),
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
                            Text(
                              'Start Time',
                              style: AppStyle.font18Whitemedium,
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            CustomTextFormField(
                              obscureText: false,
                              hintText: starttimeOfDay.format(context),
                              fillColor: ColorManager.whiteColor,
                              hintStyle: TextStyle(
                                color: Colors.grey.withOpacity(0.6),
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  getStartTimeFromUser();
                                },
                                child: Icon(
                                  Icons.schedule,
                                  color: Colors.grey.withOpacity(0.6),
                                ),
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
                            Text(
                              'End Time',
                              style: AppStyle.font18Whitemedium,
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            CustomTextFormField(
                              obscureText: false,
                              hintText: endtimeOfDay.format(context),
                              fillColor: ColorManager.whiteColor,
                              hintStyle: TextStyle(
                                color: Colors.grey.withOpacity(0.6),
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  getEndTimeFromUser();
                                },
                                child: Icon(
                                  Icons.schedule,
                                  color: Colors.grey.withOpacity(0.6),
                                ),
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
                  Text(
                    'Reminder',
                    style: AppStyle.font18Whitemedium,
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
                          style: AppStyle.font16Greyregular,
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedReminder = newValue;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          16,
                        ),
                      ),
                      fillColor: ColorManager.whiteColor,
                      filled: true,
                      hintText: 'Select Frequency',
                      hintStyle: TextStyle(
                        color: Colors.grey.withOpacity(0.1),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 8,
                  ),
              CustomBottom(
  onPressed: () {
    if (cubit.formKey.currentState!.validate()) {
      final String startDateTime = '${DateFormat('yyyy-MM-dd').format(startDate!)}T${formatTime(starttimeOfDay)}';
      final String endDateTime = '${DateFormat('yyyy-MM-dd').format(endDate!)}T${formatTime(endtimeOfDay)}';
      
      cubit.addEvent(
        endEventTime: endDateTime,
        eventDescription: cubit.noteController.text,
        eventName: cubit.titleController.text,
        reminder: selectedReminder!,
        startEventTime: startDateTime,
      );
    } else {
      setState(() {
        cubit.autovalidateMode = AutovalidateMode.always;
      });
    }
  },
  bottomtext: 'Add Event',
  backgroundColor: ColorManager.darkyellowColor,
  textBottomStyle: AppStyle.font18Whitemedium,
),

                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
String formatTime(TimeOfDay timeOfDay) {
  final now = DateTime.now();
  final dateTime = DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
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
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          startDate = pickedDate;
        } else {
          endDate = pickedDate;
        }
      });
    } else {
      log('Date is not selected');
    }
  }
}
