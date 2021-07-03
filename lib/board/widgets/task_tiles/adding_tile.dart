import 'dart:math';

import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flexible/board/models/tasks/regular_taks.dart';
import 'package:flexible/board/task_editor/new_task_editor.dart';
import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flexible/weather/bloc/weather_bloc.dart';
import 'package:flexible/weather/openweather_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddingTile extends StatefulWidget {
  @override
  _AddingTileState createState() => _AddingTileState();
}

class _AddingTileState extends State<AddingTile> {
  int taskCount = 0;

  // Open new task page
  addNewTask(BuildContext context) {
    Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => NewTaskEditor(),
        ));
  }

  insertSuperTasks() {
    BlocProvider.of<DailytasksBloc>(context).add(DailytasksAskForInsert());
  }

  @override
  Widget build(BuildContext context) {
    bool isLessThen350() => MediaQuery.of(context).size.width < 350;
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        return Column(
          children: [
            Stack(
              children: [
                Positioned(
                  left: isLessThen350() ? 64 : 82,
                  top: 40,
                  child: Container(
                    height: 3,
                    width: isLessThen350() ? 15 : 25,
                    color: state.daylight == DayLight.dark
                        ? Colors.white
                        : Color(0xff545353),
                  ),
                ),
                Positioned(
                  left: isLessThen350() ? 61 : 80,
                  top: 37,
                  child: Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                        color: state.daylight == DayLight.dark
                            ? Colors.white
                            : Color(0xff545353),
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
                Positioned(
                  left: isLessThen350() ? 90 : 115,
                  top: 30,
                  child: Text(
                    'What else you have to do?',
                    style: TextStyle(
                        color: state.daylight == DayLight.dark
                            ? Colors.white
                            : Color(0xff545353),
                        fontSize: 14 * byWithScale(context)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 50, left: 32),
                  clipBehavior: Clip.none,
                  height: 100,
                  width: double.maxFinite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () => addNewTask(context),
                        onLongPressEnd: (v) => insertSuperTasks(),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0xffEE7579).withOpacity(0.75),
                                  blurRadius: 20,
                                  offset: Offset(-10, 10))
                            ],
                          ),
                          child: Image.asset(
                            'src/icons/plus_btn.png',
                            scale: 1.4,
                            width: 46 * byWithScale(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
