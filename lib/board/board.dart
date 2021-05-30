import 'dart:math';
import 'dart:ui';
import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flexible/board/widgets/empty_task_tile.dart';
import 'package:flexible/board/models/task.dart';
import 'package:flexible/board/widgets/periodic_task_tile..dart';
import 'package:flexible/board/widgets/task_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism/glassmorphism.dart';

class Board extends StatefulWidget {
  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  // Uses for count new tasks
  int taskCount = 0;

  @override
  void initState() {
    super.initState();
  }

  // Add new task to list and update ui
  addNewTask(BuildContext context) {
    DateTime dayForAdd = BlocProvider.of<DailytasksBloc>(context).state.showDay;
    var newtask = Task(
      uuid: null,
      isDone: false,
      title: 'TheTask ${++taskCount}',
      subtitle: 'Nice ${taskCount}day',
      // add task to showed date with current time
      timeStart: DateUtils.dateOnly(dayForAdd).add(Duration(
          hours: DateTime.now().hour, minutes: DateTime.now().minute - 5)),
      period: Duration(),
      isDonable: true,
      // generate random color
      color: Color.fromRGBO(Random().nextInt(256), Random().nextInt(256),
          Random().nextInt(256), 1),
    );

    BlocProvider.of<DailytasksBloc>(context)
        .add(DailytasksAddTask(task: newtask));
  }

  addBunchOfTasks(BuildContext context) {
    DateTime dayForAdd = BlocProvider.of<DailytasksBloc>(context).state.showDay;

    var newtask2 = Task(
      uuid: null,
      isDone: false,
      title: 'Demo task ${++taskCount}',
      subtitle: 'Nice turbo day',
      // add task to showed date with current time
      timeStart: DateUtils.dateOnly(dayForAdd).add(Duration(
          hours: DateTime.now().hour, minutes: DateTime.now().minute - 25)),
      period: Duration(),
      isDonable: true,
      // generate random color
      color: Color.fromRGBO(Random().nextInt(256), Random().nextInt(256),
          Random().nextInt(256), 1),
    );

    BlocProvider.of<DailytasksBloc>(context)
        .add(DailytasksAddTask(task: newtask2));

    var newtask3 = Task(
      uuid: null,
      isDone: false,
      title: 'Duration task',
      subtitle: 'Happy birthday',
      // add task to showed date with current time
      timeStart: DateUtils.dateOnly(dayForAdd).add(Duration(
          hours: DateTime.now().hour, minutes: DateTime.now().minute - 20)),
      period: Duration(hours: 1),
      isDonable: true,
      // generate random color
      color: Color.fromRGBO(Random().nextInt(256), Random().nextInt(256),
          Random().nextInt(256), 1),
    );

    BlocProvider.of<DailytasksBloc>(context)
        .add(DailytasksAddTask(task: newtask3));

    var newtask4 = Task(
      uuid: null,
      isDone: true,
      title: 'Finished task',
      subtitle: 'Ultra bright day',
      // add task to showed date with current time
      timeStart: DateUtils.dateOnly(dayForAdd).add(Duration(
          hours: DateTime.now().hour, minutes: DateTime.now().minute - 10)),
      period: Duration(),
      isDonable: true,
      // generate random color
      color: Color.fromRGBO(Random().nextInt(256), Random().nextInt(256),
          Random().nextInt(256), 1),
    );

    BlocProvider.of<DailytasksBloc>(context)
        .add(DailytasksAddTask(task: newtask4));

    var newtask5 = Task(
      uuid: null,
      isDone: false,
      title: 'Forwarded task',
      subtitle: 'Nice may day',
      // add task to showed date with current time
      timeStart:
          DateUtils.dateOnly(dayForAdd).add(Duration(hours: 21, minutes: 58)),
      period: Duration(),
      isDonable: true,
      // generate random color
      color: Color.fromRGBO(Random().nextInt(256), Random().nextInt(256),
          Random().nextInt(256), 1),
    );

    BlocProvider.of<DailytasksBloc>(context)
        .add(DailytasksAddTask(task: newtask5));
    ;
  }

  @override
  Widget build(BuildContext context) {
    return buildWrapperwithShiftedBackground(child: buildScrollViewWithLine());
  }

  // Glassmorphic background shifted to right
  Padding buildWrapperwithShiftedBackground({required Widget child}) {
    return Padding(
        padding: const EdgeInsets.only(left: 8, right: 16),
        child: Container(
            color: Colors.red.withOpacity(0.0),
            child: Stack(
              children: [
                GlassmorphicContainer(
                  margin: EdgeInsets.only(left: 44),
                  width: double.maxFinite,
                  height: double.maxFinite,
                  borderRadius: 30,
                  blur: 5,
                  border: 2,
                  linearGradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Color(0xFFffffff).withOpacity(0.6),
                        Color(0xfff4f3f3).withOpacity(0.2),
                        Color(0xFFffffff).withOpacity(0.6),
                      ],
                      stops: [
                        0,
                        0.2,
                        1,
                      ]),
                  borderGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFffffff).withOpacity(0.15),
                      Color(0xFFffffff).withOpacity(0.15),
                      Color(0xFFFFFFFF).withOpacity(0.15),
                    ],
                  ),
                ),

                // Children here
                child,
              ],
            )));
  }

  // Provide scroll and draw red line beetween tiles
  // Uses only with special task tiles for correct line positioning
  SingleChildScrollView buildScrollViewWithLine() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Stack(
        children: [
          // THis is line under widgets
          // Its size grow with list size
          Positioned.fill(
              child: Padding(
            padding: const EdgeInsets.only(left: 82, top: 30, bottom: 90),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Container(width: 3, color: Color(0xff707070))),
          )),
          // this list of tasks
          // List load from state
          // and insert adding section
          Container(
            child: BlocBuilder<DailytasksBloc, DailytasksState>(
              builder: (context, state) {
                List<Widget> getList() {
                  if (state is DailytasksCommon) {
                    List<Widget> tasks = state.tasks.map((e) {
                      if (e.period.inMilliseconds == 0) {
                        return TaskTile(task: e) as Widget;
                      } else {
                        return PeriodicTaskTile(task: e) as Widget;
                      }
                    }).toList();
                    // Insert adding widget before last task
                    // Last task is need be a goodnight by programm logic
                    tasks.insert(tasks.length - 1, buildAddingSection());
                    return tasks;
                  }
                  return [];
                }

                return Column(
                  children: getList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Show empty tile with text and button underneeth
  Widget buildAddingSection() {
    return Column(
      children: [
        Stack(
          children: [
            Positioned(
              left: 82,
              top: 40,
              child: Container(
                height: 3,
                width: 30,
                color: Color(0xff707070),
              ),
            ),
            Positioned(
              left: 80,
              top: 38,
              child: Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                    color: Color(0xffEE7579),
                    borderRadius: BorderRadius.circular(4)),
              ),
            ),
            //
            // line
            //
            Positioned(
              left: 115,
              top: 30,
              child: Text(
                'What else you have to do?',
                style: TextStyle(color: Color(0xff545353), fontSize: 18),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 50, left: 32),
              clipBehavior: Clip.none,
              height: 120,
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
