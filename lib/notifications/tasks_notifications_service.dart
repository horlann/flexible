import 'dart:async';

import 'package:flexible/board/models/day_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flexible/board/models/tasks/task.dart';
import 'package:flexible/board/repository/day_options_interface.dart';
import 'package:flexible/board/repository/tasts_repo_interface.dart';

class TaskNotificationService {
  TaskNotificationService({
    required this.myTaskRepo,
    required this.dayOptionsRepo,
  }) {
    var androidInit = new AndroidInitializationSettings('splash');
    var iosInit = new IOSInitializationSettings();
    var initSettings =
        new InitializationSettings(android: androidInit, iOS: iosInit);
    tz.initializeTimeZones();
    this.flutterLocalNotifications.initialize(initSettings);
  }

  late ITasksRepo myTaskRepo;
  late IDayOptionsRepo dayOptionsRepo;
  late StreamSubscription sub;

  FlutterLocalNotificationsPlugin flutterLocalNotifications =
      FlutterLocalNotificationsPlugin();

  get currentTimeZone async => await FlutterNativeTimezone.getLocalTimezone();

  DateTime get startTime {
    return DateUtils.dateOnly(DateTime.now());
  }

  Future<List<Task>> tasksFromPeriod(DateTime start, DateTime end) async {
    List<Task> sqTasks = await myTaskRepo.tasksByPeriod(from: start, to: end);
    return sqTasks;
  }

  NotificationDetails generaldetails = NotificationDetails(
      android: AndroidNotificationDetails(
          'Channel ID', 'Flexible Notofocation', "Tasks Notofications",
          importance: Importance.max),
      iOS: IOSNotificationDetails());

  Future startService() async {
    doSchedule() async {
      await flutterLocalNotifications.cancelAll();

      List<Task> todayTasks =
          await tasksFromPeriod(startTime, startTime.add(Duration(days: 1)));

      List<Task> tomorrowTasks = await tasksFromPeriod(
          startTime.add(Duration(days: 1)), startTime.add(Duration(days: 2)));

      await scheduleTaskNotifications(tasks: todayTasks);

      await wakeupNotificationSchedule(sqTasks: tomorrowTasks);
    }

    // Listen to db update
    sub = myTaskRepo.onChanges!.listen((event) async {
      print('Reschedule tasks');
      doSchedule();
    });

    doSchedule();
  }

  dispose() {
    sub.cancel();
  }

  Future wakeupNotificationSchedule({required List<Task> sqTasks}) async {
    DayOptions dop = await dayOptionsRepo
        .getDayOptionsByDate(startTime.add(Duration(days: 1)));

    var time = tz.TZDateTime.from(
        dop.wakeUpTime, tz.getLocation(await currentTimeZone));

    // If have tasks
    if (sqTasks.length > 0) {
      await flutterLocalNotifications.zonedSchedule(
          1337,
          'Wake up!',
          "tasks are waiting for you!You have ${sqTasks.length} tasks for today",
          time,
          generaldetails,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);

      print(
          'Added morning notification in ${dop.wakeUpTime}  tasks ${sqTasks.length}');
    }
  }

  Future scheduleTaskNotifications({required List<Task> tasks}) async {
    DateTime currentTime = DateTime.now();
    tasks.forEach((task) async {
      // If task undone
      if (task.isDone) return;

      // Start notifications
      // Only for future tasks
      if (task.timeStart.difference(currentTime).inMinutes > 15) {
        // Notification id must be same for replace old version if task changes
        // Wee use part of uuid hashcode + 1 for task start type
        int notId =
            int.parse('${task.uuid.hashCode.toString().substring(0, 8)}1');

        var time = tz.TZDateTime.from(
            task.timeStart.subtract(Duration(minutes: 15)),
            tz.getLocation(await currentTimeZone));

        flutterLocalNotifications.zonedSchedule(
            notId,
            'Be careful!👀',
            "The task ${task.title} will start in 15 minutes",
            time,
            generaldetails,
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime);
        print(
            'Added start task notification on ${task.timeStart.subtract(Duration(minutes: 15))}');
      }

      // End notifications
      // Only for future tasks
      if (task.timeStart.add(task.period).difference(currentTime).inMinutes >
          15) {
        if (task.period.inMinutes > 30) {
          // for long task calc 25% of period
          // Notification id must be same for replace old version if task changes
          // Wee use part of uuid hashcode + 2 for task end type
          int notId =
              int.parse('${task.uuid.hashCode.toString().substring(0, 8)}2');

          var time = tz.TZDateTime.from(
              task.timeStart.add(Duration(
                  minutes: task.period.inMinutes -
                      (task.period.inMinutes * 0.25).floor())),
              tz.getLocation(await currentTimeZone));

          flutterLocalNotifications.zonedSchedule(
              notId,
              'Be careful!👀',
              "The task ${task.title}  will end in ${(task.period.inMinutes * 0.25).floor()} minutes",
              time,
              generaldetails,
              androidAllowWhileIdle: true,
              uiLocalNotificationDateInterpretation:
                  UILocalNotificationDateInterpretation.absoluteTime);
          print(
              'Added end task notification on ${task.timeStart.add(Duration(minutes: task.period.inMinutes - (task.period.inMinutes * 0.25).floor()))}');
        } else if (task.period.inMinutes > 10) {
          // for shors task notify in 10 min
          // Notification id must be same for replace old version if task changes
          // Wee use part of uuid hashcode + 2 for task end type
          int notId =
              int.parse('${task.uuid.hashCode.toString().substring(0, 8)}2');

          var time = tz.TZDateTime.from(
              task.timeStart.add(task.period).subtract(Duration(minutes: 10)),
              tz.getLocation(await currentTimeZone));

          flutterLocalNotifications.zonedSchedule(
              notId,
              'Be careful!👀',
              "The task ${task.title} will end in 10 minutes",
              time,
              generaldetails,
              androidAllowWhileIdle: true,
              uiLocalNotificationDateInterpretation:
                  UILocalNotificationDateInterpretation.absoluteTime);
          print(
              'Added end task notification on ${task.timeStart.add(task.period).subtract(Duration(minutes: 10))}');
        }
      }
    });
  }
}
