import 'dart:async';
import 'package:dupli/core/helper/naviagtion_extentaions.dart';
import 'package:dupli/core/routing/routes.dart';
import 'package:dupli/core/utils/app_colors.dart';
import 'package:dupli/core/utils/app_styles.dart';
import 'package:dupli/core/widgets/app_bottom.dart';
import 'package:dupli/feature/reminder/logic/reminder_cubit.dart';
import 'package:dupli/feature/reminder/ui/widgets/daily_process_and_goal_hours.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReminderViewBody extends StatefulWidget {
  const ReminderViewBody({super.key});

  @override
  State<ReminderViewBody> createState() => _ReminderViewBodyState();
}

class _ReminderViewBodyState extends State<ReminderViewBody> {
  @override
  void initState() {
    BlocProvider.of<ReminderCubit>(context).getFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xff51647E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const FocusSessionAndTimer(),
                  const SizedBox(
                    height: 20,
                  ),
                  const DailyProcessAndGoalHours(),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      context.navigateTo(
                        routeName: Routes.tasksViewsDetailsRoute,
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 80,
                      decoration: BoxDecoration(
                        color: ColorManager.darkGreyColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/task.png',
                            height: 35,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'View Today Tasks',
                            style: AppStyle.font22Whitesemibold.copyWith(
                              color: const Color(0xff072247),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class FocusSessionAndTimer extends StatefulWidget {
  const FocusSessionAndTimer({super.key});

  @override
  _FocusSessionAndTimerState createState() => _FocusSessionAndTimerState();
}

class _FocusSessionAndTimerState extends State<FocusSessionAndTimer> {
  Timer? _timer;
  int _secondsRemaining = 0;
  String _timeDisplay = "00:00";
  bool _isWorking = false;
  bool _isPaused = false;
  int _sessionDurationMinutes = 45;

  void _showSessionDurationPicker() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: 0,
        minute: _sessionDurationMinutes % 60,
      ),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    ).then((selectedTime) {
      if (selectedTime != null) {
        setState(() {
          _sessionDurationMinutes = selectedTime.minute;
        });
      }
    });
  }

  void _startWorkSession() {
    setState(() {
      _isWorking = true;
      _isPaused = false;
      _secondsRemaining = _sessionDurationMinutes * 60; // Convert minutes to seconds
      _updateTimerDisplay();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_secondsRemaining > 0) {
            _secondsRemaining--;
            _updateTimerDisplay();
          } else {
            _timer?.cancel();
            _showBreakDialog();
          }
        });
      });
    });
  }

  void _resumeWorkSession() {
    setState(() {
      _isPaused = false;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_secondsRemaining > 0) {
            _secondsRemaining--;
            _updateTimerDisplay();
          } else {
            _timer?.cancel();
            _showBreakDialog();
          }
        });
      });
    });
  }

  void _pauseWorkSession() {
    setState(() {
      _isPaused = true;
      _timer?.cancel();
    });
  }

  void _updateTimerDisplay() {
    int minutes = _secondsRemaining ~/ 60;
    int seconds = _secondsRemaining % 60;
    _timeDisplay =
        "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  void _showBreakDialog() {
    final completedMinutes = _sessionDurationMinutes - (_secondsRemaining ~/ 60);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Break Time!'),
          content: const Text('Take a 5-minute break.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Start Break'),
              onPressed: () {
                Navigator.of(context).pop();
                _startBreak();
                _updateStreak(completedMinutes); // Call updateStreak with completed minutes
              },
            ),
          ],
        );
      },
    );
  }

  void _updateStreak(int minsToday) {
    context.read<ReminderCubit>().updateStreak(minsToday);
  }

  void _startBreak() {
    setState(() {
      _isWorking = false;
      _isPaused = false;
      _secondsRemaining = 5 * 60;
      _updateTimerDisplay();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_secondsRemaining > 0) {
            _secondsRemaining--;
            _updateTimerDisplay();
          } else {
            _timer?.cancel();
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xffBAC1CB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Focus Session',
                      style: AppStyle.font16blackmedium.copyWith(
                        fontWeight: FontWeightHelper.regular,
                        fontSize: 20,
                        color: const Color(0xff072247),
                      ),
                    ),
                    IconButton(
                      onPressed: _showSessionDurationPicker,
                      icon: const Icon(
                        Icons.timer,
                        color: Color(0xff51647E),
                        size: 22,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: Text(
                    _timeDisplay,
                    style: AppStyle.font50blacksemibold,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: CustomBottom(
                backgroundColor: ColorManager.darkyellowColor,
                bottomHeight: 50,
                bottomWidth: 200,
                onPressed: () {
                  debugPrint(
                      'Button pressed: ${_isWorking ? (_isPaused ? 'resume' : 'pause') : 'start'}');
                  if (_isWorking) {
                    if (_isPaused) {
                      _resumeWorkSession();
                    } else {
                      _pauseWorkSession();
                    }
                  } else {
                    _startWorkSession();
                  }
                },
                bottomtext:
                    _isWorking ? (_isPaused ? 'continue' : 'pause') : 'start',
                textBottomStyle: AppStyle.font22Whitesemibold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
