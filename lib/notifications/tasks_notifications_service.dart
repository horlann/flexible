import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:jiffy/jiffy.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:flexible/board/models/tasks/task.dart';
import 'package:flexible/board/repository/day_options_interface.dart';
import 'package:flexible/board/repository/tasts_repo_interface.dart';

class TaskNotificationService {
  ITasksRepo myTaskRepo;
  IDayOptionsRepo dayOptionsRepo;
  FlutterLocalNotificationsPlugin flutterLocalNotifications =
      FlutterLocalNotificationsPlugin();
  TaskNotificationService({
    required this.myTaskRepo,
    required this.dayOptionsRepo,
  }) {
    var androidInit = new AndroidInitializationSettings('splash');
    var iosInit = new IOSInitializationSettings();
    var initSettings =
        new InitializationSettings(android: androidInit, iOS: iosInit);
    this.flutterLocalNotifications.initialize(initSettings);
  }

  Future showNotify() async {
    var androidDetails = new AndroidNotificationDetails(
        'Channel ID', 'Flexible Notofocation', "Tasks Notofications",
        importance: Importance.max);

    var iosdetails = new IOSNotificationDetails();

    var generaldetails =
        new NotificationDetails(android: androidDetails, iOS: iosdetails);

    tz.initializeTimeZones();
    final String currentTimeZone =
        await FlutterNativeTimezone.getLocalTimezone();

    List<Task> sqTasks = await tasksFromPeriod(startTime(1), startTime(2));

    startNotification(sqTasks, generaldetails, currentTimeZone);

    var dayStartInfo = await dayOptionsRepo
        .getDayOptionsByDate(DateTime.now().add(Duration(days: 1)));

    wakeupNotification(
        generaldetails,
        dayStartInfo,
        await tasksFromPeriod(startTime(1), startTime(2)),
        dayStartInfo.wakeUpTime,
        currentTimeZone);

    endtNotification(sqTasks, generaldetails, currentTimeZone);
  }

  startTime(int addDuration) {
    return Jiffy()
        .subtract(days: 1)
        .startOf(Units.DAY)
        .dateTime
        .add(Duration(days: addDuration));
  }

  Future<List<Task>> tasksFromPeriod(DateTime start, DateTime end) async {
    List<Task> sqTasks = await myTaskRepo.tasksByPeriod(from: start, to: end);
    return sqTasks;
  }

  void startNotification(
      List<Task> sqTasks, var generaldetails, String timeZone) {
    sqTasks.forEach((element) async {
      String taskname = element.title;
      print(taskname);

      if (element.period.inMinutes <= 30) {
        int timeBeforeStartTask = (element.timeStart.minute * 0.25).floor();
        print("start" + timeBeforeStartTask.toString());
        var time = tz.TZDateTime.from(
            element.timeStart.subtract(Duration(minutes: timeBeforeStartTask)),
            tz.getLocation(timeZone));
        print(time.toString() + " string");
        await flutterLocalNotifications.zonedSchedule(
            Random().nextInt(9999),
            'Be careful!👀',
            "The task $taskname will start in $timeBeforeStartTask minutes",
            time,
            generaldetails,
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime);
      } else {
        var time = tz.TZDateTime.from(
            element.timeStart.subtract(Duration(minutes: 15)),
            tz.getLocation(timeZone));
        print(time.toString() + " stringTIME");
        await flutterLocalNotifications.zonedSchedule(
            Random().nextInt(9999),
            'Be careful!👀',
            "The task $taskname will start in 15 minutes",
            time,
            generaldetails,
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime);
      }
    });
  }

  void endtNotification(
      List<Task> sqTasks, var generaldetails, String timeZone) {
    sqTasks.forEach((element) async {
      String taskname = element.title;

      if (element.period.inMinutes <= 30) {
        int timeBeforeTaskEnd = (element.period.inMinutes * 0.25).floor();
        print(timeBeforeTaskEnd.toString() + "min");
        var time = tz.TZDateTime.from(
            element.timeStart
                .add(Duration(
                    days: element.period.inDays,
                    hours: element.period.inHours,
                    minutes: element.period.inMinutes))
                .subtract(Duration(minutes: timeBeforeTaskEnd)),
            tz.getLocation(timeZone));
        print(time.toString() + " time");
        await flutterLocalNotifications.zonedSchedule(
            Random().nextInt(9999),
            'Be careful!👀',
            "The task $taskname will end in $timeBeforeTaskEnd minutes",
            time,
            generaldetails,
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime);
      } else {
        var time = tz.TZDateTime.from(
            (element.timeStart
                .add(Duration(
                    days: element.period.inDays,
                    hours: element.period.inHours,
                    minutes: element.period.inMinutes))
                .subtract(Duration(minutes: 10))),
            tz.getLocation(timeZone));
        await flutterLocalNotifications.zonedSchedule(
            Random().nextInt(9999),
            'Be careful!👀',
            "The task $taskname will end in 10 minutes",
            time,
            generaldetails,
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime);
      }
    });
  }

  void wakeupNotification(var generaldetails, var dayInfo, List<Task> sqTasks,
      DateTime dateTime, String timeZone) async {
    var wakeuptime = dateTime;
    int _taskCount = sqTasks.length;
    print(_taskCount.toString() + " taskcount");
    var time = tz.TZDateTime.from(wakeuptime, tz.getLocation(timeZone));
    await flutterLocalNotifications.zonedSchedule(
        Random().nextInt(9999),
        'Wake up!',
        "tasks are waiting for you!You have $_taskCount tasks for today",
        time,
        generaldetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}
