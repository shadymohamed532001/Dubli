import 'dart:developer';

import 'package:dubli/core/helper/helper_const.dart';
import 'package:dubli/core/helper/local_notification_services.dart';
import 'package:dubli/core/helper/local_services.dart';
import 'package:dubli/feature/event/data/models/get_all_event_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
part 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  EventCubit() : super(EventInitial());

  var formKey = GlobalKey<FormState>();
  AutovalidateMode? autovalidateMode = AutovalidateMode.disabled;

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var noteController = TextEditingController();
  var dateController = TextEditingController();
  var editTitleController = TextEditingController();
  var editNoteController = TextEditingController();
  dynamic eventId;
// Function to add an event
  Future<void> addEvent({
    required String eventName,
    required String startEventTime,
    required String endEventTime,
    required String eventDescription,
    required String reminder,
  }) async {
    if (isClosed) {
      log('Cubit is closed, cannot emit new states');
      return;
    }

    emit(AddEventLoading());
    var userId = await LocalServices.getData(key: 'userId');

    final eventsCollectionUrl = constructUserEvents(userId);
    final DateTime startEventDate = DateTime.parse(startEventTime).toUtc();
    final DateTime endEventDate = DateTime.parse(endEventTime).toUtc();

    try {
      final response = await http.post(
        Uri.parse(eventsCollectionUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'fields': {
            'name': {'stringValue': eventName},
            'startTime': {'timestampValue': startEventDate.toIso8601String()},
            'endTime': {'timestampValue': endEventDate.toIso8601String()},
            'description': {'stringValue': eventDescription},
            'reminder': {'stringValue': reminder},
          },
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        eventId = responseData['name'].split('/').last;
        if (responseData['fields']['reminder'] == 'daily') {
          LocalNotificationService.showRepeatedNotification(
              title: 'Dupil',
              body: 'You have a Reminder for $eventName',
              repeatInterval: RepeatInterval.daily);
        }
        if (responseData['fields']['reminder'] == 'daily') {
          LocalNotificationService.showRepeatedNotification(
              title: 'Dupil',
              body: 'You have a Reminder for $eventName',
              repeatInterval: RepeatInterval.daily);
        }
        if (responseData['fields']['reminder'] == 'weekly') {
          LocalNotificationService.showRepeatedNotification(
              title: 'Dupil',
              body: 'You have a Reminder for $eventName',
              repeatInterval: RepeatInterval.weekly);
        }

        if (!isClosed) emit(AddEventSuccess());
        remindUser(eventId);
      } else {
        if (!isClosed) emit(const AddEventError(error: 'Error adding event'));
      }
    } catch (e) {
      if (!isClosed) emit(const AddEventError(error: 'Error adding event'));
    }
  }

// Function to get event details by event ID from Firestore
  Future<Map<String, dynamic>?> getEventById(dynamic eventId) async {
    var userId = await LocalServices.getData(key: 'userId');

    final url = getUserEvents(userId, eventId);
    final response =
        await http.get(Uri.parse(url)); // Convert the url to Uri here

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['fields'] != null ? _parseFields(data['fields']) : null;
    } else {
      print('Failed to fetch event: ${response.statusCode}');
      return null;
    }
  }

  Future<http.Response> getEventByIdResponse(dynamic eventId) async {
    var userId = await LocalServices.getData(key: 'userId');
    final eventsCollectionUrl = getUserEvents(userId, eventId);

    final response = await http.get(eventsCollectionUrl as Uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final fields = data['fields'];

      Map<String, dynamic> jsonResponse = {
        'name': data['name'], // Adjust this according to your event structure
        'fields': fields != null ? _parseFields(fields) : null,
      };

      // Return the JSON response
      return http.Response(jsonEncode(jsonResponse), 200,
          headers: {'Content-Type': 'application/json'});
    } else {
      print('Failed to fetch event: ${response.statusCode}');
      // Return the original response in case of failure
      return response;
    }
  }

