class HistoryChatModel {
  String id;
  List<Message> messages;

  HistoryChatModel({required this.id, required this.messages});

  factory HistoryChatModel.fromJson(Map<String, dynamic> json) {
    return HistoryChatModel(
      id: json['id'],
      messages: List<Message>.from(
          json['messages'].map((message) => Message.fromJson(message))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'messages': messages.map((message) => message.toJson()).toList(),
    };
  }
}

class Message {
  String assistant;
  String user;

  Message({required this.assistant, required this.user});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      assistant: json['assistant'] ?? '',
      user: json['user'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assistant': assistant,
      'user': user,
    };
  }
}
