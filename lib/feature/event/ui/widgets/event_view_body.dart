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
  @override
  void initState() {
    super.initState();
    var cubit = BlocProvider.of<EventCubit>(context);
    cubit.getEventsWithDate(cubit.today.toString());
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
                  decoration: InputDecoration(
                    hintText: events[index].description,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Text(
                                'Start Time',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: '12:00 AM',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Text(
                                'End Time',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: '3:00 PM',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
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
                    // Add logic to update the event
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
