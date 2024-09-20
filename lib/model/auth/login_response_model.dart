class AuthResponse {
  final bool success;
  final String message;
  final UserData data;

  AuthResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'],
      message: json['message'],
      data: UserData.fromJson(json['data']),
    );
  }
}

class UserData {
  final String user;
  final String firstName;
  final String surname;
  final String lastLogin;
  final String token;

  UserData({
    required this.user,
    required this.firstName,
    required this.surname,
    required this.lastLogin,
    required this.token,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      user: json['user'],
      firstName: json['firstName'],
      surname: json['surname'],
      lastLogin: json['lastLogin'],
      token: json['token'],
    );
  }
}
