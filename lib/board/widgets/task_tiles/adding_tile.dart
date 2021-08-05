import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flexible/board/task_editor/new_task_editor.dart';
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
    return Column(
      children: [
        Stack(
          children: [
//                Positioned(
//                  left: isLessThen350() ? 64 : 82,
//                  top: 40,
//                  child: Container(
//                    height: 3,
//                    width: isLessThen350() ? 15 : 25,
//                    color: state.daylight == DayLight.dark
//                        ? Colors.white
//                        : Color(0xff545353),
//                  ),
//                ),
//                Positioned(
//                  left: isLessThen350() ? 61 : 80,
//                  top: 37,
//                  child: Container(
//                    height: 10,
//                    width: 10,
//                    decoration: BoxDecoration(
//                        color: state.daylight == DayLight.dark
//                            ? Colors.white
//                            //: Color(0xff545353),
//                            : Colors.white,
//                        borderRadius: BorderRadius.circular(5)),
//                  ),
//                ),
//                Positioned(
//                  left: isLessThen350() ? 90 : 115,
//                  top: 30,
//                  child: Text(
//                    'What else you have to do?',
//                    style: TextStyle(
//                        color: state.daylight == DayLight.dark
//                            ? Colors.white
//                            //: Color(0xff545353),
//                            : Colors.white,
//                        fontSize: 14 * byWithScale(context)),
//                  ),
//                ),
            Container(
              // color: Colors.red,
              margin: EdgeInsets.only(top: 10, left: 32),
              clipBehavior: Clip.none,
              height: 60,
              width: double.maxFinite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => addNewTask(context),
                    //onLongPressEnd: (v) => insertSuperTasks(),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Color(0xffE24F4F),
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset('src/icons/plus.png',
                          width: 60,
                          scale: 0.7,
                          color: Colors.white.withOpacity(0.8),
                          height: 80),
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
