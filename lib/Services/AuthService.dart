import 'package:dio/dio.dart';
import 'package:wp_app/Util/LoginResponse.dart';
import 'package:wp_app/api_urls.dart';

class AuthService {

  final Dio _dio = Dio(BaseOptions(
    baseUrl: base_url,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));

  Future<bool> registerUser(String username, String password) async {
    try {
      final response = await _dio.post(
        'api/register',
        data: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 201) {
        print("Successo: Utente salvato su PostgreSQL");
        return true;
      }
    } on DioException catch (e) {

      if (e.response != null) {

        print("Errore Server: ${e.response?.data}");
        return false;
      } else {

        print("Errore Invio: ${e.message}");
        return false;
      }
    }
    return false;
  }

  Future<LoginResponse?> loginUser(String username, String password) async {
    try {
      final response = await _dio.post(
        'api/login',
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(response.data);
      }
    } on DioException catch (e) {
      print("Errore API: ${e.response?.data}");
    }
    return null;
  }
}