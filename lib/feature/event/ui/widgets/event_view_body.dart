import 'dart:developer';

import 'package:dubli/feature/event/ui/widgets/event_and_add_event.dart';
import 'package:dubli/feature/event/ui/widgets/events_list_view.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class EventViewBody extends StatefulWidget {
  const EventViewBody({super.key});

  @override
  State<EventViewBody> createState() => _EventViewBodyState();
}

class _EventViewBodyState extends State<EventViewBody> {
  DateTime today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: today,
              selectedDayPredicate: (day) => isSameDay(day, today),
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
                  today = selectedDay;
                  log(today.toString());
                });
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
          const EventsListView()
        ],
      ),
    );
  }
}
