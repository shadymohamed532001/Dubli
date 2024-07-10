import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dupli/core/error/servier_failure.dart';
import 'package:dupli/core/helper/helper_const.dart';
import 'package:dupli/feature/signup/data/models/user_model.dart';
import 'package:dupli/feature/signup/data/repositories/sign_up_repo.dart';
import 'package:http/http.dart' as http;

class SignUpRepoImpl extends SignUpRepo {
  @override
  Future<Either<Failure, UserModel>> signUp({
    required String username,
    required String phone,
    required String email,
    required String password,
    required String age,
    required String gender,
  }) async {
    try {
      const url = '$firebaseAuthUrl:signUp?key=$apiKey_2';
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final userData = UserModel.fromJson(json.decode(response.body));
      return Right(userData);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDioException(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }
}
