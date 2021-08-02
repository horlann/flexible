import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flexible/board/calendar_dialog.dart';
import 'package:flexible/board/models/tasks/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class CopyTaskDialog extends StatefulWidget {
  final Task task;

  CopyTaskDialog({required this.task});

  @override
  _CopyTaskDialogState createState() => _CopyTaskDialogState();
}

class _CopyTaskDialogState extends State<CopyTaskDialog> {
  late DateTime copyTo;
  bool showCalendarPicker = false;

  @override
  void initState() {
    super.initState();
    // init copy to date with one day forward
    copyTo = DateUtils.dateOnly(widget.task.timeStart.add(Duration(days: 1)));
  }

  copy() {
    // Copy with new date
    // and reset done value
    Task newTask = widget.task.copyWith(
        uuid: Uuid().v1(),
        isDone: false,
        timeStart: copyTo.add(Duration(
            hours: widget.task.timeStart.hour,
            minutes: widget.task.timeStart.minute)));

    // add
    BlocProvider.of<DailytasksBloc>(context)
        .add(DailytasksAddTask(task: newTask));
    // out
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return showCalendarPicker
        ? CalendarDialog(
            focusedDay: copyTo,
            onSelect: (date) {
              copyTo = DateUtils.dateOnly(date);
              setState(() {
                showCalendarPicker = false;
              });
            },
            header: 'Copy task to:',
          )
        : buildCopyStage();
  }

  Widget buildCopyStage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              // height: 330,
              width: double.maxFinite,
              child: Dialog(
                insetAnimationCurve: Curves.bounceInOut,
                insetAnimationDuration: Duration(milliseconds: 200),
                insetPadding: EdgeInsets.symmetric(horizontal: 8),
                backgroundColor: Colors.transparent,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                          child: Stack(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Copy tasks on:',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    height: 20,
                                    width: 20,
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.black, width: 2.5),
                                        color: Colors.white),
                                    child: Image.asset(
                                      'src/icons/close.png',
                                      //width: 15,
                                      //height: 15,
                                      color: Colors.black,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            children: [
                              Text(
                                'from',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                DateUtils.dateOnly(widget.task.timeStart)
                                    .toString()
                                    .substring(5, 10),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                'into',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                DateUtils.dateOnly(copyTo)
                                    .toString()
                                    .substring(5, 10),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                              ),
                              Spacer(
                                flex: 2,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showCalendarPicker = true;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 4),
                                  decoration: BoxDecoration(
                                      color: Color(0xffE24F4F).withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    DateFormat('MMMM').format(DateTime.now()
                                            .add(Duration(days: 1))) +
                                        " " +
                                        DateFormat('d').format(DateTime.now()
                                            .add(Duration(days: 1))) +
                                        " " +
                                        DateFormat('y').format(DateTime.now()
                                            .add(Duration(days: 1))),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        buildSameDayWarning(),
                        SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 32,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSameDayWarning() {
    if (DateUtils.isSameDay(widget.task.timeStart, copyTo)) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
            'Recuriing tasks and calendar events wont be copied into the same day',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xffE24F4F))),
      );
    } else {
      return GestureDetector(
        onTap: () => copy(),
        child: Container(
          height: 50,
          width: double.maxFinite,
          margin: EdgeInsets.symmetric(horizontal: 60),
          decoration: BoxDecoration(
              color: Color(0xffE24F4F),
              borderRadius: BorderRadius.circular(30)),
          child: Center(
            child: Text(
              'CONTINUE',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ),
      );
    }
  }
}
