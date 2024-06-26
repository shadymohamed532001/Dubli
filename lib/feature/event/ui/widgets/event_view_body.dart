import 'dart:developer';
import 'package:dubli/core/utils/app_colors.dart';
import 'package:dubli/core/utils/app_image_assets.dart';
import 'package:dubli/core/utils/app_styles.dart';
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
  State<EventViewBody> createState() => _EventViewBodyState();
}

class _EventViewBodyState extends State<EventViewBody> {
  DateTime today = DateTime.now();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<EventCubit>(context).getEventsWithDate(today.toString());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EventCubit, EventState>(
      listener: (context, state) {},
      builder: (context, state) {
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
                    BlocProvider.of<EventCubit>(context)
                        .getEventsWithDate(today.toIso8601String());
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
                SliverList.builder(
                  itemCount: state.events.length,
                  itemBuilder: (context, index) {
                    final startTime = DateTime.parse(
                        state.events[index]['fields']['startTime']);
                    final endTime = DateTime.parse(
                        state.events[index]['fields']['endTime']);

                    final startTimeFormatted =
                        DateFormat.Hm().format(startTime);
                    final endTimeFormatted = DateFormat.Hm().format(endTime);
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 4,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
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
                                  state.events[index]['name'],
                                  style: AppStyle.font16Whitesemibold,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      ImagesAssetsManager.applogoImage,
                                      width: 50,
                                      height: 50,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${state.events[index]['fields']['startTime'].toString().split('T')[0].toString()} | ${state.events[index]['fields']['endTime'].toString().split('T')[0].toString()}',
                                          style: AppStyle.font14Greyregular,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          state.events[index]['fields']
                                              ['description'],
                                          style: AppStyle.font16Whitesemibold,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      state.events[index]['fields']['reminder'],
                                      style: AppStyle.font14Greyregular,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
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
                                    // onTap: () => _showUpdateDialog(
                                    //   context,
                                    //   widget.taskGroupModel,
                                    //   widget.allTaskModel,
                                    // ),
                                    child: const Icon(
                                      Icons.edit,
                                      color: ColorManager.whiteColor,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  GestureDetector(
                                    // onTap: () =>
                                    //     _showDeleteConfirmationDialog(context),
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
        );
      },
    );
  }
}
