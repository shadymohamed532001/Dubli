import 'dart:convert';

import 'package:dubli/core/helper/helper_const.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

part 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  EventCubit() : super(EventInitial());
  var formKey = GlobalKey<FormState>();
  AutovalidateMode? autovalidateMode = AutovalidateMode.disabled;

  var titleController = TextEditingController();
  var noteController = TextEditingController();
  dynamic eventId;
  Future<void> addEvent(
      {required String eventName,
      required String eventTime,
      required String eventDate,
      required String eventDescription}) async {

    emit(AddEventLoading());
    final eventsCollectionUrl = constructUserEvents(useridHelper);

    // Create the event document with Firestore-generated document ID
    final response = await http.post(
      Uri.parse(eventsCollectionUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'fields': {
          'name': {'stringValue': eventName},
          'time': {'stringValue': eventTime},
          'date': {'stringValue': eventDate},
          'description': {'stringValue': eventDescription},
        },
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      eventId = responseData['name'].split('/').last;
      emit(AddEventSuccess());

      print('event added $eventId ');
    } else {
      emit(const AddEventError(error: 'Error adding event'));
    }
  }

// Function to edit an event
  Future<void> editEvent(String eventName, String newEventName,
      String newEventTime, String newEventDescription) async {
    final eventsCollectionUrl = getUserEvents(useridHelper, eventId);

    // Update the event data
    final response2 = await http.patch(
      Uri.parse(eventsCollectionUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'fields': {
          'name': {'stringValue': newEventName},
          'time': {'stringValue': newEventTime},
          'description': {'stringValue': newEventDescription},
        },
      }),
    );

    if (response2.statusCode == 200) {
      print('Event edited successfully!');
    } else {
      print('Error editing event');
    }
  }

  Future<void> deleteEvent(dynamic eventId, String eventName, String eventTime,
      String eventDescription, bool delete) async {
    final eventDocUrl = getUserEvents(useridHelper, eventId);

    final response3 = await http.patch(
      Uri.parse(eventDocUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'fields': {
          'name': {'stringValue': eventName},
          'time': {'stringValue': eventTime},
          'description': {'stringValue': eventDescription},
          'soft-delete': {'booleanValue': delete},
        },
      }),
    );

    if (response3.statusCode == 200) {
      print('Event deleted successfully!');
    } else {
      print('Error deleting event');
    }
  }
}
