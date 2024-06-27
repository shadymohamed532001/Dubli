// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';
import 'package:dubli/core/utils/app_colors.dart';
import 'package:dubli/core/utils/app_image_assets.dart';
import 'package:dubli/core/utils/app_styles.dart';
import 'package:dubli/feature/event/data/models/get_all_event_model.dart';
import 'package:dubli/feature/event/logic/event_cubit.dart';
import 'package:dubli/feature/event/ui/widgets/event_and_add_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class EventViewBody extends StatefulWidget {
  const EventViewBody({super.key});

  @override
  _EventViewBodyState createState() => _EventViewBodyState();
}

class _EventViewBodyState extends State<EventViewBody> {
  TimeOfDay starttimeOfDay = TimeOfDay.now();
  TimeOfDay endtimeOfDay = TimeOfDay.now();
  DateTime? startDate;
  DateTime? endDate;
  String? selectedReminder = 'Never';
  final List<String> reminderItem = ["Daily", "Weekly", "Monthly", "Never"];

  @override
  void initState() {
    super.initState();
    var cubit = BlocProvider.of<EventCubit>(context);
    cubit.getEventsWithDate(cubit.today.toString());
  }

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

  void _showUpdateDialog(int index, List<Event> events) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Center(
            child: Text('Update ${events[index].name}'),
          ),
          content: Container(
            width: MediaQuery.of(context).size.width, // Adjust width as needed
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
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
                      BlocProvider.of<EventCubit>(context).editTitleController,
                  decoration: InputDecoration(
                    hintText: events[index].name,
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
                  controller:
                      BlocProvider.of<EventCubit>(context).dateController,
                  decoration: InputDecoration(
                    hintText: events[index].description,
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
// Border color
                                width: 1, // Border width
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
                  ],
                ),
              ],
            ),
          ),
          actions: [
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
                    BlocProvider.of<EventCubit>(context).editEvent(
                      eventId: events[index].id,
                      endEventTime: endDateTime,
                      startEventTime: startDateTime,
                      eventName: BlocProvider.of<EventCubit>(context)
                          .editTitleController
                          .text,
                      eventDescription: BlocProvider.of<EventCubit>(context)
                          .editNoteController
                          .text,
                      reminder: selectedReminder!,
                    );
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(color: ColorManager.whiteColor),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(int index, List<Event> events) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Event'),
          content: const Text('Are you sure you want to delete this event?'),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    BlocProvider.of<EventCubit>(context)
                        .deleteEvent(eventId: events[index].id);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Delete'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EventCubit, EventState>(
      listener: (context, state) {
        if (state is AddEventSuccess) {
          BlocProvider.of<EventCubit>(context).getEventsWithDate(
              BlocProvider.of<EventCubit>(context).today.toString());
        }
      },
      builder: (context, state) {
        var cubit = BlocProvider.of<EventCubit>(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Event View'),
          ),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: TableCalendar(
                    firstDay: DateTime.utc(2020, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 14),
                    focusedDay: cubit.today,
                    selectedDayPredicate: (day) => isSameDay(day, cubit.today),
                    calendarStyle: const CalendarStyle(
                      defaultTextStyle: TextStyle(color: Colors.white),
                      todayTextStyle: TextStyle(color: Colors.white),
                      selectedTextStyle: TextStyle(color: Colors.white),
                      weekendTextStyle: TextStyle(color: Colors.white),
                      outsideTextStyle: TextStyle(color: Colors.white),
                      outsideDaysVisible: false,
                    ),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        cubit.today = selectedDay;
                        log(cubit.today.toString());
                      });

                      BlocProvider.of<EventCubit>(context)
                          .getEventsWithDate(cubit.today.toIso8601String());
                    },
                    availableGestures: AvailableGestures.all,
                    headerStyle: const HeaderStyle(
                      titleTextStyle: TextStyle(color: Colors.white),
                      formatButtonVisible: false,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: EventAndAddEvent(),
                ),
                if (state is GetEventsLoading)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.width / 4,
                      ),
                      child: const Center(
                        child: SpinKitThreeBounce(
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ),
                    ),
                  )
                else if (state is GetEventsSuccess)
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final startTime = DateTime.parse(
                            state.events[index].startTime.toString());
                        final endTime = DateTime.parse(
                            state.events[index].endTime.toString());

                        final startTimeFormatted =
                            DateFormat.Hm().format(startTime);
                        final endTimeFormatted =
                            DateFormat.Hm().format(endTime);

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 4),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: ColorManager.darkGreyColor,
                                width: 2,
                              ),
                              color: Colors.transparent,
                            ),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      state.events[index].name,
                                      style: AppStyle.font16Whitesemibold,
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Image.asset(
                                          ImagesAssetsManager.applogoImage,
                                          width: 50,
                                          height: 50,
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${state.events[index].startTime.toString().split(' ')[0].toString()} | ${state.events[index].endTime.toString().split(' ')[0].toString()}',
                                              style: AppStyle.font14Greyregular,
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              state.events[index].description,
                                              style:
                                                  AppStyle.font16Whitesemibold,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Text(
                                          state.events[index].reminder,
                                          style: AppStyle.font14Greyregular,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          '$startTimeFormatted | $endTimeFormatted',
                                          style: AppStyle.font14Greyregular,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _showUpdateDialog(
                                              index, state.events);
                                        },
                                        child: const Icon(
                                          Icons.edit,
                                          color: ColorManager.whiteColor,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      GestureDetector(
                                        onTap: () {
                                          _showDeleteDialog(
                                              index, state.events);
                                        },
                                        child: const Icon(
                                          Icons.delete,
                                          color: ColorManager.whiteColor,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: state.events.length,
                    ),
                  )
                else
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.width / 2.8,
                      ),
                      child: const Center(
                        child: Text(
                          'No events found, Please Add an event',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
