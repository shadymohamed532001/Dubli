class FocusResponse {
  final int predictedMinutes;

  FocusResponse({required this.predictedMinutes});

  factory FocusResponse.fromJson(Map<String, dynamic> json) {
    // Adding null safety checks
    if (json['predicted_minutes'] == null) {
      throw Exception('predicted_minutes is null');
    }

    return FocusResponse(
      predictedMinutes: json['predicted_minutes'],
    );
  }
}
