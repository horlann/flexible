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
        timeEnd: DateTime.now().add(Duration(minutes: 4)));

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
                // imageFilter(
                //   hue: 0.1,
                //   brightness: 3.0,
                //   saturation: 0.0,
                //   child: GlassmorphicContainer(
                //     margin: EdgeInsets.only(left: 40),
                //     width: double.maxFinite,
                //     height: double.maxFinite,
                //     borderRadius: 30,
                //     blur: 20,
                //     border: 2,
                //     linearGradient: LinearGradient(
                //         begin: Alignment.topRight,
                //         end: Alignment.bottomLeft,
                //         colors: [
                //           Color(0xFFffffff).withOpacity(0.4),
                //           Color(0xA7A2A2).withOpacity(0.18),
                //           Color(0xffDBD0D0).withOpacity(0.49),
                //         ],
                //         stops: [
                //           0,
                //           0.2,
                //           1,
                //         ]),
                //     borderGradient: LinearGradient(
                //       begin: Alignment.topLeft,
                //       end: Alignment.bottomRight,
                //       colors: [
                //         Color(0xFFffffff).withOpacity(0.15),
                //         Color(0xFFffffff).withOpacity(0.15),
                //         Color(0xFFFFFFFF).withOpacity(0.15),
                //       ],
                //     ),
                //   ),
                // ),

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

                // GlassContainer.frostedGlass(
                //     borderRadius: BorderRadius.circular(30),
                //     gradient: LinearGradient(
                //         begin: Alignment.topRight,
                //         end: Alignment.bottomLeft,
                //         colors: [
                //           Color(0xFFffffff).withOpacity(0.6),
                //           Color(0xfff4f3f3).withOpacity(0.4),
                //           Color(0xfff4f1f1).withOpacity(0.6),
                //         ],
                //         stops: [
                //           0,
                //           0.2,
                //           0.8,
                //         ]),
                //     margin: EdgeInsets.only(left: 40),
                //     borderColor: Colors.white.withOpacity(0.15),
                //     height: double.infinity,
                //     width: double.maxFinite),

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
          Positioned.fill(
              child: Padding(
            padding: const EdgeInsets.only(left: 82, top: 20, bottom: 140),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Container(width: 3, color: Color(0xff707070))),
          )),
          Container(
            child: Column(
              children: [
                // ...children,

                BlocBuilder<DailytasksBloc, DailytasksState>(
                  builder: (context, state) {
                    print(state);
                    if (state is DailytasksCommon) {
                      return Column(
                          children: state.tasks
                              .map((e) => TaskTile(
                                    task: e,
                                  ))
                              .toList());
                    }
                    return Container();
                  },
                ),
                buildAddingSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Show empty tile with text and button underneeth
  Widget buildAddingSection() {
    return BlocBuilder<DailytasksBloc, DailytasksState>(
      builder: (context, state) {
        Widget showEmpty() {
          if (state is DailytasksCommon) {
            if (state.tasks.isEmpty) {
              return EmptyTaskTile();
            }
          }
          return SizedBox();
        }

        return Column(
          children: [
            showEmpty(),
            Stack(
              children: [
                //
                // Red line
                //
                Positioned(
                  left: 82,
                  child: Container(
                    height: 40,
                    width: 3,
                    color: Color(0xff707070),
                  ),
                ),
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
      },
    );
  }
}
