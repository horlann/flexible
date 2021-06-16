import 'package:flexible/board/models/tasks/regular_taks.dart';
import 'package:flexible/board/models/tasks/supertask.dart';
import 'package:flexible/board/models/tasks/task.dart';
import 'package:flexible/board/repository/tasts_repo_interface.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteTasksRepo implements ITasksRepo {
  Database? db;

  // Init new db and create table
  Future _init() async {
    db = await openDatabase('tasks34.db', version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Tasks (uuid TEXT PRIMARY KEY, title TEXT, subtitle TEXT, timeStart INTEGER, period INTEGER , isDone INTEGER , isDonable INTEGER, timeLock INTEGER , color TEXT, iconId TEXT,deadline INTEGER, globalDuration INTEGER, globalDurationLeft INTEGER, priority INTEGER, isSuperTask INTEGER)');
      await db.execute(
          'CREATE TABLE SuperTasksQueue (uuid TEXT PRIMARY KEY, title TEXT, subtitle TEXT, timeStart INTEGER, period INTEGER , isDone INTEGER , isDonable INTEGER, timeLock INTEGER , color TEXT, iconId TEXT,deadline INTEGER, globalDuration INTEGER, globalDurationLeft INTEGER, priority INTEGER, isSuperTask INTEGER)');
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
  Future setTask(Task task) async {
    await (await getDb).insert('tasks', task.toSqfMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Return all posible tasks
  @override
  Future<List<Task>> allTasks() async {
    try {
      List data = await (await getDb).rawQuery('SELECT * FROM Tasks');
      List<Task> tasks = data.map((e) {
        if (e['isSuperTask'] != null) {
          return SuperTask.fromSqfMap(e);
        } else {
          return RegularTask.fromSqfMap(e);
        }
      }).toList();
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
      List<Task> tasks = data.map((e) {
        if (e['isSuperTask'] != null) {
          return SuperTask.fromSqfMap(e);
        } else {
          return RegularTask.fromSqfMap(e);
        }
      }).toList();
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

  @override
  Future setSuperTaskToQueue(SuperTask task) async {
    await (await getDb).insert('SuperTasksQueue', task.toSqfMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<List<SuperTask>> superTaskQueue() async {
    try {
      List data = await (await getDb).rawQuery('SELECT * FROM SuperTasksQueue');
      List<SuperTask> tasks = data.map((e) => SuperTask.fromSqfMap(e)).toList();
      return tasks;
    } catch (e) {
      throw Exception('Load from sqflite failed' + e.toString());
    }
  }

  @override
  Future deleteSuperTaskfromQueue(SuperTask task) async {
    await (await getDb).rawDelete(
        'DELETE FROM SuperTasksQueue WHERE uuid = ?', ['${task.uuid}']);
  }

  @override
  Stream? onChanges;
}
