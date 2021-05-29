import 'dart:async';

import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flexible/board/models/task.dart';
import 'package:flexible/board/task_editor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PeriodicTaskTile extends StatefulWidget {
  final Task task;
  PeriodicTaskTile({required this.task});
  @override
  _PeriodicTaskTileState createState() => _PeriodicTaskTileState();
}

class _PeriodicTaskTileState extends State<PeriodicTaskTile> {
  // DateTime currentTime = DateTime.now();
  late bool completed;
  bool showSubButtons = false;

  @override
  void initState() {
    super.initState();
    completed = widget.task.isDone;
    updateUi();
  }

  // Start autoupdate cycle
  // Uses for correct time showing
  // Auto close if widget disposed
  updateUi() {
    if (this.mounted) {
      setState(() {});
      Timer(Duration(seconds: 10), () => updateUi());
    }
  }

  onCheckClicked(BuildContext context) {
    setState(() {
      completed = !completed;
    });
    BlocProvider.of<DailytasksBloc>(context).add(
        DailytasksUpdateTask(task: widget.task.copyWith(isDone: completed)));
  }

  onEditClicked(BuildContext context) {
    Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => TaskEditor(task: widget.task),
            ))
        .then((value) =>
            BlocProvider.of<DailytasksBloc>(context).add(DailytasksUpdate()));
  }

  onDeleteClicked(BuildContext context) {
    BlocProvider.of<DailytasksBloc>(context)
        .add(DailytasksDeleteTask(task: widget.task));
  }

  String geTimeString(DateTime date) => date.toString().substring(11, 16);

  // Calc differense between current time and task period
  double timeDiffEquality() {
    DateTime currt = DateTime.now();

    if (currt.difference(widget.task.timeStart).inMinutes > 0) {
      var dif = widget.task.timeStart
          .add(widget.task.period)
          .difference(widget.task.timeStart)
          .inMinutes;
      var currFromStart = currt.difference(widget.task.timeStart).inMinutes;

      // print(0.1.);
      return currFromStart / dif;
    }

    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            showSubButtons = !showSubButtons;
          });
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          child: Stack(
            children: [
              Positioned(
                  top: 2,
                  child: Text(geTimeString(widget.task.timeStart),
                      style: TextStyle(
                          color: Color(0xff545353),
                          fontSize: 13,
                          fontWeight: FontWeight.w400))),
              timeDiffEquality() == 0
                  ? SizedBox()
                  : Positioned(
                      top: (120 * timeDiffEquality()) + 12,
                      child: Text(
                        geTimeString(DateTime.now()),
                        style:
                            TextStyle(fontSize: 13, color: Color(0xff545353)),
                      ),
                    ),
              Positioned(
                  bottom: 0,
                  child: Text(
                      geTimeString(
                          widget.task.timeStart.add(widget.task.period)),
                      style: TextStyle(
                          color: Color(0xff545353),
                          fontSize: 13,
                          fontWeight: FontWeight.w400))),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 59,
                  ),
                  buildMainIcon(),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: buildTextSection(),
                  ),
                  widget.task.isDonable ? buildCheckbox(context) : SizedBox(),
                  SizedBox(
                    width: 25,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMainIcon() {
    return Stack(
      children: [
        Container(
          height: 150,
          width: 50,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Color(0xff707070).withOpacity(0.5), blurRadius: 10)
            ],
            color: Color(0xffCAC8C4),
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            height: 150,
            width: 50,
            child: Align(
              alignment: Alignment.topCenter,
              child: ClipRect(
                child: Align(
                  heightFactor: timeDiffEquality(),
                  child: Container(
                    height: 150,
                    width: 50,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Color(0xff707070).withOpacity(0.5),
                            blurRadius: 10)
                      ],
                      color: widget.task.color,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
            height: 150,
            width: 50,
            child: Image.asset(
              'src/icons/Additional.png',
              scale: 1.1,
            )),
      ],
    );
  }

  Column buildTextSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 4,
        ),
        Text(
          '${geTimeString(widget.task.timeStart)} - ${geTimeString(widget.task.timeStart.add(widget.task.period))}',
          style: TextStyle(
              color: Color(0xff545353),
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          widget.task.title,
          style: TextStyle(
              color: Color(0xff545353),
              fontSize: 18,
              fontWeight: FontWeight.w600,
              decoration:
                  completed ? TextDecoration.lineThrough : TextDecoration.none),
        ),
        Text(
          widget.task.subtitle,
          style: TextStyle(
              color: Color(0xff545353),
              fontSize: 14,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 16,
        ),
        buildSubButtons()
      ],
    );
  }

  // Button under task
  // Shows when user tap on task tile
  Widget buildSubButtons() {
    return AnimatedCrossFade(
      duration: Duration(milliseconds: 200),
      crossFadeState:
          showSubButtons ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      firstChild: SizedBox(),
      secondChild: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            miniWhiteBorderedButton(
                text: 'Edit Task',
                iconAsset: 'src/icons/edit.png',
                callback: () => onEditClicked(context)),
            SizedBox(
              width: 8,
            ),
            miniWhiteBorderedButton(
                text: 'Copy Task', iconAsset: 'src/icons/copy.png'),
            SizedBox(
              width: 8,
            ),
            miniWhiteBorderedButton(
                text: 'Delete',
                iconAsset: 'src/icons/delete.png',
                callback: () => onDeleteClicked(context))
          ],
        ),
      ),
    );
  }

  Widget miniWhiteBorderedButton(
      {required String text,
      required String iconAsset,
      VoidCallback? callback}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (callback != null) {
            callback();
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xffF66868), width: 2)),
          child: Row(
            children: [
              Image.asset(
                iconAsset,
                width: 8,
                height: 8,
                fit: BoxFit.cover,
              ),
              SizedBox(
                width: 2,
              ),
              Text(
                text,
                style: TextStyle(fontSize: 8, color: Color(0xffF66868)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector buildCheckbox(BuildContext context) {
    return GestureDetector(
      onTap: () => onCheckClicked(context),
      child: Container(
        margin: EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Color(0xff6E6B6B).withOpacity(0.75),
                blurRadius: 20,
                offset: Offset(0, 10))
          ],
        ),
        child: completed
            ? Image.asset(
                'src/icons/checkbox_checked.png',
                scale: 1.2,
              )
            : Image.asset(
                'src/icons/checkbox_unchecked.png',
                scale: 1.2,
              ),
      ),
    );
  }
}
