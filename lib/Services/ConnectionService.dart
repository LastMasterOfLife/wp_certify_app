import 'dart:async';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectionService {

  ConnectionService._internal();
  static final ConnectionService _instance = ConnectionService._internal();
  factory ConnectionService() => _instance;

  StreamSubscription<InternetStatus>? _subscription;
  bool hasConnection = false;

  void initialize() {
    _subscription?.cancel();
    _subscription = InternetConnection().onStatusChange.listen((InternetStatus status) {
      hasConnection = (status == InternetStatus.connected);
      print("Stato connessione: $hasConnection");
    });
  }

  Future<bool> checkNow() async {
    return await InternetConnection().hasInternetAccess;
  }

  void dispose() {
    _subscription?.cancel();
  }
}
