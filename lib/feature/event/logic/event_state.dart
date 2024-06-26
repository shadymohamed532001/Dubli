part of 'event_cubit.dart';

sealed class EventState extends Equatable {
  const EventState();

  @override
  List<Object> get props => [];
}

final class EventInitial extends EventState {}

final class AddEventLoading extends EventState {}

final class AddEventSuccess extends EventState {}

final class AddEventError extends EventState {
  final String error;
  const AddEventError({required this.error});
}

final class GetEventsError extends EventState {
  final String error;
  const GetEventsError({required this.error});
}

final class GetEventsSuccess extends EventState {
  final List<Map<String, dynamic>> events;

  const GetEventsSuccess({required this.events});
}

final class GetEventsLoading extends EventState {}
