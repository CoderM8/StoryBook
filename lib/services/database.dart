import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../model/downlodsong/download_model.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDatabase();
    return _database;
  }

  initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentDirectory.path, 'database.db');

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE downloadSong (id INTEGER,bookid INTEGER , name TEXT, link TEXT, artist TEXT ,imagepath TEXT,userId TEXT,bookname TEXT, PRIMARY KEY(id AUTOINCREMENT))');
  }

  Future<bool> isdownload(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('downloadSong', where: 'id = ?', whereArgs: [id]);
    return maps.isNotEmpty ? true : false;
  }

  Future addDownload(DownloadSong dSongs) async {
    var db = await database;
    dSongs.id = await db!.insert('downloadSong', dSongs.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return dSongs;
  }

  Future<List<DownloadSong>> getDownloadSongs({required userId}) async {
    var db = await database;
    List<Map> maps = await db!.query('downloadSong',
        where: 'userId = ?', whereArgs: [userId], columns: ['id', 'bookid', 'name', 'artist', 'link', 'imagepath', 'userId', 'bookname']);

    List<DownloadSong> downloadsong = [];
    if (maps.isNotEmpty) {
      for (int i = 0; i < maps.length; i++) {
        downloadsong.add(DownloadSong.fromMap(maps[i]));
      }
    }
    return downloadsong;
  }

  Future<int> deleteDownloadSongs(int id) async {
    var db = await database;
    return await db!.delete(
      'downloadSong',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
