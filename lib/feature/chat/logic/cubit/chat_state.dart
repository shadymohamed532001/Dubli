part of 'chat_cubit.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

final class ChatInitial extends ChatState {}

final class SaveChatsDataToLocalSuccessState extends ChatState {
  final List<HistoryChatModel> history;
  const SaveChatsDataToLocalSuccessState({required this.history});
}

final class SaveChatsDataToLocalErrorState extends ChatState {
  final String error;
  const SaveChatsDataToLocalErrorState({required this.error});
}

final class SaveChatsDataToLocalLoadingState extends ChatState {}

final class LoadChatsDataToLocalErorrState extends ChatState {
  final String error;
  const LoadChatsDataToLocalErorrState({required this.error});
}

final class LoadChatsDataToLocalSuccessState extends ChatState {
  final List<HistoryChatModel> history;
  const LoadChatsDataToLocalSuccessState({required this.history});
}

final class LoadChatsDataToLocalLoadingState extends ChatState {}

final class GetChatsDataLoadingState extends ChatState {}

final class GetChatsDataSuccessState extends ChatState {
  final List<HistoryChatModel> chats;
  const GetChatsDataSuccessState({required this.chats});
}

final class GetChatsDataErrorState extends ChatState {
  final String errormassage;
  const GetChatsDataErrorState({required this.errormassage});
}

final class SendUserMassMessage extends ChatState {}

final class GetResposeMessage extends ChatState {
  final String message;
  const GetResposeMessage({required this.message});
}

final class GetResposeMessageErrorState extends ChatState {
  final String error;
  const GetResposeMessageErrorState({required this.error});
}

final class SendUserMassMessageLoading extends ChatState {
}