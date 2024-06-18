import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class dataBaseService{
  Database? _database;
  Database? __database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'likedposts.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE likedposts(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, image TEXT, description TEXT)",
        );
      },
    );
  }

  Future<void> insertLikedPost(Map<String, dynamic> post) async {
    final db = await database;
    await db.insert(
      'likedposts',
      post,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getLikedPosts() async {
    final db = await database;
    return await db.query('likedposts');
  }

  Future<Database> get database1 async {
    if (__database != null) return __database!;
    __database = await _initDatabase1();
    return __database!;
  }

  Future<Database> _initDatabase1() async {
    String path = join(await getDatabasesPath(), 'saves.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE saves(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, image TEXT, description TEXT)",
        );
      },
    );
  }

  Future<void> insertsaves(Map<String, dynamic> post) async {
    final db = await database1;
    await db.insert(
      'saves',
      post,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getsaves() async {
    final db = await database1;
    return await db.query('saves');
  }

}