// Helper function to parse Firestore document fields
  Map<String, dynamic> _parseFields(Map<String, dynamic> fields) {
    final Map<String, dynamic> parsedData = {};

    fields.forEach((key, value) {
      if (value.containsKey('stringValue')) {
        parsedData[key] = value['stringValue'];
      } else if (value.containsKey('integerValue')) {
        parsedData[key] = int.parse(value['integerValue']);
      } else if (value.containsKey('booleanValue')) {
        parsedData[key] = value['booleanValue'];
      } else if (value.containsKey('timestampValue')) {
        parsedData[key] = value['timestampValue'];
      }
      // Add other Firestore data types as needed
    });

    return parsedData;
  }

// Function to handle the reminder based on the event's reminder field
  Future<void> remindUser(dynamic eventId) async {
    final event = await getEventById(eventId);
    print(event);

    if (event == null) {
      print('Event not found');
      return;
    }

    final reminderOption = event['reminder'];
    final dateString = event['startTime'] as String;
    final dateValue = DateTime.parse(dateString);
    print(dateValue);
    final now = DateTime.now();
    final isSameDay = now.year == dateValue.year &&
        now.month == dateValue.month &&
        now.day == dateValue.day;
    final name = event['name'];
    print(isSameDay);

    switch (reminderOption) {
      case 'daily':
        print("daily");
        if (isSameDay) {
          print('you have a reminder today of $name');
        }
        break;
      case 'weekly':
        print("weekly");
        if (isSameDay) {
          print('you have a reminder today of $name');
        }
        break;
      case 'monthly':
        print("monthly");
        if (isSameDay) {
          print('you have a reminder today of $name');
        }
        break;
      case 'never':
        break;
      default:
        print('Invalid reminder option');
    }
  }

