class LocationModel {
  final int? id;
  final double latitude;
  final double longitude;
  final bool isOnline;

  LocationModel({this.id, required this.latitude, required this.longitude, required this.isOnline});
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'isOnline': isOnline ? 1 : 0, // SQLite non supporta booleani, usa 1/0
    };
  }
}
