import 'dart:ui';
import 'package:flexible/board/empty_task_tile.dart';
import 'package:flexible/board/single_time_task_tile.dart';
import 'package:flexible/board/task_tile.dart';
import 'package:flexible/utils/image_filter.dart';
import 'package:flutter/material.dart';
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
    addNewTask();
  }

  // Add new task to list and update ui
  void addNewTask() {
    setState(() {
      tasks.add(
        SingleTimeTaskTile(
          name: 'The Task ${++taskCount}',
          timeStart: DateTime.now(),
          timeEnd: DateTime.now().add(Duration(minutes: 4)),
        ),
      );
    });
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
                imageFilter(
                  hue: 0.1,
                  brightness: 0.9,
                  saturation: 0.0,
                  child: GlassmorphicContainer(
                    margin: EdgeInsets.only(left: 40),
                    width: double.maxFinite,
                    height: double.maxFinite,
                    borderRadius: 30,
                    blur: 20,
                    border: 2,
                    linearGradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color(0xFFffffff).withOpacity(0.4),
                          Color(0xA7A2A2).withOpacity(0.18),
                          Color(0xffDBD0D0).withOpacity(0.49),
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
      child: Stack(
        children: [
          Positioned.fill(
              child: Padding(
            padding: const EdgeInsets.only(left: 82, top: 20, bottom: 120),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Container(width: 3, color: Color(0xffEE7579))),
          )),
          Container(
            child: Column(
              children: [
                ...children,
                // TaskTile(),
                // TaskTile(),
                // TaskTile(),
                // TaskTile(),
                buildAddingSection()
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Show empty tile with text and button underneeth
  Widget buildAddingSection() {
    return GestureDetector(
      onTap: () => addNewTask(),
      child: Column(
        children: [
          EmptyTaskTile(),
          Stack(
            children: [
              //
              // Red line
              //
              Positioned(
                left: 82,
                child: Container(
                  height: 60,
                  width: 3,
                  color: Color(0xffEE7579),
                ),
              ),
              Positioned(
                left: 82,
                top: 60,
                child: Container(
                  height: 3,
                  width: 30,
                  color: Color(0xffEE7579),
                ),
              ),
              Positioned(
                left: 80,
                top: 58,
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
                top: 52,
                child: Text(
                  'What else you have to do?',
                  style: TextStyle(color: Color(0xff545353), fontSize: 16),
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
                      height: 50,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xff707070).withOpacity(0.5),
                              blurRadius: 10)
                        ],
                      ),
                      child: Image.asset(
                        'src/icons/plus_btn.png',
                        scale: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
