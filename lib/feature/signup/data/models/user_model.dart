class UserModel {
  final String idToken;
  final String email;
  final String refreshToken;
  final String expiresIn;
  final String localId;

  UserModel({
    required this.idToken,
    required this.email,
    required this.refreshToken,
    required this.expiresIn,
    required this.localId,
  });

  // Factory constructor to create an UserModel from JSON data
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      idToken: json['idToken'] ?? '',
      email: json['email'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      expiresIn: json['expiresIn'] ?? '',
      localId: json['localId'] ?? '',
    );
  }

  // Method to convert UserModel to JSON data
  Map<String, dynamic> toJson() {
    return {
      'idToken': idToken,
      'email': email,
      'refreshToken': refreshToken,
      'expiresIn': expiresIn,
      'localId': localId,
    };
  }
}
