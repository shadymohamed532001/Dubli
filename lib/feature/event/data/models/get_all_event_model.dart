import 'dart:convert';

class Event {
  final String id;
  final String name;
  final String startTime;
  final String endTime;
  final String description;
  final String reminder;

  Event({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.description,
    required this.reminder,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      startTime: json['fields']['startTime'],
      endTime: json['fields']['endTime'],
      description: json['fields']['description'] ?? '',
      reminder: json['fields']['reminder'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'fields': {
        'startTime': startTime,
        'endTime': endTime,
        'description': description,
        'reminder': reminder,
      },
    };
  }
}

class EventList {
  final List<Event> events;

  EventList({required this.events});

  factory EventList.fromJson(List<dynamic> jsonList) {
    List<Event> events = jsonList.map((json) => Event.fromJson(json)).toList();
    return EventList(events: events);
  }

  List<Map<String, dynamic>> toJson() {
    return events.map((event) => event.toJson()).toList();
  }

  // Function to convert EventList to JSON string
  String toJsonString() {
    return jsonEncode(toJson());
  }

  // Static function to create EventList from JSON string
  static EventList fromJsonString(String jsonString) {
    List<dynamic> jsonList = jsonDecode(jsonString)['events'];
    List<Event> events = jsonList.map((json) => Event.fromJson(json)).toList();
    return EventList(events: events);
  }
}
