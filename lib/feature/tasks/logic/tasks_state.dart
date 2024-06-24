part of 'tasks_cubit.dart';

sealed class TasksState extends Equatable {
  const TasksState();

  @override
  List<Object> get props => [];
}

final class HomeInitial extends TasksState {}

class TaskAddedSuccessfully extends TasksState {}

class TaskAddErrorState extends TasksState {
  final String errorMessage;

  const TaskAddErrorState({required this.errorMessage});
}


final class GetTaskListNameError extends TasksState {
  final String errorMessage;

  const GetTaskListNameError(this.errorMessage);
}



final class GetTaskListNameSuccess extends TasksState {
  final List<Task> tasks;
  const GetTaskListNameSuccess(this.tasks);
}

 final class GetTaskListNameLoading extends TasksState {}



 final class AddTaskListError extends TasksState {
  final String errorMessage;
  const AddTaskListError(this.errorMessage);
}
final class AddTaskListSuccess extends TasksState {}  