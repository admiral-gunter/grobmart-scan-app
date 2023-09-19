import 'dart:convert';

import 'package:sqflite/sqflite.dart';
// import 'package:sqflite/sqlite_api.dart';
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
      version: 2,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''CREATE TABLE IF NOT EXISTS scanned_data_offline (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      sn TEXT UNIQUE,
      identifier TEXT,
      tipe TEXT,
      product_name TEXT,
      date_modified DATETIME DEFAULT CURRENT_TIMESTAMP,
      date_added DATETIME DEFAULT CURRENT_TIMESTAMP,
      status TEXT,
      creator TEXT
    );
    ''');
    //db untuk lokasi;
    await db.execute(
        '''CREATE TABLE IF NOT EXISTS inventory_location (id INTEGER PRIMARY KEY UNIQUE, text TEXT)''');
    //db untuk customer;
    await db.execute('''
      CREATE TABLE IF NOT EXISTS customers (
        id INTEGER PRIMARY KEY,
        firstname TEXT,
        lastname TEXT,
        fullname TEXT,
        shop_name TEXT,
        phone TEXT,
        mobile TEXT,
        email TEXT,
        birth_place TEXT,
        birth_date TEXT,
        gender TEXT,
        status TEXT,
        preferences TEXT,
        newsletter TEXT,
        address TEXT,
        provinsi TEXT,
        kabupaten_kota TEXT,
        kode_pos TEXT,
        sales TEXT,
        sales_id TEXT,
        group_id INTEGER,
        user_company_id INTEGER,
        date_added DATETIME,
        date_modified DATETIME,
        address_show TEXT
      );
    ''');

    await db.execute('''CREATE TABLE inventory_validasi_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        code TEXT,
        sn TEXT,
        identifier TEXT,
        location_id INT,
        customer_id INT,
        creator TEXT,
        date_added TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        date_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        status TEXT CHECK(status IN ('unvalidasi', 'validasi')) DEFAULT 'unvalidasi' NOT NULL
    )
    ''');

    await db.execute('''CREATE TABLE service_offline (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        code TEXT,
        sn TEXT,
        identifier TEXT,
        location_id INT,
        customer_id INT,
        creator TEXT,
        date_added TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        date_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        status TEXT CHECK(status IN ('unvalidasi', 'validasi')) DEFAULT 'unvalidasi' NOT NULL,
        customer_nama TEXT,
        customer_notelp TEXT,
        tipe TEXT
    )
    ''');

    await db.execute('''CREATE TABLE pindah_gudang_offline (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        code TEXT,
        sn TEXT,
        identifier TEXT,
        location_id INT,
        customer_id INT,
        creator TEXT,
        dari_gudang TEXT,
        ke_gudang TEXT,
        in_out TEXT,
        kd_pindah_gudang TEXT,
        date_added TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        date_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        status TEXT CHECK(status IN ('unvalidasi', 'validasi')) DEFAULT 'unvalidasi' NOT NULL,
        customer_nama TEXT,
        customer_notelp TEXT
    )
    ''');
  }

  Future<void> insertDatainventoryLocation(List<dynamic> data) async {
    final db = await instance.database;
    for (final item in data) {
      await db.insert('inventory_location', item,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<Map<String, dynamic>> insertInventoryValidasiHistory(
      Map<String, dynamic> data) async {
    final db = await instance.database;
    try {
      await db.insert('inventory_validasi_history', data);
      return {'result': true, 'message': 'Data inserted successfully.'};
    } catch (e) {
      return {'result': false, 'message': 'Failed to insert data: $e'};
    }
  }

  Future<Map<String, dynamic>> insertServiceOffline(data) async {
    final db = await instance.database;
    try {
      Map<String, dynamic> map = {};

      data.forEach((key, value) {
        if (key is String) {
          map[key] = value;
        }
      });

      await db.insert('service_offline', map);
      return {'result': true, 'message': 'Data inserted successfully.'};
    } catch (e) {
      return {'result': false, 'message': 'Failed to insert data: $e'};
    }
  }

  Future<List<dynamic>> getDataService() async {
    final db = await instance.database;
    return await db.query('service_offline');
  }

  Future insertPindahGudangOffline(data) async {
    final db = await instance.database;
    try {
      Map<String, dynamic> map = {};

      data.forEach((key, value) {
        if (key is String) {
          map[key] = value;
        }
      });

      await db.insert('pindah_gudang_offline', map);
      return {'result': true, 'message': 'Data inserted successfully.'};
    } catch (e) {
      return {'result': false, 'message': 'Failed to insert data: $e'};
    }
  }

  Future<List<dynamic>> getDataPindahGudang() async {
    final db = await instance.database;
    return await db.query('pindah_gudang_offline');
  }

  Future<List<Map<String, dynamic>>> getDataInvHistory() async {
    final db = await instance.database;
    return await db.query('inventory_validasi_history');
  }

  Future<void> insertDataCustomer(List<dynamic> data) async {
    final db = await instance.database;
    for (final item in data) {
      // print(data);
      await db.insert('customers', item,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<List<Map<String, dynamic>>> getData() async {
    final db = await instance.database;
    return await db.query('inventory_location');
  }

  Future<List<Map<String, dynamic>>> getInventoryLocations() async {
    final db = await instance.database;
    return await db.query('inventory_location');
  }

  Future<List<Map<String, dynamic>>> getCustomers() async {
    final db = await instance.database;
    List<Map<String, dynamic>> result = await db.rawQuery(
      '''SELECT id, firstname || ' ' || lastname || ' ( ' || shop_name || ' ) ' || ' ' || phone AS name FROM customers''',
    );

    return result;
  }
}
