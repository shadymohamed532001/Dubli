import 'package:dartz/dartz.dart';
import 'package:dupli/core/error/servier_failure.dart';
import 'package:dupli/feature/chat/data/models/history_chat_model.dart';

abstract class ChatRepo {
  Future<Either<Failure, List<HistoryChatModel>>> getHistoryChat();

}
