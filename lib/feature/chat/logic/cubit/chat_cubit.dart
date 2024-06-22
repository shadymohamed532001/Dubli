import 'package:dubli/core/networking/api_services.dart';
import 'package:dubli/core/networking/end_boint.dart';
import 'package:dubli/feature/chat/data/models/chat_model.dart';
import 'package:dubli/feature/chat/data/models/history_chat_model.dart';
import 'package:dubli/feature/chat/data/repositories/chat_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({required this.chatRepo}) : super(ChatInitial());

  final ChatRepo chatRepo;

  List<HistoryChatModel> historyChatResult = <HistoryChatModel>[];

  Future<void> getChatss() async {
    emit(GetChatsDataLoadingState());
    try {
      var response = await chatRepo.getHistoryChat();

      response.fold((failure) async {
        emit(GetChatsDataErrorState(errormassage: failure.errMessage));
      }, (chat) async {
        historyChatResult = chat;
        emit(GetChatsDataSuccessState(chats: chat));
      });
    } catch (e) {
      emit(GetChatsDataErrorState(errormassage: e.toString()));
    }
  }

  List<Map<String, dynamic>> messages = [];

  String formatTimestamp(DateTime timestamp) {
    return DateFormat.jm().format(timestamp);
  }

  final TextEditingController chatController = TextEditingController();

  Future sendMessage(String message) async {
    try {
      var timestamp = DateTime.now();

      messages.add({
        "sender": "user",
        "message": message,
        "timestamp": formatTimestamp(timestamp)
      });

      emit(SendUserMassMessage());

      var response = await ApiServices.postData(
        endpoint: chatendpoint,
        data: {
          'message': message,
          'user_id': '3',
        },
      );

      var data = ChatbotResponse.fromJson(response);
      timestamp = DateTime.now();

      messages.add({
        "sender": "bot",
        "message": data.message,
        "timestamp": formatTimestamp(timestamp)
      });
      emit(GetResposeMessage(message: data.message));

      return data.message;
    } catch (e) {
      return emit(GetResposeMessage(message: e.toString()));
    }
  }
}
