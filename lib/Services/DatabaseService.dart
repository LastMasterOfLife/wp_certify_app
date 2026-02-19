import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../Util/LocationModel.dart';

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

  // Inserimento dati
  Future<int> insertLocation(LocationModel location) async {
    final db = await instance.database;
    return await db.insert('locations', location.toMap());
  }

  // Lettura dati
  Future<List<Map<String, dynamic>>> getAllLocations() async {
    final db = await instance.database;
    return await db.query('locations');
  }
}
