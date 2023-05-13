import 'package:sqflite/sqflite.dart';
// import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class DB {
  // Private constructor
  DB._();

  // DB INstance
  static final DB instance = DB._();

  // SQLite intance
  static Database? _database;

  get database async {
    if (_database != null) return _database;
    return await _initDatabase();
  }

  _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'crypt.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  _onCreate(db, version) async {
    await db.execute(_account);
    await db.execute(_wallet);
    await db.execute(_history);
    await db.insert('account', {'balance': 0});
  }

  String get _account => '''
    CREATE TABLE account (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      balance REAL
    );
  ''';

  String get _wallet => '''
    CREATE TABLE wallet (
      alias TEXT PRIMARY KEY,
      coin TEXT,
      quantity TEXT
    );
  ''';

  String get _history => '''
    CREATE TABLE history (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      opdate INT,
      optype TEXT,
      coin TEXT,
      alias TEXT,
      value REAL,
      quantity TEXT
    );
  ''';
}
