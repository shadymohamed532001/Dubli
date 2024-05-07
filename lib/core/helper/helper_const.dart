// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:dubli/core/networking/local_services.dart';
import 'package:flutter/material.dart';

String? usertoken;

String apiKey = 'AIzaSyDWw6-GqfdYeCjr1EudWYOw2rzyBUPL5zY';
String geminiBASEURL = 'https://generativelanguage.googleapis.com/v1beta';

const String firebaseUrl = 'https://identitytoolkit.googleapis.com/v1/accounts';
const String apiKey_2 =
    'AIzaSyDreQCNmimnvoJESFbMslPUgkdvICMPHII'; 
const String firebaseAuthUrl =
    'https://identitytoolkit.googleapis.com/v1/accounts';
final String firebaseFirestoreBaseUrl =
    'https://firestore.googleapis.com/v1/projects/firsttrialdupli/databases/(default)/documents/users/$userId/info';

Future<Map<String, dynamic>> fetchDataFromLocalStorage() async {
  usertoken = await LocalServices.getData(key: 'token');
  log('UserToken : $usertoken');
  return {'token': usertoken};
}

void showCustomSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}

var userId;
