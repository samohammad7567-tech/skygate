import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

import 'package:skygate/tourism/modules/user/user_class_model.dart';

class UserClassesDatabaseHelper {
  static Database? _database;
  String path = "";

  Future<Database?> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database;
  }

  initDatabase() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    path = join(directory.path, 'classes.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }
// creating database table
  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE classes(id INTEGER PRIMARY KEY, name_en VARCHAR, name_ar VARCHAR,'
            'related_edu_stage VARCHAR, edu_stage_en VARCHAR, edu_stage_ar VARCHAR,'
            'students_number INTEGER, created_at VARCHAR, updated_at VARCHAR)');
  }
// inserting data into the table
  Future<int> insert(UserClassModel userClass) async {
    var dbClient = await database;
    int id = await dbClient!.insert('classes', userClass.toJSON(model: userClass));
    return id;
  }

// getting all the items in the list from the database
  Future<List<UserClassModel>> getUserClassesList() async {
    var dbClient = await database;
    final List<Map<String, Object?>> queryResult =
    await dbClient!.query('classes');
    return queryResult.map((result) => UserClassModel.fromJSON(result)).toList();
  }

  Future<int> deleteUserClassItem(int id) async {
    var dbClient = await database;
    return await dbClient!.delete('classes', where: 'id = ?', whereArgs: [id]);
  }
}