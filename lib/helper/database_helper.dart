import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'my_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute(
        'CREATE TABLE scanned_data (sn TEXT PRIMARY KEY UNIQUE, identifier TEXT,creator TEXT, created_date TIMESTAMP, product_id TEXT, tipe TEXT, detail_btm)');
    // Additional table creation or initialization goes here
  }

  // Future<void> _insertData(Database db,) async {
  //   await db.execute(sql)
  // }
}
