class AllTaskModel {
  final String id;
  final String name;
  final bool done;
  final DateTime date;
  final DateTime createTime;
  final DateTime updateTime;

  AllTaskModel({
    required this.id,
    required this.name,
    required this.done,
    required this.date,
    required this.createTime,
    required this.updateTime,
  });

  factory AllTaskModel.fromJson(Map<String, dynamic> json, String id) {
    return AllTaskModel(
      id: id,
      name: json['fields']['name']['stringValue'] as String,
      done: json['fields']['done']['booleanValue'] as bool,
      date: DateTime.parse(json['fields']['date']['timestampValue'] as String)
          .add(const Duration(hours: 2)),
      createTime: DateTime.parse(json['createTime'] as String),
      updateTime: DateTime.parse(json['updateTime'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'done': done,
      'date': date.toIso8601String(),
      'createTime': createTime.toIso8601String(),
      'updateTime': updateTime.toIso8601String(),
    };
  }
}

class TasksResponse {
  final List<AllTaskModel> documents;

  TasksResponse({required this.documents});

  factory TasksResponse.fromJson(Map<String, dynamic> json) {
    var documentsJson = json['documents'] as List;
    List<AllTaskModel> tasksList = documentsJson.map((doc) {
      String taskId = (doc['name'] as String).split('/').last;
      return AllTaskModel.fromJson(doc, taskId);
    }).toList();

    return TasksResponse(documents: tasksList);
  }

  Map<String, dynamic> toJson() {
    return {
      'documents': documents.map((task) => task.toJson()).toList(),
    };
  }
}
