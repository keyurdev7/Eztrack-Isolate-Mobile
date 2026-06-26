class LoginCredentials {
  final String email;
  final String password;
  final DateTime timestamp;

  LoginCredentials({
    required this.email,
    required this.password,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory LoginCredentials.fromJson(Map<String, dynamic> json) {
    return LoginCredentials(
      email: json['email'],
      password: json['password'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  @override
  String toString() {
    return 'LoginCredentials(email: $email, password: [HIDDEN], timestamp: $timestamp)';
  }
}