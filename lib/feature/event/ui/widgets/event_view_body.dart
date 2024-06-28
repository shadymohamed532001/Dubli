// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';
import 'package:dubli/core/utils/app_colors.dart';
import 'package:dubli/core/utils/app_styles.dart';
import 'package:dubli/core/widgets/app_bottom.dart';
import 'package:dubli/feature/event/data/models/get_all_event_model.dart';
import 'package:dubli/feature/event/logic/event_cubit.dart';
import 'package:dubli/feature/event/ui/widgets/add_event_dialog.dart';
import 'package:dubli/feature/event/ui/widgets/event_item.dart';
import 'package:dubli/feature/event/ui/widgets/update_event_dialog.dart';
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
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  Future<void> getTimeFromUser(bool isStartTime) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime ? starttimeOfDay : endtimeOfDay,
    );

    if (pickedTime != null) {
      setState(() {
        if (isStartTime) {
          starttimeOfDay = pickedTime;
        } else {
          endtimeOfDay = pickedTime;
        }
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
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          startDate = pickedDate;
          if (endDate != null && endDate!.isBefore(startDate!)) {
            endDate = startDate;
          }
        } else {
          if (startDate != null && startDate!.isAfter(pickedDate)) {
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
        return UpdateEventDialog(
          event: events[index],
        );
      },
    );
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return const AddEventDialog();
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
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = BlocProvider.of<EventCubit>(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Event View'),
          ),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                _buildCalendar(cubit),
                _buildEventHeader(),
                if (state is GetEventsLoading)
                  _buildLoadingIndicator()
                else if (state is GetEventsSuccess)
                  _buildEventList(state.events)
                else
                  _buildNoEventFound(),
              ],
            ),
          ),
        );
      },
    );
  }

  SliverToBoxAdapter _buildCalendar(EventCubit cubit) {
    return SliverToBoxAdapter(
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
          cubit.getEventsWithDate(cubit.today.toIso8601String());
        },
        availableGestures: AvailableGestures.all,
        headerStyle: const HeaderStyle(
          titleTextStyle: TextStyle(color: Colors.white),
          formatButtonVisible: false,
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildEventHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Events',
              style: AppStyle.font18Whitemedium.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
            CustomBottom(
              bottomHeight: 40,
              bottomWidth: 80,
              bottomtext: 'Add Event',
              backgroundColor: ColorManager.darkyellowColor,
              textBottomStyle: const TextStyle(
                fontSize: 13,
                fontFamily: 'Raleway',
                color: ColorManager.primaryColor,
              ),
              onPressed: () {
                _showAddDialog();
              },
            )
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildLoadingIndicator() {
    return SliverToBoxAdapter(
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
    );
  }

  SliverList _buildEventList(List<Event> events) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return EventItem(
            event: events[index],
            onUpdate: () => _showUpdateDialog(index, events),
            onDelete: () => _showDeleteDialog(index, events),
          );
        },
        childCount: events.length,
      ),
    );
  }

  SliverToBoxAdapter _buildNoEventFound() {
    return SliverToBoxAdapter(
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
    );
  }
}
