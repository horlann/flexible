import 'dart:ui';
import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flexible/board/widgets/empty_task_tile.dart';
import 'package:flexible/board/models/task.dart';
import 'package:flexible/board/widgets/task_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism/glassmorphism.dart';

class Board extends StatefulWidget {
  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  List<Widget> tasks = [];
  // Uses for count new tasks
  int taskCount = 0;

  @override
  void initState() {
    super.initState();
  }

  // Add new task to list and update ui
  void addNewTask(BuildContext context) {
    DateTime dayForAdd = BlocProvider.of<DailytasksBloc>(context).state.showDay;
    var newtask = Task(
      uuid: null,
      isDone: false,
      title: 'TheTask ${++taskCount}',
      subtitle: 'Nice ${taskCount}day',
      timeStart: dayForAdd,
      period: Duration(minutes: 5),
      isDonable: true,
    );

    BlocProvider.of<DailytasksBloc>(context)
        .add(DailytasksAddTask(task: newtask));
  }

  @override
  Widget build(BuildContext context) {
    return buildWrapperwithShiftedBackground(
        child: buildScrollViewWithLine(children: [...tasks]));
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
  SingleChildScrollView buildScrollViewWithLine(
      {required List<Widget> children}) {
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
          // its list of tasks
          // List load from state
          // and insert adding section
          Container(
            child: BlocBuilder<DailytasksBloc, DailytasksState>(
              builder: (context, state) {
                if (state is DailytasksCommon) {
                  List<Widget> tasks = state.tasks.map((e) {
                    // ignore: unnecessary_cast
                    return TaskTile(
                      task: e,
                    ) as Widget;
                  }).toList();
                  // Insert adding widget before last task
                  // Last task is need be a goodnight by programm logic
                  tasks.insert(tasks.length - 1, buildAddingSection());

                  return Column(children: tasks);
                }
                // TODO loading
                return Column();
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