// Function to delete an event
  Future<void> deleteEvent({required String eventId}) async {
    var userId = await LocalServices.getData(key: 'userId');

    final eventDocumentUrl = getUserEvents(userId, eventId);

    // Delete the event document from Firestore
    final response = await http.delete(
      Uri.parse(eventDocumentUrl),
    );

    if (response.statusCode == 200) {
      print('Event deleted successfully');
      getEventsWithDate(today.toString());
    } else {
      print('Error deleting event');
    }
  }

  DateTime today = DateTime.now();

  Future<List<Event>> getEventsWithDate(String date) async {
    emit(GetEventsLoading());

    final DateTime specifiedDate = DateTime.parse(date).toUtc();
    final startOfDay = DateTime.utc(
        specifiedDate.year, specifiedDate.month, specifiedDate.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final http.Response eventsResponse = await getAllEventsByResponse();

    if (eventsResponse.statusCode != 200) {
      emit(GetEventsError(
          error:
              'Failed to fetch events. Status code: ${eventsResponse.statusCode}'));
      return []; // Return an empty list in case of error
    }

    final List<dynamic> data = jsonDecode(eventsResponse.body)['documents'];

    List<Event> events = [];

    if (data.isNotEmpty) {
      for (var event in data) {
        final fields = event['fields'];
        final startEventTime = fields['startTime']['timestampValue'] as String?;
        final startEventTimestamp =
            startEventTime != null ? DateTime.parse(startEventTime) : null;
        final endEventTime = fields['endTime']['timestampValue'] as String?;
        final endEventTimestamp =
            endEventTime != null ? DateTime.parse(endEventTime) : null;

        if ((startEventTimestamp != null &&
                startEventTimestamp.isBefore(endOfDay) &&
                (endEventTimestamp == null ||
                    endEventTimestamp.isAfter(startOfDay))) ||
            (endEventTimestamp != null &&
                endEventTimestamp.isAfter(startOfDay) &&
                (startEventTimestamp == null ||
                    startEventTimestamp.isBefore(endOfDay)))) {
          final eventId = event['name'].split('/').last;
          final eventName = fields['name']['stringValue'] as String?;
          final eventDescription = fields['description'] != null
              ? fields['description']['stringValue'] as String
              : null;
          final reminder = fields['reminder'] != null
              ? fields['reminder']['stringValue'] as String
              : null;

          if (eventId == null ||
              eventName == null ||
              startEventTimestamp == null ||
              endEventTimestamp == null) {
            continue;
          }

          Event newEvent = Event(
            id: eventId,
            name: eventName,
            startTime: startEventTimestamp.toString(),
            endTime: endEventTimestamp.toString(),
            description: eventDescription ?? 'No description',
            reminder: reminder ?? 'No reminder',
          );

          events.add(newEvent);
        }
      }
    } else {
      print('No documents found in the response.');
    }

    if (events.isNotEmpty) {
      emit(GetEventsSuccess(events: events));
      print('get event success');
    } else {
      emit(const GetEventsError(
          error: 'No events found for the specified date.'));
      print('No events found for the specified date.');
    }

    return events;
  }

  Future<void> editEvent(
      {required String eventId,
      required String eventName,
      required String startEventTime,
      required String endEventTime,
      required String eventDescription,
      required String reminder}) async {
    var userId = await LocalServices.getData(key: 'userId');

    final eventDocumentUrl = getUserEvents(userId, eventId);
    final DateTime startEventDate = DateTime.parse(startEventTime).toUtc();
    final DateTime endEventDate = DateTime.parse(endEventTime).toUtc();
    // Update the event document in Firestore
    final response = await http.patch(
      Uri.parse(eventDocumentUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'fields': {
          'name': {'stringValue': eventName},
          'startTime': {'timestampValue': startEventDate.toIso8601String()},
          'endTime': {'timestampValue': endEventDate.toIso8601String()},
          'description': {'stringValue': eventDescription},
          'reminder': {'stringValue': reminder},
        },
      }),
    );

    if (response.statusCode == 200) {
      print('Event updated successfully');
    } else {
      print('Error updating event');
    }
  }

  Future<http.Response> checkAndRemindUserForUni() async {
    var userId = await LocalServices.getData(key: 'userId');

    final eventsCollectionUrl = constructUserEvents(userId);
    final response11 = await http.get(Uri.parse(eventsCollectionUrl));
    String getCurrentDay() {
      final today = DateTime.now();
      switch (today.weekday) {
        case DateTime.monday:
          return 'monday';
        case DateTime.tuesday:
          return 'tuesday';
        case DateTime.wednesday:
          return 'wednesday';
        case DateTime.thursday:
          return 'thursday';
        case DateTime.friday:
          return 'friday';
        case DateTime.saturday:
          return 'saturday';
        case DateTime.sunday:
          return 'sunday';
        default:
          return '';
      }
    }

    Future<Map<String, dynamic>?> getDocument(String url) async {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to fetch document: ${response.statusCode}');
        return null;
      }
    }

    Future<List<Map<String, dynamic>>?> getSubjects(String day) async {
      final subjectsCollectionUrl = getSubjectHelper(majorHelper, yearHelper);

      final response = await http.get(Uri.parse(subjectsCollectionUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data != null && data['documents'] != null) {
          return List<Map<String, dynamic>>.from(data['documents']);
        }
      } else {
        print('Failed to fetch subjects for $day: ${response.statusCode}');
      }
      return null;
    }

    final day = getCurrentDay();
    print(day);
    if (day.isEmpty) {
      print('Unable to determine the current day.');
    }
    List<Map<String, dynamic>> documents = [];
    final subjects = await getSubjects(day);
    if (subjects != null && subjects.isNotEmpty) {
      print('You have reminders today for the following subjects:');
      for (var subject in subjects) {
        final fields = subject['fields'];
        final from = fields['from']['integerValue'].toString();
        final to = fields['to']['integerValue'].toString();
        final name = fields['name']['stringValue'];
        addEvent(
          eventName: name,
          startEventTime: from,
          endEventTime: to,
          reminder: 'weekly',
          eventDescription: name,
        );
        Map<String, dynamic> documentItem = {
          'name': name,
          'fields': {
            'from': from,
            'to': to,
          },
        };
        documents.add(documentItem);
      }
      // Return the JSON response
      Map<String, dynamic> jsonResponse = {
        'documents': documents,
      };
      return http.Response(jsonEncode(jsonResponse), 200,
          headers: {'Content-Type': 'application/json'});
    } else {
      return response11;
    }
  }

