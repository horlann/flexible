import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flexible/board/board.dart';
import 'package:flexible/board/bottom_date_picker.dart';
import 'package:flexible/board/repository/sqflire_tasks_repo.dart';
import 'package:flexible/board/week_calendar.dart';
import 'package:flexible/board/widgets/mini_red_button.dart';
import 'package:flexible/utils/main_backgroung_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class BoardPage extends StatefulWidget {
  @override
  _BoardPageState createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  bool showCalendar = false;

  @override
  Widget build(BuildContext context) {
    // Lock portreit mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      backgroundColor: Color(0xffE9E9E9),
      body: SafeArea(
        child: SizedBox.expand(
            child: Container(
          decoration: BoxDecoration(
            gradient: mainBackgroundGradient,
            // image: DecorationImage(
            //   image: AssetImage('src/testbg.jpg'),
            //   fit: BoxFit.cover,
            // ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 16,
              ),
              Expanded(child: Board()),
              SizedBox(
                height: 16,
              ),
              BottomDatePicker(),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        )),
      ),
    );
  }
}
