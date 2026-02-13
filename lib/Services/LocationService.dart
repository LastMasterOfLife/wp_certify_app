import 'dart:async';
import 'package:geolocator/geolocator.dart';

class LocationService {

  static final LocationService _instance = LocationService._internal();


  LocationService._internal();


  factory LocationService() => _instance;


  Stream<Position> get locationStream => Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Aggiorna ogni 10 metri
    ),
  );


  Future<bool> checkPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission != LocationPermission.deniedForever &&
        permission != LocationPermission.denied;
  }
}

