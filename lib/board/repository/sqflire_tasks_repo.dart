import 'package:flexible/board/models/task.dart';
import 'package:flexible/board/repository/tasts_repo_interface.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteTasksRepo implements ITasksRepo {
  Database? db;

  // Init new db and create table
  Future _init() async {
    print('init sqflite db');
    db = await openDatabase('flex.db', version: 1,
        onCreate: (Database db, int version) async {
      print('creating new db');
      await db.execute(
          'CREATE TABLE Tasks (uuid TEXT PRIMARY KEY, title TEXT, subtitle TEXT, startMs INTEGER, endMS INTEGER , isDone INTEGER )');
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
    await (await getDb).rawInsert(
        SqliteTasksParser.taskToInsertString(task: task, tablename: 'Tasks'));
  }

  @override
  Future updateTask(Task task) async {
    await (await getDb).rawUpdate(
        'UPDATE Tasks SET isDone = ? WHERE uuid = "${task.uuid}"',
        ['${SqliteTasksParser.isDonetoInt(task.isDone)}']);
  }

  // Return all posible tasks
  @override
  Future<List<Task>> allTasks() async {
    try {
      List data = await (await getDb).rawQuery('SELECT * FROM Tasks');
      List<Task> tasks = SqliteTasksParser.tasksFromSqliteList(data);
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
          'SELECT * FROM Tasks WHERE startMs BETWEEN ${from.millisecondsSinceEpoch} AND ${to.millisecondsSinceEpoch}');
      List<Task> tasks = SqliteTasksParser.tasksFromSqliteList(data);
      return tasks;
    } catch (e) {
      throw Exception('Load from sqflite failed' + e.toString());
    }
  }

  @override
  Future deleteTask(Task task) {
    // TODO: implement deleteTask
    throw UnimplementedError();
  }
}

// Boring operations
class SqliteTasksParser {
  static List<Task> tasksFromSqliteList(List data) => data
      .map((e) => Task(
          uuid: e['uuid'] as String,
          title: e['title'] as String,
          subtitle: e['subtitle'] as String,
          timeStart: DateTime.fromMillisecondsSinceEpoch(e['startMs']),
          timeEnd: DateTime.fromMillisecondsSinceEpoch(e['endMS']),
          isDone: intToIsDone(e['isDone'])))
      .toList();

  static String taskToInsertString(
      {required Task task, required String tablename}) {
    int isDonetoInt() => task.isDone ? 1 : 0;

    return 'INSERT INTO $tablename(uuid, title, subtitle,startMs ,endMS,isDone ) VALUES("${task.uuid}","${task.title}","${task.subtitle}","${task.timeStart.millisecondsSinceEpoch}","${task.timeEnd.millisecondsSinceEpoch}","${isDonetoInt()}")';
  }

  static int isDonetoInt(bool done) => done ? 1 : 0;

  static bool intToIsDone(int num) => num == 1 ? true : false;
}
