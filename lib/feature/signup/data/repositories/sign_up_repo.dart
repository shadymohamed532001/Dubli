import 'package:dartz/dartz.dart';
import 'package:dupli/core/error/servier_failure.dart';
import 'package:dupli/feature/signup/data/models/user_model.dart';

abstract class SignUpRepo {
    Future<Either<Failure,UserModel>> signUp({
    required String username,
    required String phone,
    required String email,
    required String password,
    required String age,
    required String gender,
    });
}