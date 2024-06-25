class Task {
  final String name;
  final String id;
  final DateTime date;
  final bool done;

  Task({
    required this.name,
    required this.id,
    required this.date,
    required this.done,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      name: map['fields']['name'],
      id: map['fields']['id'],
      date: DateTime.parse(map['fields']['date']),
      done: map['fields']['done'],
    );
  }
}