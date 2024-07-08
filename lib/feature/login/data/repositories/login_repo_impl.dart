import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dupli/core/error/servier_failure.dart';
import 'package:dupli/core/helper/helper_const.dart';
import 'package:dupli/feature/login/data/model/user_info.dart';
import 'package:dupli/feature/login/data/repositories/login_repo.dart';
import 'package:http/http.dart' as http;

class LoginRepoImpl extends LoginRepo {
  @override
  Future<Either<Failure, UserInfoModel>> login(
      {required String email, required String password}) async {
    try {
      const url = '$firebaseUrl:signInWithPassword?key=$apiKey_2';
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );

        final userData= UserInfoModel.fromJson(json.decode(response.body));
        return right(userData);
 
    
    } catch (e) {
       if (e is DioException) {
        return left(ServerFailure.fromDioException(e));
      } else {
        return left(ServerFailure(e.toString()));
      }
    }
  }
}
