import 'package:dio/dio.dart';
import 'package:wp_app/Util/LoginResponse.dart';
import 'package:wp_app/api_urls.dart';

///
///  Servizio per l'autenticazione tramite token
///
class AuthService {

  final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));

  ///
  /// Funzione per la registrazione dell'utente sul db postgress
  ///
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

  ///
  ///  Funzione per la richiesta del token di autenticazione
  ///
  Future<LoginResponse?> getToken(String username, String password) async {
    try {
      final response = await _dio.post(
        'api/auth/token',
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

  ///
  /// Funzione per l'aggiunta di un'immagine al server
  ///
  Future<String> addImage(String imagePath) async {
    try {
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imagePath,
          filename: 'upload.jpg',
        ),
      });

      final response = await _dio.post(
        'api/images',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return "Immagine caricata con successo!";
      }
    } on DioException catch (e) {
      print("Errore API: ${e.response?.data}");
      return "Errore durante il caricamento dell'immagine.";
    }
    return "Errore sconosciuto.";
  }
}