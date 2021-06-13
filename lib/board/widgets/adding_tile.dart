import 'dart:math';

import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flexible/board/models/tasks/regular_taks.dart';
import 'package:flexible/board/models/tasks/task.dart';
import 'package:flexible/board/task_editor/new_task_editor.dart';
import 'package:flexible/utils/adaptive_utils.dart';
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

  addBunchOfTasks(BuildContext context) {
    DateTime dayForAdd = BlocProvider.of<DailytasksBloc>(context).state.showDay;

    var newtask2 = RegularTask(
      uuid: null,
      isDone: false,
      title: 'Demo task ${++taskCount}',
      subtitle: 'Nice turbo day',
      // add task to showed date with current time
      timeStart: DateUtils.dateOnly(dayForAdd).add(Duration(
          hours: DateTime.now().hour, minutes: DateTime.now().minute - 25)),
      period: Duration(),
      isDonable: true, timeLock: false,
      // generate random color
      color: Color.fromRGBO(Random().nextInt(256), Random().nextInt(256),
          Random().nextInt(256), 1),
      iconId: 'presentation',
    );

    BlocProvider.of<DailytasksBloc>(context)
        .add(DailytasksAddTask(task: newtask2));

    var newtask3 = RegularTask(
      uuid: null,
      isDone: false,
      title: 'Duration task',
      subtitle: 'Happy birthday',
      // add task to showed date with current time
      timeStart: DateUtils.dateOnly(dayForAdd).add(Duration(
          hours: DateTime.now().hour, minutes: DateTime.now().minute - 20)),
      period: Duration(hours: 1),
      isDonable: true, timeLock: false,
      // generate random color
      color: Color.fromRGBO(Random().nextInt(256), Random().nextInt(256),
          Random().nextInt(256), 1),
      iconId: 'meeting',
    );

    BlocProvider.of<DailytasksBloc>(context)
        .add(DailytasksAddTask(task: newtask3));

    var newtask4 = RegularTask(
      uuid: null,
      isDone: true,
      title: 'Finished task',
      subtitle: 'Ultra bright day',
      // add task to showed date with current time
      timeStart: DateUtils.dateOnly(dayForAdd).add(Duration(
          hours: DateTime.now().hour, minutes: DateTime.now().minute - 10)),
      period: Duration(),
      isDonable: true, timeLock: false,
      // generate random color
      color: Color.fromRGBO(Random().nextInt(256), Random().nextInt(256),
          Random().nextInt(256), 1),
      iconId: 'burger',
    );

    BlocProvider.of<DailytasksBloc>(context)
        .add(DailytasksAddTask(task: newtask4));

    var newtask5 = RegularTask(
      uuid: null,
      isDone: false,
      title: 'Forwarded task',
      subtitle: 'Nice may day',
      // add task to showed date with current time
      timeStart:
          DateUtils.dateOnly(dayForAdd).add(Duration(hours: 21, minutes: 58)),
      period: Duration(),
      isDonable: true, timeLock: false,
      // generate random color
      color: Color.fromRGBO(Random().nextInt(256), Random().nextInt(256),
          Random().nextInt(256), 1),
      iconId: 'meditation',
    );

    BlocProvider.of<DailytasksBloc>(context)
        .add(DailytasksAddTask(task: newtask5));
  }

  @override
  Widget build(BuildContext context) {
    bool isLessThen350() => MediaQuery.of(context).size.width < 350;
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
                color: Color(0xff707070),
              ),
            ),
            Positioned(
              left: isLessThen350() ? 61 : 80,
              top: 37,
              child: Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                    color: Color(0xffEE7579),
                    borderRadius: BorderRadius.circular(5)),
              ),
            ),
            Positioned(
              left: isLessThen350() ? 90 : 115,
              top: 30,
              child: Text(
                'What else you have to do?',
                style: TextStyle(
                    color: Color(0xff545353),
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
                    onLongPressEnd: (v) => addBunchOfTasks(context),
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
  }
}
