import 'dart:ffi';

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
        'api/auth/login',
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

  Future<LoginResponse?> AuthUser(String token) async {
    try {
      final response = await _dio.post(
        'auth/webview-login/',
        options: Options(
          headers: {
            // Usa 'Token'
            'Authorization': 'Token $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(response.data);
      }
    } on DioException catch (e) {
      print("Errore API (${e.response?.statusCode}): ${e.response?.data}");
    }
    return null;
  }

  Future<String?> getWebviewUrl(String token, {String next = '/template/'}) async {
    try {
      print("token passato: $token");
      final response = await _dio.get(
        'auth/webview-login/',
        queryParameters: {'Token': token},
      );

      if (response.statusCode == 200) {
        //print("risposta url completo: ${response.data['url'] as Int}");
        return null;//response.data['url'] as Int;

      }
    } on DioException catch (e) {
      print("Errore getWebviewUrl (${e.response?.statusCode}): ${e.response?.data}");
    }
    return null;
  }
}