import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexible/board/models/day_options.dart';
import 'package:flexible/board/repository/day_options_interface.dart';
import 'package:flutter/material.dart';

class FireBaseDaysOptionsRepo extends IDayOptionsRepo {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth fireAuth = FirebaseAuth.instance;

  CollectionReference taskCollection() {
    if (fireAuth.currentUser != null) {
      return firestore
          .collection('users')
          .doc(fireAuth.currentUser!.uid)
          .collection('daysOptions');
    }
    throw Exception('Not authorized');
  }

  @override
  Future<DayOptions> getDayOptionsByDate(DateTime date) async {
    var day = await taskCollection()
        .doc(DateUtils.dateOnly(date).millisecondsSinceEpoch.toString())
        .get();

    if (day.exists) {
      return DayOptions.fromMap(day.data() as Map<String, dynamic>);
    } else {
      await addDayOptions(DayOptions(
          day: DateUtils.dateOnly(date),
          wakeUpTime: DateUtils.dateOnly(date).add(Duration(hours: 8)),
          goToSleepTime: DateUtils.dateOnly(date).add(Duration(hours: 23))));
      return await getDayOptionsByDate(date);
    }
  }

  @override
  Future addDayOptions(DayOptions dayOptions) async {
    await taskCollection()
        .doc(dayOptions.day.millisecondsSinceEpoch.toString())
        .set(dayOptions.toMap());
  }

  @override
  Future updateDayOptions(DayOptions dayOptions) async {
    await taskCollection()
        .doc(dayOptions.day.millisecondsSinceEpoch.toString())
        .set(dayOptions.toMap());
  }

  @override
  Future deleteDayOptions(DayOptions dayOptions) async {
    // TODO: implement deleteDayOptions
    throw UnimplementedError();
  }
}
