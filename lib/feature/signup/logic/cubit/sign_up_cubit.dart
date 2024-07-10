import 'dart:convert';
import 'dart:developer';
import 'package:dupli/core/helper/helper_const.dart';
import 'package:dupli/core/helper/local_services.dart';
import 'package:dupli/feature/signup/data/repositories/sign_up_repo.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit({required this.signUpRepo}) : super(SignUpInitial());

  final SignUpRepo signUpRepo;
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

    var response = await signUpRepo.signUp(
      email: email,
      password: password,
      age: age,
      gender: gender,
      phone: phone,
      username: username,
    );

    response.fold(
      (failure) {
        emit(
          SignUpFailed(
            error: failure.errMessage,
          ),
        );
      },
      (sucsses) async {
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
        await LocalServices.saveData(
          key: 'userId',
          value: sucsses.localId,
        );
        await LocalServices.saveData(
          key: 'tokenId',
          value: sucsses.idToken,
        );
        var token = await LocalServices.getData(key: 'tokenId');
        await saveUserDataToFirestore(
          token: token,
          username: username,
          phone: phone,
          email: email,
          password: password,
          age: age,
          gender: gender,
        );

        checkUserEmailInUniHelper(sucsses.localId, sucsses.email);
        getUserNameById(sucsses.localId, sucsses.email);
        emit(SignUpSuccess());
      },
    );
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
