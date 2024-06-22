import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dubli/core/error/servier_failure.dart';
import 'package:dubli/core/networking/api_services.dart';
import 'package:dubli/core/networking/end_boint.dart';
import 'package:dubli/feature/chat/data/models/history_chat_model.dart';
import 'package:dubli/feature/chat/data/repositories/chat_repo.dart';

class ChatRepoImpl extends ChatRepo {
  @override
  Future<Either<Failure, List<HistoryChatModel>>> getHistoryChat() async {
    try {
      var response = await ApiServices.getData(
        endpoint: '$baseUrl/chathistory?user_id=3',
      );

      List<HistoryChatModel> chatHistory = [];

      if (response.containsKey('chats')) {
        for (var chat in response['chats']) {
          chatHistory.add(HistoryChatModel.fromJson(chat));
        }
      }

      return right(chatHistory);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioException(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }
}
