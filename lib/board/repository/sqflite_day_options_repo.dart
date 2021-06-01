import 'package:flexible/board/models/day_options.dart';
import 'package:flexible/board/repository/day_options_interface.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteDayOptionsRepo extends IDayOptionsRepo {
  Database? db;

  // Init new db and create table
  Future _init() async {
    db = await openDatabase('dayOpt.db', version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE DayOptions (day INTEGER PRIMARY KEY, wakeUpTime INTEGER, goToSleepTime INTEGER)');
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
  Future addDayOptions(DayOptions dayOptions) async {
    await (await getDb).insert('DayOptions', dayOptions.toMap());
  }

  @override
  Future updateDayOptions(DayOptions dayOptions) async {
    await (await getDb).update('DayOptions', dayOptions.toMap(),
        where: 'day = ?', whereArgs: [dayOptions.day]);
  }

  @override
  Future<DayOptions> getDayOptionsByDate(DateTime date) async {
    try {
      List data = await (await getDb).rawQuery(
          'SELECT * FROM DayOptions WHERE day = "${DateUtils.dateOnly(date).millisecondsSinceEpoch}"');

      // If exist return result
      // If not exist add new options recursive get again
      if (data.isNotEmpty) {
        return DayOptions.fromMap(data.first);
      } else {
        await addDayOptions(DayOptions(
            day: DateUtils.dateOnly(date),
            wakeUpTime: DateUtils.dateOnly(date).add(Duration(hours: 8)),
            goToSleepTime: DateUtils.dateOnly(date).add(Duration(hours: 23))));
        return await getDayOptionsByDate(date);
      }
    } catch (e) {
      throw Exception('Load from sqflite failed' + e.toString());
    }
  }

  @override
  Future deleteDayOptions(DayOptions dayOptions) {
    // TODO: implement deleteDayOptions
    throw UnimplementedError();
  }
}
