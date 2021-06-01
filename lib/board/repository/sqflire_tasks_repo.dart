import 'package:flexible/board/models/task.dart';
import 'package:flexible/board/repository/tasts_repo_interface.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteTasksRepo implements ITasksRepo {
  Database? db;

  // Init new db and create table
  Future _init() async {
    db = await openDatabase('tasks.db', version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Tasks (uuid TEXT PRIMARY KEY, title TEXT, subtitle TEXT, timeStart INTEGER, period INTEGER , isDone INTEGER , isDonable INTEGER , color TEXT )');
    });
  }

  // Init db if dont and return
  Future<Database> get getDb async {
    if (db == null) {
      await _init();
      return db!;
    }
    return db!;
  }

  @override
  Future addTask(Task task) async {
    await (await getDb).insert('tasks', task.toSqfMap());
  }

  @override
  Future updateTask(Task task) async {
    await (await getDb).update('tasks', task.toSqfMap(),
        where: 'uuid = ?', whereArgs: [task.uuid]);
  }

  // Return all posible tasks
  @override
  Future<List<Task>> allTasks() async {
    try {
      List data = await (await getDb).rawQuery('SELECT * FROM Tasks');
      List<Task> tasks = data.map((e) => Task.fromSqfMap(e)).toList();
      return tasks;
    } catch (e) {
      throw Exception('Load from sqflite failed' + e.toString());
    }
  }

  @override
  Future<List<Task>> tasksByPeriod(
      {required DateTime from, required DateTime to}) async {
    try {
      List data = await (await getDb).rawQuery(
          'SELECT * FROM Tasks WHERE timeStart BETWEEN ${from.millisecondsSinceEpoch} AND ${to.millisecondsSinceEpoch} ORDER BY timeStart');
      List<Task> tasks = data.map((e) => Task.fromSqfMap(e)).toList();
      return tasks;
    } catch (e) {
      throw Exception('Load from sqflite failed' + e.toString());
    }
  }

  @override
  Future deleteTask(Task task) async {
    await (await getDb)
        .rawDelete('DELETE FROM Tasks WHERE uuid = ?', ['${task.uuid}']);
  }
}
