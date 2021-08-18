import 'package:flexible/board/board.dart';
import 'package:flexible/board/bottom_date_picker.dart';
import 'package:flexible/board/repository/combined_repository/combined_tasks_repo.dart';
import 'package:flexible/board/repository/sqFliteRepository/sqflite_day_options.dart';
import 'package:flexible/board/widgets/weather_bg.dart';
import 'package:flexible/notifications/tasks_notifications_service.dart';
import 'package:flexible/weather/openweather_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BoardPage extends StatefulWidget {
  @override
  _BoardPageState createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  var controller = PageController();
  int? currentPageValue;

  bool showCalendar = false;
  late TaskNotificationService taskNotificationService;

  @override
  void initState() {
    super.initState();
    // Load notification service
    taskNotificationService = TaskNotificationService(
        myTaskRepo: RepositoryProvider.of<CombinedTasksRepository>(context),
        dayOptionsRepo: RepositoryProvider.of<SqfliteDayOptionsRepo>(context));
    // Schedule task notifications
    taskNotificationService.startService();
    currentPageValue = 0;
    controller.addListener(() {
      setState(() {
        currentPageValue = controller.page!.toInt();
        print((currentPageValue).toString());
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    taskNotificationService.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Lock portreit mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox.expand(
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
                    child: PageView.builder(
                  itemBuilder: (context, pos) {
                    return Board();
                  },
                  controller: controller,
                  physics: NeverScrollableScrollPhysics(),
                  onPageChanged: (pos) {},
                )),
                SizedBox(
                      height: 16,
                    ),
                    BottomDatePicker(
                      callback: (date) {
                        print(date);
                      },
                      currentPos: currentPageValue ?? 1,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ],
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
