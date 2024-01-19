import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqf_app/notes_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;
  Future<Database?> get getDataBase async {
    if (_db != null) {
      return _db;
    }
    _db = await _initializeDataBase();
    return _db;
  }

  _initializeDataBase() async {
    Directory docsDirectory = await getApplicationDocumentsDirectory();
    String path = join(docsDirectory.path, "notes.db");
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE notes (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, age INTEGER NOT NULL, description TEXT NOT NULL, email TEXT )");
  }

  Future<void> insertData({required NotesModel model}) async {
    var data = await getDataBase;
    await data!.insert("notes", model.toDb());
  }

  Future<List<NotesModel>> getData() async {
    var dbData = await getDataBase;
    final List<Map<String, dynamic>> result = await dbData!.query("notes");
    return result.map((e) => NotesModel.fromDb(e)).toList();
  }

  Future<void> deleteData(int id) async {
    var db = await getDataBase;
    db!.delete("notes", where: "id = ?", whereArgs: [id]);
  }

  Future<void> updateData(NotesModel model) async {
    var db = await getDataBase;
    db!.update("notes", model.toDb(), where: "id = ?", whereArgs: [model.id]);
  }
}
