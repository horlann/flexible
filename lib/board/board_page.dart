import 'dart:math';

import 'package:flexible/board/board.dart';
import 'package:flexible/board/bottom_date_picker.dart';
import 'package:flexible/board/repository/combined_repository/combined_tasks_repo.dart';
import 'package:flexible/board/repository/day_options_interface.dart';
import 'package:flexible/board/repository/sqFliteRepository/sqflite_day_options.dart';
import 'package:flexible/board/repository/tasts_repo_interface.dart';
import 'package:flexible/board/widgets/weather_bg.dart';
import 'package:flexible/utils/main_backgroung_gradient.dart';
import 'package:flexible/weather/openweather_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:jiffy/jiffy.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'models/tasks/task.dart';

class BoardPage extends StatefulWidget {
  @override
  _BoardPageState createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  bool showCalendar = false;
  FlutterLocalNotificationsPlugin? flutterLocalNotifications;

  @override
  void initState() {
    super.initState();
    var androidInit = new AndroidInitializationSettings('splash');
    var iosInit = new IOSInitializationSettings();
    var initSettings =
        new InitializationSettings(android: androidInit, iOS: iosInit);
    flutterLocalNotifications = new FlutterLocalNotificationsPlugin();
    flutterLocalNotifications!.initialize(initSettings);
    // getWeatherByLocation();
  }

  Future _showNotify() async {
    var androidDetails = new AndroidNotificationDetails(
        'Channel ID', 'Flexible Notofocation', "Tasks Notofications",
        importance: Importance.max);

    var iosdetails = new IOSNotificationDetails();

    var generaldetails =
    new NotificationDetails(android: androidDetails, iOS: iosdetails);

    final date = DateTime.now();

    tz.initializeTimeZones();
    final String currentTimeZone =
    await FlutterNativeTimezone.getLocalTimezone();
    ITasksRepo myTaskRepo =
    RepositoryProvider.of<CombinedTasksRepository>(context);

    List<Task>? sqTasks = await tasksFromPeriod(startTime(1), startTime(2));

    startNotification(sqTasks!, generaldetails, currentTimeZone);

    IDayOptionsRepo dayOptionsRepo = RepositoryProvider.of<
        SqfliteDayOptionsRepo>(
        context); //TODO проверка времни дня до времни пробуждения или после добавить позжe
    var dayStartInfo = await dayOptionsRepo
        .getDayOptionsByDate(DateTime.now().add(Duration(days: 1)));
    wakeupNotification(
        generaldetails,
        dayStartInfo,
        await tasksFromPeriod(startTime(2), startTime(3)),
        dayStartInfo.wakeUpTime, currentTimeZone);
    endtNotification(sqTasks, generaldetails, currentTimeZone);
  }

  startTime(int addDuration) {
    return Jiffy()
        .subtract(days: 1)
        .startOf(Units.DAY)
        .dateTime
        .add(Duration(days: addDuration));
  }

  Future<List<Task>?> tasksFromPeriod(DateTime start, DateTime end) async {
    ITasksRepo myTaskRepo =
    RepositoryProvider.of<CombinedTasksRepository>(context);
    List<Task> sqTasks = await myTaskRepo.tasksByPeriod(from: start, to: end);
    return sqTasks;
  }

  void startNotification(List<Task> sqTasks, var generaldetails,
      String timeZone) {
    sqTasks.forEach((element) async {
      String taskname = element.title;
      if (element.period.inMinutes <= 30) {
        int timeBeforeStartTask = (element.timeStart.minute * 0.25).floor();
        print("start" + timeBeforeStartTask.toString());
        var time = tz.TZDateTime.from(
            element.timeStart.subtract(
                Duration(minutes: timeBeforeStartTask)),
            tz.getLocation(timeZone));
        print(time.toString() + " string");

        await flutterLocalNotifications!.zonedSchedule(
            element.hashCode,
            'Be careful!👀',
            "The task $taskname will start in $timeBeforeStartTask minutes",
            time,
            generaldetails,
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
      }
      else {
        var time = tz.TZDateTime.from(
            element.timeStart.subtract(Duration(minutes: 15)),
            tz.getLocation(timeZone));
        print(time.toString() + " string");
        await flutterLocalNotifications!.zonedSchedule(
            element.hashCode,
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

  void endtNotification(List<Task> sqTasks, var generaldetails,
      String timeZone) {
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
                .subtract(Duration(
                minutes: timeBeforeTaskEnd)),
            tz.getLocation(timeZone));
        print(time.toString() + " time");
        await flutterLocalNotifications!.zonedSchedule(
            element.hashCode,
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
        await flutterLocalNotifications!.zonedSchedule(
            element.hashCode,
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

  void wakeupNotification(var generaldetails, var dayInfo, List<Task>? sqTasks,
      DateTime dateTime, String timeZone) async {
    var wakeuptime = dateTime;
    int _taskCount = sqTasks!.length;
    var time = tz.TZDateTime.from(wakeuptime, tz.getLocation(timeZone));
    await flutterLocalNotifications!.zonedSchedule(
        Random().nextInt(9999),
        'Wake up!',
        "tasks are waiting for you!You have $_taskCount tasks for today",
        time,
        generaldetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
//
  }

  @override
  Widget build(BuildContext context) {
    _showNotify();
    // Lock portreit mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      backgroundColor: Color(0xffE9E9E9),
      body: SizedBox.expand(
          child: Container(
            decoration: BoxDecoration(
              gradient: mainBackgroundGradient,

              // image: DecorationImage(
              //     image: AssetImage('src/testbg.jpg'),
              //     fit: BoxFit.cover,
              //     alignment: Alignment.center),
            ),
            child: Stack(
              children: [
                Container(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    child: WeatherBg()),
                SafeArea(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Expanded(
                        child: Board(),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      BottomDatePicker(),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

Color colorByType(DayLight type) {
  if (type == DayLight.light) {
    return Color(0xff90e0ef).withOpacity(0.5);
  } else if (type == DayLight.medium) {
    return Color(0xff0096c7).withOpacity(0.50);
  } else {
    return Color(0xff023e8a);
  }
}
