class Task {
  final String name;
  final String id;
  final int count;

  Task({
    required this.name,
    required this.id,
    required this.count,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      name: json['fields']['name']['stringValue'] as String,
      id: json['fields']['id']['stringValue'] as String,
      count: json['fields']['count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'count': count,
    };
  }
}