//printing user schedule
  Future<void> fetchAndPrintSchedule() async {
    Future<List<String>> getDays() async {
      final scheduleCollectionUrl = getScheduleHelper(majorHelper, yearHelper);
      final response = await http.get(Uri.parse(scheduleCollectionUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data != null && data['documents'] != null) {
          return List<String>.from(
              data['documents'].map((doc) => doc['name'].split('/').last));
        }
      } else {
        print('Failed to fetch schedule: ${response.statusCode}');
      }
      return [];
    }

    Future<List<Map<String, dynamic>>?> getSubjects(String day) async {
      final subjectsCollectionUrl = getSubjectHelper(majorHelper, yearHelper);
      final response = await http.get(Uri.parse(subjectsCollectionUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data != null && data['documents'] != null) {
          return List<Map<String, dynamic>>.from(data['documents']);
        }
      } else {
        print('Failed to fetch subjects for $day: ${response.statusCode}');
      }
      return null;
    }

    void printSubjectDetails(String day, Map<String, dynamic> subject) {
      final fields = subject['fields'];
      final from = fields['from']['integerValue'].toString();
      final to = fields['to']['integerValue'].toString();
      final name = fields['name']['stringValue'].toString();

      print('$day - Subject: $name from $from to $to');
    }

    final days = await getDays();
    if (days.isEmpty) {
      print('No schedule found.');
      return;
    }

    for (final day in days) {
      print('Schedule for $day:');
      final subjects = await getSubjects(day);
      if (subjects != null && subjects.isNotEmpty && day != 'saturday') {
        for (final subject in subjects) {
          printSubjectDetails(day, subject);
        }
      } else {
        print('No subjects found for $day.');
      }
    }
  }

// Function to get the next occurrence of a specific weekday
  DateTime getNextOccurrence(DateTime today, int weekday) {
    int daysToAdd = (weekday - today.weekday + 7) % 7;
    if (daysToAdd == 0) {
      daysToAdd =
          7; // Ensure we get the next occurrence of the same day in the future
    }
    return today.add(Duration(days: daysToAdd));
  }

