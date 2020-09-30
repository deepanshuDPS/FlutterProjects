import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

class DBHelper {
  static Future<sql.Database> database(String tableName) async {
    final dbPath = await sql.getDatabasesPath();
    return await sql.openDatabase(path.join(dbPath, 'places.db'), version: 1,
        onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE $tableName(id TEXT PRIMARY KEY,title TEXT,image TEXT, loc_lat REAL,loc_long REAL,address TEXT)");
    });
  }

  static Future<void> insert(String tableName, Map<String, Object> data) async {
    final db = await database(tableName);
    await db.insert(tableName, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String,dynamic >>> getData(String tableName) async {
    final db = await database(tableName);
    return await db.query(tableName);
  }
}
