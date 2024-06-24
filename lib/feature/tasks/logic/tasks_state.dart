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
  final List<TaskGroupModel> tasks;
  const GetTaskListNameSuccess(this.tasks);
}

 final class GetTaskListNameLoading extends TasksState {}



 final class AddTaskListError extends TasksState {
  final String errorMessage;
  const AddTaskListError(this.errorMessage);
}
final class AddTaskListSuccess extends TasksState {}  


final class GetAllTasksSuccessState extends TasksState {
  final List<AllTaskModel> tasks;
  const GetAllTasksSuccessState(this.tasks);
}

final class GetAllTasksLoading extends TasksState {}

final class GetAllTasksErrorState extends TasksState {
  final String errorMessage;
  const GetAllTasksErrorState(this.errorMessage);
}

final class AddTaskLoading extends TasksState {}

final class AddTaskError extends TasksState {
  final String errorMessage;
  const AddTaskError(this.errorMessage);
}

final class AddTaskSuccess extends TasksState {}

