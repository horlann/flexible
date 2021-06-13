import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flexible/board/calendar_dialog.dart';
import 'package:flexible/board/models/tasks/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          )
        : buildCopyStage();
  }

  Widget buildCopyStage() {
    return Align(
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
                  color: Color(0xffF66868),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Copy task on',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Image.asset(
                                'src/icons/close.png',
                                width: 24,
                                fit: BoxFit.fitWidth,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Text(
                              'From',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
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
                                  color: Colors.white.withOpacity(0.75)),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              'into',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
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
                                  color: Colors.white.withOpacity(0.75)),
                            ),
                            Spacer(
                              flex: 1,
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
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6)),
                                child: Text('Select date'),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
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
                color: Colors.white)),
      );
    } else {
      return GestureDetector(
        onTap: () => copy(),
        child: Container(
          height: 40,
          width: double.maxFinite,
          margin: EdgeInsets.symmetric(horizontal: 40),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(30)),
          child: Center(
            child: Text(
              'Copy Task',
              style: TextStyle(
                  color: Color(0xffF66868),
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ),
      );
    }
  }
}
