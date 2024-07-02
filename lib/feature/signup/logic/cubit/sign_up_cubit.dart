import 'dart:convert';
import 'dart:developer';
import 'package:dupli/core/helper/helper_const.dart';
import 'package:dupli/core/helper/local_services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  String? errMessage;
  String uid = 'ABCDEFG';

  Future<void> signUpUser({
    required String username,
    required String phone,
    required String email,
    required String password,
    required String age,
    required String gender,
  }) async {
    emit(SignUpLoading());
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

      final responseData = json.decode(response.body);
      if (responseData.containsKey('error')) {
        errMessage = responseData['error']['message'] as String?;
        throw Exception(errMessage);
      }

      final token = responseData['idToken'] as String?;
      final localId = responseData['localId'] as String?;

      if (token == null || localId == null) {
        throw Exception("Missing token or user ID in response");
      }

      await LocalServices.saveData(
        key: 'userId',
        value: localId,
      );
      await LocalServices.saveData(
        key: 'tokenId',
        value: token,
      );

      uid = localId;

      await saveUserDataToFirestore(
        token: token,
        username: username,
        phone: phone,
        email: email,
        password: password,
        age: age,
        gender: gender,
      );

      print('User registered successfully! $uid');

      await LocalServices.saveData(
        key: 'userEmail',
        value: email,
      );
      await LocalServices.saveData(
        key: 'userName',
        value: username,
      );
      await LocalServices.saveData(
        key: 'userPassword',
        value: password,
      );
      await LocalServices.saveData(
        key: 'userPhone',
        value: phone,
      );
      await LocalServices.saveData(
        key: 'userAge',
        value: age,
      );
      await LocalServices.saveData(
        key: 'userGender',
        value: gender,
      );
      var userId = await LocalServices.getData(key: 'userId');
      var userEmail = await LocalServices.getData(key: 'userEmail');
      checkUserEmailInUniHelper(userId, userEmail);
      getUserNameById(userId, userEmail);
      emit(SignUpSuccess());
    } catch (e) {
      log(e.toString());
      emit(SignUpFailed(error: errMessage ?? 'An unknown error occurred'));
    }
  }

  Future<void> saveUserDataToFirestore({
    required String token,
    required String username,
    required String phone,
    required String email,
    required String password,
    required String age,
    required String gender,
  }) async {
    emit(SaveUserDataLoading());
    String userInfoURL = constructUserInfoURL(uid, email);
    final url = '$userInfoURL?key=$apiKey_2';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'fields': {
          'username': {'stringValue': username},
          'phone': {'stringValue': phone},
          'email': {'stringValue': email},
          'password': {'stringValue': password},
          'age': {'stringValue': age},
          'gender': {'stringValue': gender},
        },
      }),
    );

    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      emit(SaveUserDataSuccess());
      print('User data saved to Firestore successfully!');
      print('Document ID: ${responseData['name']}');
    } else {
      final errorMessage = responseData['error']['message'] as String?;
      emit(SaveUserDataFailed(
          error: errorMessage ?? 'Failed to save user data to Firestore'));
      log('Error: $errorMessage');
    }
  }

  final formKey = GlobalKey<FormState>();

  AutovalidateMode? autovalidateMode = AutovalidateMode.disabled;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final cityController = TextEditingController();
  final genderController = TextEditingController();
  final ageController = TextEditingController();
  bool isPasswordShow = true;
}
