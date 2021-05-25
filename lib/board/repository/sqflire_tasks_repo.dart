import 'package:flexible/board/models/task.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteTasksRepo {
  Database? db;

  Future _init() async {
    print('init sqflite db');
    db = await openDatabase('flex.db', version: 1,
        onCreate: (Database db, int version) async {
      print('creating new db');
      await db.execute(
          'CREATE TABLE Tasks (uuid TEXT PRIMARY KEY, title TEXT, subtitle TEXT, startMs TEXT, endMS TEXT , isDone INTEGER )');
    });
  }

  Future<bool> checkInit() async {
    db ?? await _init();
    return true;
  }

  Future addTask(Task task) async {
    await checkInit();

    int isDonetoInt() => task.isDone ? 1 : 0;

    await db!.rawInsert(
        'INSERT INTO Tasks(uuid, title, subtitle,startMs ,endMS,isDone ) VALUES("${task.uuid}","${task.title}","${task.subtitle}","${task.timeStart.millisecondsSinceEpoch}","${task.timeEnd.millisecondsSinceEpoch}","${isDonetoInt()}")');
  }

  Future updateTaskDone(Task task) async {
    await checkInit();

    int isDonetoInt() => task.isDone ? 1 : 0;

    await db!.rawUpdate(
        'UPDATE Tasks SET isDone = ? WHERE uuid = "${task.uuid}"',
        ['${isDonetoInt()}']);
  }

  Future<List<Task>> tasks() async {
    var test = await checkInit();

    List data = await db!.rawQuery('SELECT * FROM Tasks');

    List<Task> tasks = data
        .map((e) => Task(
            uuid: e['uuid'] as String,
            title: e['title'] as String,
            subtitle: e['subtitle'] as String,
            timeStart: DateTime.fromMillisecondsSinceEpoch(
                int.parse(e['startMs'] as String)),
            timeEnd: DateTime.fromMillisecondsSinceEpoch(
                int.parse(e['endMS'] as String)),
            isDone: e['isDone'] == 1 ? true : false))
        .toList();

    return tasks;
  }
}
