part of 'settings_cubit.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingLoading extends SettingsState {}

class SettingSuccess extends SettingsState {
  final String userName;

  const SettingSuccess({required this.userName});

  @override
  List<Object?> get props => [userName];
}

class SettingFailure extends SettingsState {
  final String error;

  const SettingFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class UploadImageFromGallerySuccessState extends SettingsState {
  final XFile image;

  const UploadImageFromGallerySuccessState({required this.image});

  @override
  List<Object?> get props => [image];
}

class UploadImageErrorState extends SettingsState {
  final String errorMessage;

  const UploadImageErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
