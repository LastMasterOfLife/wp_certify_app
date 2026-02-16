class LoginResponse {
  final String token;
  final String redirectUrl;
  final String username;

  LoginResponse({required this.token, required this.redirectUrl, required this.username});

  // Factory per convertire il JSON di Dio in oggetto Dart
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      redirectUrl: json['redirect_url'],
      username: json['username'],
    );
  }
}