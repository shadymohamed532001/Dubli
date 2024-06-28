// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dubli/core/helper/helper_const.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
    
    if (nameHelper == 'Dupli' && infoHelper == null) {
      print('can not update');
      return;
    }
    final eventDocumentUrl = getUserInfoURL(userId, infoHelper);
    // Update the event document in Firestore
    final response = await http.patch(
      Uri.parse(eventDocumentUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'fields': {
          'username': {'stringValue': userName},
          'email': {'stringValue': userEmail},
          'phone': {'stringValue': userPhone},
          'password': {'stringValue': userPassword},
        },
      }),
    );

    if (response.statusCode == 200) {
      useremailHelper = userEmail;
      phoneHelper = userPhone;
      passwordHelper = userPassword;
      nameHelper = userName;
      print('user updated successfully');
    } else {
      print('Error updating user');
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
}
