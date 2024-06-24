import 'dart:developer';
import 'package:dubli/core/helper/local_services.dart';
import 'package:flutter/material.dart';

String? usertoken;

String apiKey = 'AIzaSyDWw6-GqfdYeCjr1EudWYOw2rzyBUPL5zY';
String geminiBASEURL = 'https://generativelanguage.googleapis.com/v1beta';

const String firebaseUrl = 'https://identitytoolkit.googleapis.com/v1/accounts';
const String apiKey_2 = 'AIzaSyDreQCNmimnvoJESFbMslPUgkdvICMPHII';
const String firebaseAuthUrl =
    'https://identitytoolkit.googleapis.com/v1/accounts';

//info helper
dynamic useridHelper;
String constructUserInfoURL(String userId) {
  useridHelper = userId;
  return 'https://firestore.googleapis.com/v1/projects/firsttrialdupli/databases/(default)/documents/users/$userId/info';
}

//events helper
String constructUserEvents(String userId) {
  return 'https://firestore.googleapis.com/v1/projects/firsttrialdupli/databases/(default)/documents/users/$userId/events';
}

String getUserEvents(String userId, String eventId) {
  return 'https://firestore.googleapis.com/v1/projects/firsttrialdupli/databases/(default)/documents/users/$userId/events/$eventId';
}

//tasks helper
String constructUserTaskLists(String userId) {
  return 'https://firestore.googleapis.com/v1/projects/firsttrialdupli/databases/(default)/documents/users/$userId/Tasks';
}

String constructUserTasks(String userId, String taskListId) {
  return 'https://firestore.googleapis.com/v1/projects/firsttrialdupli/databases/(default)/documents/users/$userId/Tasks/$taskListId/tasks';
}

String constructUserTask(String userId, String taskListId, String taskId) {
  return 'https://firestore.googleapis.com/v1/projects/firsttrialdupli/databases/(default)/documents/users/$userId/Tasks/$taskListId/tasks/$taskId';
}

Future<Map<String, dynamic>> fetchDataFromLocalStorage() async {
  usertoken = await LocalServices.getData(key: 'userId');
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

String modifyUserTasks(String userId, String taskListId) {
  return 'https://firestore.googleapis.com/v1/projects/firsttrialdupli/databases/(default)/documents/users/$userId/Tasks/$taskListId';
}
