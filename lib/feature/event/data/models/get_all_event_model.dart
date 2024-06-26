class Event {
  final String name;
  final DateTime startTime;
  final DateTime endTime;
  final String description;
  final String reminder;

  Event({
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.description,
    required this.reminder,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      name: json['name'],
      startTime: DateTime.parse(json['fields']['startTime']),
      endTime: DateTime.parse(json['fields']['endTime']),
      description: json['fields']['description'],
      reminder: json['fields']['reminder'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'fields': {
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'description': description,
        'reminder': reminder,
      },
    };
  }
}
