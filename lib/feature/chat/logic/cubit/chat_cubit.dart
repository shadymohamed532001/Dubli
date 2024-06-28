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
  var addTaskController = TextEditingController();

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

    final TextEditingController chatController = TextEditingController();


  List<Map<String, dynamic>> messages = [];

  String formatTimestamp(DateTime timestamp) {
    return DateFormat.jm().format(timestamp);
  }

  List<String> suggestionQuestions = [
    "How can I help you today?",
    "What are your operating hours?",
    "Do you provide support for product X?",
    "Can I return a product I bought?",
    "How can I track my order?",
  ];

  var titleController = TextEditingController();
  var descriptionController = TextEditingController();

Future sendMessage(String message) async {
    try {
      var timestamp = DateTime.now();

      // Add the user message to the list
      messages.add({
        "sender": "user",
        "message": message,
        "timestamp": formatTimestamp(timestamp),
      });

      // Emit loading state for sending message
      emit(SendUserMassMessageLoading());

      var response = await ApiServices.postData(
        endpoint: chatendpoint,
        data: {
          'message': message,
          'user_id': '3',
        },
      );

      var data = ChatbotResponse.fromJson(response);
      timestamp = DateTime.now();

      // Add the bot response message to the list
      messages.add({
        "sender": "bot",
        "message": data.message,
        "timestamp": formatTimestamp(timestamp),
      });

      // Emit success state with the bot response
      emit(GetResposeMessage(message: data.message));
      return data.message;
    } catch (e) {
      // Emit error state with the error message
      emit(GetResposeMessage(message: e.toString()));
    }
  }
  // Future sendMessage(String message) async {
  //   try {
  //     var timestamp = DateTime.now();

  //     messages.add({
  //       "sender": "user",
  //       "message": message,
  //       "timestamp": formatTimestamp(timestamp)
  //     });

  //     emit(SendUserMassMessage());

  //     var response = await ApiServices.postData(
  //       endpoint: chatendpoint,
  //       data: {
  //         'message': message,
  //         'user_id': '3',
  //       },
  //     );

  //     var data = ChatbotResponse.fromJson(response);
  //     timestamp = DateTime.now();

  //     messages.add({
  //       "sender": "bot",
  //       "message": data.message,
  //       "timestamp": formatTimestamp(timestamp)
  //     });
  //     emit(GetResposeMessage(message: data.message));

  //     return data.message;
  //   } catch (e) {
  //     return emit(GetResposeMessage(message: e.toString()));
  //   }
  // }
}
