import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'reminder_state.dart';

class ReminderCubit extends Cubit<ReminderState> {
  ReminderCubit() : super(ReminderInitial());

  int second = 0, minute = 0, hour = 0;
  String digtalSecond = '00', digtalMinute = '00', digtalHour = '00';
  Timer? timer;
  bool start = false;
  List<String> laps = [];
  Duration duration = Duration.zero;
  void startTimer(Duration duration) {
    reset();
    start = true;
    emit(ReminderStart());

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      int localSecond = second + 1;
      int localMinute = minute;
      int localHour = hour;

      if (localSecond > 59) {
        localSecond = 0;
        localMinute++;
      }

      if (localMinute > 59) {
        localMinute = 0;
        localHour++;
      }

      second = localSecond;
      minute = localMinute;
      hour = localHour;
      digtalSecond = (second >= 10) ? "$second" : "0$second";
      digtalMinute = (minute >= 10) ? "$minute" : "0$minute";
      digtalHour = (hour >= 10) ? "$hour" : "0$hour";

      emit(ReminderTick(
        digtalHour: digtalHour,
        digtalMinute: digtalMinute,
        digtalSecond: digtalSecond,
        laps: laps,
      ));

      if (localHour * 3600 + localMinute * 60 + localSecond >=
          duration.inSeconds) {
        addLaps();
        stop();
        
        eventController.clear();
      }
    });
  }

  void stop() {
    timer?.cancel();
    start = false; 
    emit(ReminderStop()); 
  }

  void reset() {
    timer?.cancel();
    second = 0;
    minute = 0;
    hour = 0;
    digtalSecond = '00';
    digtalMinute = '00';
    digtalHour = '00';
    start = false;

    emit(ReminderReset());
  }

  void addLaps() {
    laps.add('$digtalHour:$digtalMinute:$digtalSecond');
    emit(ReminderAddLaps());
  }

  void removeLaps() {
    laps.removeAt(laps.length - 1);

    emit(ReminderRemoveLaps());
  }

  var eventController = TextEditingController();
}
