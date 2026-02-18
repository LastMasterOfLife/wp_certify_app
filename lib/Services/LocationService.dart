import 'dart:async';
import 'package:geolocator/geolocator.dart';


///
/// Servizio di geloaclizazione
///
class LocationService {

  static final LocationService _instance = LocationService._internal();
  LocationService._internal();
  factory LocationService() => _instance;

  ///
  /// Funzione per ottener le lat e long
  ///
  Stream<Position> get locationStream => Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Aggiorna ogni 10 metri
    ),
  );

  ///
  /// Funzione per verificare e gestire i permessi
  ///
  Future<bool> checkPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission != LocationPermission.deniedForever &&
        permission != LocationPermission.denied;
  }
}

