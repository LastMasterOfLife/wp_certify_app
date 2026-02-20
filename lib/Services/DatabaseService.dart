import 'package:dio/dio.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../Util/LocationModel.dart';
import '../api_urls.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('locations.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // Creazione della tabella con REAL per lat/long
    await db.execute('''
      CREATE TABLE locations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        isOnline INTEGER NOT NULL
      )
    ''');
  }

  ///
  /// Funzione per inserire una nuova posizione nel database
  ///
  Future<int> insertLocation(LocationModel location) async {
    final db = await instance.database;
    return await db.insert('locations', location.toMap());
  }

  ///
  /// Funzione per recuperare tutte le posizioni salvate nel database
  ///
  Future<List<Map<String, dynamic>>> getAllLocations() async {
    final db = await instance.database;
    return await db.query('locations');
  }

  ///
  /// Funzione per stampare tutte le coordinate salvate nel database
  /// con il relativo stato online/offline
  ///
  Future<void> printAllLocations() async {
    final locations = await getAllLocations();

    if (locations.isEmpty) {
      print('[DatabaseService] Nessuna coordinata trovata nel database.');
      return;
    }

    print('[DatabaseService] Lista coordinate salvate (${locations.length} totali):');
    for (final loc in locations) {
      print(
          '  ID: ${loc['id']} | '
              'Lat: ${loc['latitude']} | '
              'Lon: ${loc['longitude']} | '
              'Online: ${loc['isOnline'] == 1 ? 'Sì' : 'No'}'
      );
    }
  }

  ///
  /// Funzione per sincronizzare le location salvate offline con il server Django
  ///
  Future<void> syncOfflineLocations() async {
    final db = await instance.database;

    // Recupera solo le location salvate quando NON c'era internet
    final offlineLocations = await db.query(
      'locations',
      where: 'isOnline = ?',
      whereArgs: [0],
    );

    if (offlineLocations.isEmpty) {
      print('[DatabaseService] Nessuna location offline da sincronizzare.');
      return;
    }

    print('[DatabaseService] Trovate ${offlineLocations.length} location offline da sincronizzare...');

    final Dio _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ));

    int synced = 0;

    for (final row in offlineLocations) {
      final id = row['id'] as int;
      final latitude = row['latitude'] as double;
      final longitude = row['longitude'] as double;

      try {
        final response = await _dio.post(
          '/api/locations/',
          data: {
            'latitude': latitude,
            'longitude': longitude,
          },
        );

        if (response.statusCode == 201) {
          await db.update(
            'locations',
            {'isOnline': 1},
            where: 'id = ?',
            whereArgs: [id],
          );
          synced++;
          print('[DatabaseService] ✅ ID $id sincronizzata (lat: $latitude, lon: $longitude)');
        }
      } on DioException catch (e) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.unknown) {
          print('[DatabaseService] 🔌 ID $id errore di rete: ${e.message}');
        } else {
          print('[DatabaseService] ❌ ID $id fallita: ${e.response?.statusCode} - ${e.response?.data}');
        }
      }
    }

    print('[DatabaseService] Sincronizzazione completata: $synced/${offlineLocations.length}');
  }
}
