import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;
  static const String _tableName = 'user_damkar';

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDatabase();
    return _database!;
  }

  static Future<Database> initDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = join(path, 'user_damkar.db');

    return openDatabase(
      databasePath,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY,
        name TEXT,
        email TEXT,
        notlp TEXT
      )
    ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE $_tableName ADD COLUMN notlp TEXT');
        }
      },
    );
  }

  static Future<void> insertData(Map<String, dynamic> data) async {
    final db = await database;
    await db.insert(
      _tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<Map<String, dynamic>?> getUser() async {
  final db = await database;
  final List<Map<String, dynamic>> result = await db.query(_tableName, limit: 1);
  if (result.isNotEmpty) {
    return result.first;
  }
  return null;
}


  static Future<List<Map<String, dynamic>>> getData() async {
    final db = await database;
    return db.query(_tableName);
  }

  static Future<void> deleteData() async {
    final db = await database;
    await db.delete(_tableName);
  }

  static Future<void> editUserData(int id, Map<String, dynamic> newData) async {
    final db = await database;
    await db.update(
      _tableName,
      newData,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int?> getUserId() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      _tableName,
      columns: ['userid'],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['userid'] as int?;
    }
    return null;
  }
}
