// ignore_for_file: avoid_print

import 'package:dupli/core/helper/helper_const.dart';
import 'package:dupli/core/helper/local_services.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsInitial());

   Future<void> editUser(
    String userId,
    String userName,
    String userEmail,
    String userPhone,
    String userPassword,
  ) async {
    emit(SettingLoading());
    try {
      final infoId = LocalServices.getData(key: 'infoId');
      final eventDocumentUrl = getUserInfoURL(userId, infoId);

      final response = await http.patch(
        Uri.parse(eventDocumentUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'fields': {
            if (userName.isNotEmpty) 'username': {'stringValue': userName},
            if (userEmail.isNotEmpty) 'email': {'stringValue': userEmail},
            if (userPhone.isNotEmpty) 'phone': {'stringValue': userPhone},
            if (userPassword.isNotEmpty)
              'password': {'stringValue': userPassword},
          },
        }),
      );

      if (response.statusCode == 200) {
        final email = LocalServices.getData(key: 'userEmail');
        final password = LocalServices.getData(key: 'userPassword');
        print(password);
        final idToken = await getIdToken(email, password);
        await updateUserPassword(idToken as String, userPassword);
        LocalServices.saveData(
          key: 'userEmail',
          value: userEmail,
        );
        LocalServices.saveData(
          key: 'userName',
          value: userName,
        );
        LocalServices.saveData(
          key: 'userPhone',
          value: userPhone,
        );
        LocalServices.saveData(
          key: 'userPassword',
          value: userPassword,
        );
        //final idToken = LocalServices.getData(key: 'idToken');

        emit(SettingSuccess(userName: userName));
      } else {
        print('Error updating user: ${response.statusCode}');
        print('Error body: ${response.body}');
        emit(const SettingFailure(
          error: 'Wrong Email Or Password',
        ));
      }
    } catch (e) {
      print('Error in editUser: $e');
    }
  }

  Future<String?> getIdToken(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey_2';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['idToken'];
    } else {
      print('Error obtaining ID token: ${response.body}');
      return null;
    }
  }

  Future<void> updateUserPassword(String idToken, String newPassword) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:update?key=$apiKey_2';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'idToken': idToken,
        'password': newPassword,
        'returnSecureToken': true,
      }),
    );

    if (response.statusCode == 200) {
      print('Password updated successfully.');
    } else {
      print('Error updating password: ${response.body}');
    }
  }

  Future<File?> uploadImageFromGalleryModel({
    required ImagePicker picker,
  }) async {
    try {
      XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        image = File(pickedFile.path);
        emit(UploadImageFromGallerySuccessState(image: pickedFile));
        return image;
      } else {
        emit(const UploadImageErrorState(errorMessage: "No image picked"));
        return null;
      }
    } catch (e) {
      emit(UploadImageErrorState(errorMessage: e.toString()));
      return null;
    }
  }

  File? image;

  final formKey = GlobalKey<FormState>();

  AutovalidateMode? autovalidateMode = AutovalidateMode.disabled;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final cityController = TextEditingController();
  bool isPasswordShow = true;

  void updateUserName(String userName) {
    emit(SettingSuccess(userName: userName));
  }
}
