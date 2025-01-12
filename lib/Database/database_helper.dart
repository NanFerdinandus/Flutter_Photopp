import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('profiles.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2, // Versie verhoogd naar 2
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE profiles (
      id $idType,
      name $textType,
      theme $textType NOT NULL DEFAULT "Black and White",
      description $textType NOT NULL DEFAULT "",
      location $textType
    )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Verwijder de 'email' kolom en voeg de nieuwe kolommen toe
      await db.execute('PRAGMA foreign_keys=off');  // Zet foreign keys uit om te kunnen wijzigen
      await db.execute('CREATE TABLE profiles_temp AS SELECT id, name, theme, description, location FROM profiles');
      await db.execute('DROP TABLE profiles');
      await db.execute('ALTER TABLE profiles_temp RENAME TO profiles');
      await db.execute('PRAGMA foreign_keys=on');  // Zet foreign keys weer aan
    }
  }

  Future<int> createProfile(Map<String, dynamic> profile) async {
    final db = await instance.database;
    return await db.insert('profiles', profile);
  }

  Future<List<Map<String, dynamic>>> readAllProfiles() async {
    final db = await instance.database;
    return await db.query('profiles');
  }

  Future<int> updateProfile(int id, Map<String, dynamic> profile) async {
    final db = await instance.database;
    return await db.update('profiles', profile, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteProfile(int id) async {
    final db = await instance.database;
    return await db.delete('profiles', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
