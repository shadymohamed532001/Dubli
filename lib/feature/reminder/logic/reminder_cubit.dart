// ignore_for_file: avoid_print

import 'dart:async';
import 'package:dupli/core/helper/helper_const.dart';
import 'package:dupli/core/helper/local_services.dart';
import 'package:dupli/core/networking/api_services.dart';
import 'package:dupli/core/networking/end_boint.dart';
import 'package:dupli/feature/chat/data/models/focus_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
part 'reminder_state.dart';

class ReminderCubit extends Cubit<ReminderState> {
  ReminderCubit() : super(ReminderInitial());

  int second = 0, minute = 0, hour = 0;
  String digtalSecond = '00', digtalMinute = '00', digtalHour = '00';
  Timer? timer;
  bool start = false;
  List<String> laps = [];
  Duration duration = Duration.zero;
  void startTimer(Duration duration) {
    reset();
    start = true;
    emit(ReminderStart());

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      int localSecond = second + 1;
      int localMinute = minute;
      int localHour = hour;

      if (localSecond > 59) {
        localSecond = 0;
        localMinute++;
      }

      if (localMinute > 59) {
        localMinute = 0;
        localHour++;
      }

      second = localSecond;
      minute = localMinute;
      hour = localHour;
      digtalSecond = (second >= 10) ? "$second" : "0$second";
      digtalMinute = (minute >= 10) ? "$minute" : "0$minute";
      digtalHour = (hour >= 10) ? "$hour" : "0$hour";

      emit(ReminderTick(
        digtalHour: digtalHour,
        digtalMinute: digtalMinute,
        digtalSecond: digtalSecond,
        laps: laps,
      ));

      if (localHour * 3600 + localMinute * 60 + localSecond >=
          duration.inSeconds) {
        addLaps();
        stop();

        eventController.clear();
      }
    });
  }

  void stop() {
    timer?.cancel();
    start = false;
    emit(ReminderStop());
  }

  void reset() {
    timer?.cancel();
    second = 0;
    minute = 0;
    hour = 0;
    digtalSecond = '00';
    digtalMinute = '00';
    digtalHour = '00';
    start = false;

    emit(ReminderReset());
  }

  void addLaps() {
    laps.add('$digtalHour:$digtalMinute:$digtalSecond');
    emit(ReminderAddLaps());
  }

  void removeLaps() {
    laps.removeAt(laps.length - 1);

    emit(ReminderRemoveLaps());
  }

  Future<void> setFoucsLevel(int level, String gender, String age) async {
    var userId = await LocalServices.getData(key: 'userId');

    final Map<String, dynamic> dataInput;
    http.Response response =
        await http.get(Uri.parse(constructUserFocus(userId)));

    dataInput = {
      'fields': {
        'focusLevel': {'integerValue': level},
        'goal': {'integerValue': 0},
        'today': {'integerValue': 0},
        'streak': {'integerValue': 0},
        'yesterday': {'integerValue': 0},
      }
    };

    // print(dataInput);
    final String jsonData = json.encode(dataInput);

    response = await http.patch(
      Uri.parse(constructUserfocusStreak(userId)),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonData,
    );

    if (response.statusCode == 200) {
      print('set level successfully.');
      setFocusgoal(age, gender, level);
    } else {
      print('Failed to set level. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  Future<http.Response> getFocus() async {
    emit(GetFocusLoading());
    var userId = await LocalServices.getData(key: 'userId');
    List<Map<String, dynamic>> documents = [];

    try {
      http.Response response =
          await http.get(Uri.parse(constructUserFocus(userId)));

      if (response.statusCode != 200) {
        emit(GetFocusError(
            error:
                'Failed to fetch focus data. Status code: ${response.statusCode}'));
        return http.Response('Error', response.statusCode);
      }

      Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;

      if (data['documents'] == null ||
          (data['documents'] as List<dynamic>).isEmpty) {
        emit(const GetFocusError(error: 'No focus data found.'));
        return http.Response(jsonEncode({'documents': []}), 200,
            headers: {'Content-Type': 'application/json'});
      }

      for (var document in data['documents'] as List<dynamic>) {
        Map<String, dynamic> fields =
            document['fields'] as Map<String, dynamic>;

        Map<String, dynamic> documentItem = {
          'fields': {
            'goal': fields['goal']['integerValue'],
            'streak': fields['streak']['integerValue'],
            'today': fields['today']['integerValue'],
            'yesterday': fields['yesterday']['integerValue']
          }
        };

        documents.add(documentItem);
      }

      Map<String, dynamic> jsonResponse = {
        'documents': documents,
      };

      print(jsonResponse);

      emit(GetFocusSuccess(focus: jsonResponse));
      return http.Response(jsonEncode(jsonResponse), 200,
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      emit(GetFocusError(
          error: 'An error occurred while fetching focus data: $e'));
      return http.Response('Error', 500);
    }
  }

  Future<void> updateStreak(int minsToday) async {
    var userId = await LocalServices.getData(key: 'userId');
    List<dynamic> documents = [];
    final Map<String, dynamic> dataInput;
    http.Response response =
        await http.get(Uri.parse(constructUserFocus(userId)));
    Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;

    documents = data['documents'] as List<dynamic>;
    final int goal =
        int.parse(documents[0]['fields']['goal']['integerValue'] as String);
    final int streak =
        int.parse(documents[0]['fields']['streak']['integerValue'] as String) +
            1;

    print(goal);
    if (minsToday >= goal) {
      print('yes');
      dataInput = {
        'fields': {
          'focusLevel': {
            'integerValue': documents[0]['fields']['focusLevel']['integerValue']
          },
          'goal': {
            'integerValue': documents[0]['fields']['goal']['integerValue']
          },
          'today': {
            'integerValue': documents[0]['fields']['today']['integerValue']
          },
          'streak': {'integerValue': streak},
          'yesterday': {
            'integerValue': documents[0]['fields']['yesterday']['integerValue']
          },
        }
      };
      print(streak);
    } else {
      print('no');
      dataInput = {
        'fields': {
          'focusLevel': {
            'integerValue': documents[0]['fields']['focusLevel']['integerValue']
          },
          'goal': {
            'integerValue': documents[0]['fields']['goal']['integerValue']
          },
          'today': {
            'integerValue': documents[0]['fields']['today']['integerValue']
          },
          'streak': {'integerValue': 0},
          'yesterday': {
            'integerValue': documents[0]['fields']['yesterday']['integerValue']
          },
        }
      };
    }
    print(dataInput);
    final String jsonData = json.encode(dataInput);

    response = await http.patch(
      Uri.parse(constructUserfocusStreak(userId)),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonData,
    );

    if (response.statusCode == 200) {
      print('streak updated successfully.');
    } else {
      print('Failed to update streak. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  Future<void> setgoal(int goal) async {
    var userId = await LocalServices.getData(key: 'userId');
    List<dynamic> documents = [];
    final Map<String, dynamic> dataInput;
    http.Response response =
        await http.get(Uri.parse(constructUserFocus(userId)));
    Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;

    documents = data['documents'] as List<dynamic>;
    print(data);
    dataInput = {
      'fields': {
        'focusLevel': {
          'integerValue': documents[0]['fields']['focusLevel']['integerValue']
        },
        'goal': {'integerValue': goal},
        'today': {
          'integerValue': documents[0]['fields']['today']['integerValue']
        },
        'streak': {
          'integerValue': documents[0]['fields']['streak']['integerValue']
        },
        'yesterday': {
          'integerValue': documents[0]['fields']['yesterday']['integerValue']
        },
      }
    };

    print(dataInput);
    final String jsonData = json.encode(dataInput);

    response = await http.patch(
      Uri.parse(constructUserfocusStreak(userId)),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonData,
    );

    if (response.statusCode == 200) {
      print('goal updated successfully.');
    } else {
      print('Failed to update goal. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  Future<void> setFocusgoal(String age, String gender, int focusLevel) async {
    // var userId = await LocalServices.getData(key: 'userId');
    int ageInt = int.parse(age);

    try {
      print(focuspoint);
      var response = await ApiServices.postData(
        endpoint: focuspoint,
        data: {
          "age": ageInt,
          "gender": gender,
          "focus_level": focusLevel,
        },
      );

      print('API Response: $response');

      if (response['predicted_minutes'] != null) {
        var data = FocusResponse.fromJson(response);

        setgoal(data.predictedMinutes);
      } else {
        print('Invalid response data or response["predicted_minutes"] is null');
      }
    } catch (e) {
      print('Error in API call or data parsing: $e');
    }
  }

  var eventController = TextEditingController();
}
