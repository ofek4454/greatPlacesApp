import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper {
  static const tableName = 'user_places';

  static Future<sql.Database> getDB() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'places.db'),
      version: 1,
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE $tableName(id TEXT PRIMARY KEY, title TEXT, image TEXT, loc_lat REAL, loc_lng REAL, address TEXT)');
      },
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.getDB();
    await db.insert(table, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> loadData(String table) async {
    final db = await DBHelper.getDB();
    return db.query(table);
  }
}
