
class UserInfoModel {
  final String kind;
  final String localId;
  final String email;
  final String displayName;
  final String idToken;

  UserInfoModel({
    required this.kind,
    required this.localId,
    required this.email,
    required this.displayName,
    required this.idToken,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      kind: json['kind'],
      localId: json['localId'],
      email: json['email'],
      displayName: json['displayName'] ?? '',
      idToken: json['idToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kind': kind,
      'localId': localId,
      'email': email,
      'displayName': displayName,
      'idToken': idToken,
    };
  }
}

