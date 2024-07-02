class UserInfo {
  final String id;
  final String token;
  final String email;
  final String password;
  final String phone;
  final String gender;
  final String age;
  final String username;

  UserInfo({
    required this.id,
    required this.token,
    required this.email,
    required this.password,
    required this.phone,
    required this.gender,
    required this.age,
    required this.username,
  });

  // Factory method to create a UserInfo object from a map
  factory UserInfo.fromMap(Map<String, dynamic> data) {
    return UserInfo(
      id: data['localId'] ?? '',
      token: data['idToken'] ?? '',
      email: data['email'] ?? '',
      password: '', // Password should not be stored in plain text
      phone: data['phone'] ?? '',
      gender: data['gender'] ?? '',
      age: data['age'] ?? '',
      username: data['username'] ?? '',
    );
  }

  // Method to convert a UserInfo object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'token': token,
      'email': email,
      'password': password,
      'phone': phone,
      'gender': gender,
      'age': age,
      'username': username,
    };
  }
}
