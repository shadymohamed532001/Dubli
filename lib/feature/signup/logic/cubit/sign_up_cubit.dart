import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dubli/core/helper/helper_const.dart';
part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  String errMessage = '';

  Future<void> signUpUser({
  required String username,
  required String phone,
  required String email,
  required String password,
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
    final token = responseData['idToken'];
    if (responseData.containsKey('error')) {
      errMessage = responseData['error']['message'];
    }
    await saveUserDataToFirestore(
      token: token,
      username: username,
      phone: phone,
      email: email,
      password: password,
    );
    emit(SignUpSuccess());
    log('User registered successfully!');
  } catch (e) {
    log(e.toString());
    emit(SignUpFailed(error: errMessage));
  }
}

  Future<void> saveUserDataToFirestore({
    required String token,
    required String username,
    required String phone,
    required String email,
    required String password,
  }) async {
    emit(SaveUserDataLoading());
    final url = '$firebaseFirestoreBaseUrl?key=$apiKey_2';

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
        },
      }),
    );

    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      emit(SaveUserDataSuccess());
      log('User data saved to Firestore successfully!');
      log('Document ID: ${responseData['name']}');
    } else {
      emit(SaveUserDataFailed(error: 'Failed to save user data to Firestore'));
      log('Error: ${responseData['error']['message']}');
    }
  }

  final formKey = GlobalKey<FormState>();

  AutovalidateMode? autovalidateMode = AutovalidateMode.disabled;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final cityController = TextEditingController();
  bool isPasswordShow = true;
}
