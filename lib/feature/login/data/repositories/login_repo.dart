import 'package:dartz/dartz.dart';
import 'package:dupli/core/error/servier_failure.dart';
import 'package:dupli/feature/login/data/model/user_info.dart';

abstract class LoginRepo {
  Future<Either<Failure, UserInfoModel>> login({
    required String email,
    required String password,
  });
}
