// ignore_for_file: avoid_print, unused_local_variable

import 'dart:convert';
import 'dart:developer';
import 'package:dupli/core/helper/local_services.dart';
import 'package:dupli/feature/event/logic/event_cubit.dart';
import 'package:dupli/feature/tasks/logic/tasks_cubit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String? usertoken;

String apiKey = 'AIzaSyDWw6-GqfdYeCjr1EudWYOw2rzyBUPL5zY';
String geminiBASEURL = 'https://generativelanguage.googleapis.com/v1beta';

const String firebaseUrl = 'https://identitytoolkit.googleapis.com/v1/accounts';
const String apiKey_2 = 'AIzaSyDreQCNmimnvoJESFbMslPUgkdvICMPHII';
const String firebaseAuthUrl =
    'https://identitytoolkit.googleapis.com/v1/accounts';

//info helper
var userId = LocalServices.getData(key: 'userId');
var userEmail = LocalServices.getData(key: 'userEmail');

String constructUserInfoURL(String userId, String email) {
  userId = userId;
  userEmail = email;
  return 'https://firestore.googleapis.com/v1/projects/firsttrialdupli/databases/(default)/documents/users/$userId/info';
}

String getUserInfoURL(String userID, String infoId) {
  userId = userID;
  return 'https://firestore.googleapis.com/v1/projects/firsttrialdupli/databases/(default)/documents/users/$userId/info/$infoId';
}

// Function to get user name by ID and set it to nameHelper
Future<Map<String, String>?> getUserNameById(
    String userId, String email) async {
  final url = constructUserInfoURL(userId, email);
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print('Response data: $data'); // Debugging information
    final responseData = json.decode(response.body);
    dynamic infoId2 = responseData.toString().split('/').last.split(',').first;

    LocalServices.saveData(
      key: 'infoId',
      value: infoId2,
    );
    print('this is info url helper$infoId2');
    if (data != null && data['documents'] != null) {
      final documents = data['documents'];

      for (var document in documents) {
        final fields = document['fields'];
        print('Document fields: $fields'); // Debugging information

        if (fields != null) {
          final name = fields['username']?['stringValue'] ?? 'Unknown';
          final phone = fields['phone']?['stringValue'] ?? 'Unknown';
          final password = fields['password']?['stringValue'] ?? 'Unknown';
          final email = fields['email']?['stringValue'] ?? 'Unknown';

          print(
              'Extracted details: $name, $email, $phone, $password'); // Debugging information

          return {
            'name': name,
            'phone': phone,
            'password': password,
            'email': email
          };
        }
      }
    }
  } else {
    print('Failed to fetch user: ${response.statusCode}');
  }

  return null;
}

//events helper
String constructUserEvents(String userId) {
  return 'https://firestore.googleapis.com/v1/projects/firsttrialdupli/databases/(default)/documents/users/$userId/events';
}

String getUserEvents(String userId, String eventId) {
  return 'https://firestore.googleapis.com/v1/projects/firsttrialdupli/databases/(default)/documents/users/$userId/events/$eventId';
}

// universties helper functions

Future<void> checkUserEmailInUniHelper(String userId, String email) async {
  List<String> majors = [
    'Art',
    'Business',
    'Computer Science',
    'Engineering',
    'Pharmacy'
  ]; // Add all your majors here
  try {
    for (String major in majors) {
      final String url = getStudentsHelper(major);
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data != null && data['documents'] != null) {
          for (var doc in data['documents']) {
            final docData = doc['fields'];
            if (docData['email']['stringValue'] == email) {
              final String year = docData['grade']['integerValue'] ?? 'Unknown';
              final String name = docData['name']['stringValue'] ?? 'Unknown';
              final String gpa = docData['gpa']['integerValue'] ?? 'Unknown';
              LocalServices.saveData(
                key: 'majorId',
                value: major,
              );
              LocalServices.saveData(
                key: 'yearId',
                value: year,
              );
              var majorId = await LocalServices.getData(key: 'majorId');
              var yearId = await LocalServices.getData(key: 'yearId');
              await EventCubit().fetchAndAddScheduleToCalendar();
              await TasksCubit().studyPlan();
              print(majorId + yearId);
            }
          }
        }
      }
    }
  } catch (e) {
    print('Error checking email: $e');
  }

  return;
}

String getScheduleHelper(String major, String year) {
  return 'https://firestore.googleapis.com/v1/projects/firsttrialdupli/databases/(default)/documents/universities/$major/grades/grade+$year/schedule';
}

String getSubjectHelper(String major, String year, String day) {
  return 'https://firestore.googleapis.com/v1/projects/firsttrialdupli/databases/(default)/documents/universities/$major/grades/grade+$year/schedule/$day/subjects';
}

String getStudentsHelper(String major) {
  return 'https://firestore.googleapis.com/v1/projects/firsttrialdupli/databases/(default)/documents/universities/$major/students';
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

String modifyUserTasks(String userId, String taskListId) {
  return 'https://firestore.googleapis.com/v1/projects/firsttrialdupli/databases/(default)/documents/users/$userId/Tasks/$taskListId';
}

//focus helper
String constructUserFocus(String userId) {
  return 'https://firestore.googleapis.com/v1/projects/firsttrialdupli/databases/(default)/documents/users/$userId/focus';
}

String constructUserfocusStreak(String userId) {
  return 'https://firestore.googleapis.com/v1/projects/firsttrialdupli/databases/(default)/documents/users/$userId/focus/documentId';
}

Future<Map<String, dynamic>> fetchDataFromLocalStorage() async {
  usertoken = await LocalServices.getData(key: 'userId');
  log('UserToken : $usertoken');
  return {'token': usertoken};
}

String constructUserEmail() {
  String studentMajor = LocalServices.getData(key: 'majorId');
  return 'https://firestore.googleapis.com/v1/projects/firsttrialdupli/databases/(default)/documents/universities/$studentMajor/students';
}

String constructUserDays(String grade) {
  String studentMajor = LocalServices.getData(key: 'majorId');
  return 'https://firestore.googleapis.com/v1/projects/firsttrialdupli/databases/(default)/documents/universities/$studentMajor/grades/grade$grade/schedule';
}

String constructUserClasses(grade, day) {
  String studentMajor = LocalServices.getData(key: 'majorId');
  return 'https://firestore.googleapis.com/v1/projects/firsttrialdupli/databases/(default)/documents/universities/$studentMajor/grades/grade$grade/schedule/$day/subjects';
}

void showCustomSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}
