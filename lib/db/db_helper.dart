import 'package:path/path.dart';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/models/task.dart';

class DBHelper {
  static const _version = 1;
  static const _tableName = 'todos';
  static late final Database _database;

  static Future<void> initializeDatabase() async {
    try {
      final path = join(await getDatabasesPath(), 'tasks_database.db');
      debugPrint(path);
      _database = await openDatabase(
        'tasks_database.db',
        version: _version,
        onCreate: (Database database, int version) async {
          debugPrint('database created');
          await database.execute(
            'CREATE TABLE $_tableName('
            'id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'title STRING, '
            'body TEXT, '
            'date STRING, '
            'start_time STRING, '
            'end_time STRING, '
            'remind INTEGER, '
            'repeat STRING, '
            'color INTEGER, '
            'is_completed INTEGER'
            ')',
          );
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<int> insert(Task task) async {
    debugPrint('database inserted');
    return await _database.insert(_tableName, task.toMap());
  }

  static Future<int> delete(Task task) async {
    debugPrint('database deleted');
    return await _database.delete(_tableName, where: 'id = ?', whereArgs: [task.id]);
  }

  static Future<int> deleteAll() async {
    debugPrint('database deleted');
    return await _database.delete(_tableName);
  }

  static Future<List<Map<String, dynamic>>> query() async {
    debugPrint('database queried');
    return await _database.query(_tableName);
  }

  static Future<int> updateAsCompleted(Task task) async {
    debugPrint('database updated');
    return await _database.rawUpdate(
      '''UPDATE $_tableName
      SET is_completed = ?
      WHERE id = ?''',
      [1, task.id ?? -1],
    );
  }
}
