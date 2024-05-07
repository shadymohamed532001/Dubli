part of 'sign_up_cubit.dart';

@immutable
sealed class SignUpState {}

final class SignUpInitial extends SignUpState {}

class SignUpFailed extends SignUpState {
  final String error;

  SignUpFailed({required this.error});
}

class SignUpSuccess extends SignUpState {}

class SignUpLoading extends SignUpState {}


class SaveUserDataLoading extends SignUpState {}

class SaveUserDataSuccess extends SignUpState {}


class SaveUserDataFailed extends SignUpState 
{
  final String error;

  SaveUserDataFailed({required this.error});

}