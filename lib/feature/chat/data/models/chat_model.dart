class ChatbotResponse {
  final String message;

  ChatbotResponse({
    required this.message,
  });

  factory ChatbotResponse.fromJson(Map<String, dynamic> json) {
    return ChatbotResponse(
      message: json['response'],
    );
  }
}