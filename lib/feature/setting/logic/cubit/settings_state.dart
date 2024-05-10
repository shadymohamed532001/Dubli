part of 'settings_cubit.dart';

sealed class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

final class SettingsInitial extends SettingsState {}
final class UploadImageFromGallerySuccessState extends SettingsState {
  final XFile image;
  const UploadImageFromGallerySuccessState({required this.image});
}   final class SignUpChangepasswordvisabilty extends SettingsState {}

final class UploadImageErrorState extends SettingsState {
  final String errorMessage;

  const UploadImageErrorState({required this.errorMessage});  
  }