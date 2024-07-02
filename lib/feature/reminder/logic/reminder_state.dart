part of 'reminder_cubit.dart';

sealed class ReminderState extends Equatable {
  const ReminderState();

  @override
  List<Object> get props => [];
}

final class ReminderInitial extends ReminderState {}

final class ReminderStop extends ReminderState {}

final class ReminderReset extends ReminderState {}

final class ReminderAddLaps extends ReminderState {}

final class ReminderRemoveLaps extends ReminderState {}

final class ReminderStart extends ReminderState {}

final class ReminderTick extends ReminderState {
  final String digtalHour;
  final String digtalMinute;
  final String digtalSecond;
  final List<String> laps;

  const ReminderTick({
    required this.laps,
    required this.digtalHour,
    required this.digtalMinute,
    required this.digtalSecond,
  });

  
}

class GetFocusLoading extends ReminderState {}

class GetFocusSuccess extends ReminderState {
  final   Map<String, dynamic> focus;
  const GetFocusSuccess({required this.focus});
}


class GetFocusError extends ReminderState {
  final String error;
  const GetFocusError({required this.error});
}