// Function to fetch and add schedule to calendar
  Future<void> fetchAndAddScheduleToCalendar() async {
    final scheduleCollectionUrl = getScheduleHelper(majorHelper, yearHelper);
    final endDate = DateTime(2024, 6, 10); // Specify the end date

    // Function to get the list of days in the schedule
    Future<List<String>> getDays() async {
      final response = await http.get(Uri.parse(scheduleCollectionUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data != null && data['documents'] != null) {
          return List<String>.from(
              data['documents'].map((doc) => doc['name'].split('/').last));
        }
      } else {
        print('Failed to fetch schedule: ${response.statusCode}');
      }
      return [];
    }

    // Function to get the subjects for a specific day
    Future<List<Map<String, dynamic>>?> getSubjects(String day) async {
      final subjectsCollectionUrl = getSubjectHelper(majorHelper, yearHelper);
      final response = await http.get(Uri.parse(subjectsCollectionUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data != null && data['documents'] != null) {
          return List<Map<String, dynamic>>.from(data['documents']);
        }
      } else {
        print('Failed to fetch subjects for $day: ${response.statusCode}');
      }
      return null;
    }

    // Function to format time
    String formatTime(int time) {
      final hours = time ~/ 100;
      final minutes = time % 100;
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    }

    // Function to add event to calendar
    void addEventToCalendar(
        String day, Map<String, dynamic> subject, DateTime eventDate) {
      final fields = subject['fields'];
      final from = fields['from']['integerValue'];
      final to = fields['to']['integerValue'];
      final name = fields['name']['stringValue'];

      final fromTime = int.parse(from);
      final toTime = int.parse(to);

      final fromHour = fromTime ~/ 100;
      final fromMinute = fromTime % 100;
      final toHour = toTime ~/ 100;
      final toMinute = toTime % 100;

      final eventStart = DateTime(
          eventDate.year, eventDate.month, eventDate.day, fromHour, fromMinute);
      final eventEnd = DateTime(
          eventDate.year, eventDate.month, eventDate.day, toHour, toMinute);

      addEvent(
        eventName: name,
        startEventTime: eventStart.toString(),
        endEventTime: eventEnd.toString(),
        reminder: 'weekly',
        eventDescription:
            'Subject: $name from ${formatTime(fromTime)} to ${formatTime(toTime)}',
      );
    }

    // Get the list of days
    final days = await getDays();
    if (days.isEmpty) {
      print('No schedule found.');
      return;
    }

    final today = DateTime.now();

    // Map to associate day names with DateTime.weekday integers
    final weekdayMap = {
      'monday': DateTime.monday,
      'tuesday': DateTime.tuesday,
      'wednesday': DateTime.wednesday,
      'thursday': DateTime.thursday,
      'friday': DateTime.friday,
      'saturday': DateTime.saturday,
      'sunday': DateTime.sunday,
    };

    // Iterate over each day and add events to the calendar until the specified end date
    for (final day in days) {
      final weekday = weekdayMap[day.toLowerCase()];

      if (weekday == null) {
        continue;
      }

      DateTime eventDate = getNextOccurrence(today, weekday);

      while (eventDate.isBefore(endDate)) {
        final subjects = await getSubjects(day);
        if (subjects != null && subjects.isNotEmpty && day != 'saturday') {
          for (final subject in subjects) {
            addEventToCalendar(day, subject, eventDate);
          }
        } else {
          print('No subjects found for $day.');
        }

        // Move to the next occurrence of the same weekday
        eventDate = getNextOccurrence(eventDate, weekday);
      }
    }
  }

  Future<http.Response> getAllEventsByResponse() async {
    var userId = await LocalServices.getData(key: 'userId');

    final eventsCollectionUrl = constructUserEvents(userId);
    final response = await http.get(Uri.parse(eventsCollectionUrl));

    if (response.statusCode == 200) {
      return response; // Return the original HTTP response
    } else {
      print('Failed to fetch events: ${response.statusCode}');
      return response; // Return the original HTTP response in case of failure
    }
  }

  Future<http.Response> getAllEvents() async {
    var userId = await LocalServices.getData(key: 'userId');

    final eventsCollectionUrl = constructUserEvents(userId);
    final response = await http.get(Uri.parse(eventsCollectionUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['documents'];
      List<Map<String, dynamic>> documents = [];

      for (int i = 0; i < data.length; i++) {
        var event = data[i];
        Map<String, dynamic> fields = event['fields'];

        Map<String, dynamic> documentItem = {
          'name':
              event['name'], // Adjust this according to your document structure
          'fields': {
            'name': fields['name'],
            'id': {'stringValue': event['name'].split('/').last},
            'count': i.toString()
          }
        };

        documents.add(documentItem);
      }

      Map<String, dynamic> jsonResponse = {
        'documents': documents,
      };

      // Return the JSON response
      return http.Response(jsonEncode(jsonResponse), 200,
          headers: {'Content-Type': 'application/json'});
    } else {
      print('Failed to fetch events: ${response.statusCode}');
      // Return the original response in case of failure
      return response;
    }
  }
}
