import 'dart:typed_data';

import 'package:flexible/board/task_editor/color_picker_row.dart';
import 'package:flexible/board/task_editor/icon_picker_page.dart';
import 'package:flexible/board/repository/image_repo_mock.dart';
import 'package:flexible/board/task_editor/row_with_close_btn.dart';
import 'package:flexible/board/task_editor/task_icon_in_round.dart';
import 'package:flexible/board/task_editor/time_slider.dart';
import 'package:flexible/board/widgets/glassmorph_layer.dart';
import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flexible/widgets/wide_rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flexible/board/models/task.dart';
import 'package:flexible/utils/main_backgroung_gradient.dart';

// This widget aссузе Task instanse then copy and edit copy
// On edit done is send edited task to tasks bloc
class TaskEditor extends StatefulWidget {
  final Task task;
  const TaskEditor({required this.task});

  @override
  _TaskEditorState createState() => _TaskEditorState();
}

class _TaskEditorState extends State<TaskEditor> {
  late Task editableTask;

  @override
  void initState() {
    super.initState();
    // Copy task for edit
    editableTask = widget.task.copyWith();
  }

  // Open picker
  // Picker should return icon id as string
  openImgPicker() {
    Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => IconPickerPage(),
        )).then((iconId) {
      if (iconId != null) {
        setState(() {
          editableTask = editableTask.copyWith(iconId: iconId);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xffE9E9E9),
      body: SafeArea(
          child: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            gradient: mainBackgroundGradient,
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16 * byWithScale(context)),
                  // Stack uses for make layer of glass
                  child: Stack(
                    children: [
                      // the glass layer
                      // fill uses for adopt is size
                      Positioned.fill(child: GlassmorphLayer()),
                      Column(
                        children: [
                          RowWithCloseBtn(context: context),
                          Text(
                            'Edit Task',
                            style: TextStyle(
                              fontSize: 24 * byWithScale(context),
                              fontWeight: FontWeight.w700,
                              color: Color(0xffE24F4F),
                            ),
                          ),
                          SizedBox(
                            height: 4 * byWithScale(context),
                          ),
                          buildTitleInputSection(),
                          SizedBox(
                            height: 8 * byWithScale(context),
                          ),
                          Text(
                            'When do you want to do it...',
                            style: TextStyle(
                                fontSize: 12 * byWithScale(context),
                                fontWeight: FontWeight.w600),
                          ),
                          buildTimePicker(),
                          Text(
                            '...once on ${editableTask.timeStart.toString().substring(0, 10)}',
                            style: TextStyle(
                                fontSize: 10 * byWithScale(context),
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            '...and how long it will take',
                            style: TextStyle(
                                fontSize: 10 * byWithScale(context),
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: 8 * byWithScale(context),
                          ),
                          TimeSlider(
                            period: editableTask.period,
                            callback: (Duration newPeriod) {
                              setState(() {
                                editableTask =
                                    editableTask.copyWith(period: newPeriod);
                              });
                            },
                          ),
                          SizedBox(
                            height: 16 * byWithScale(context),
                          ),
                          Text(
                            'What color should you task be?',
                            style: TextStyle(
                                fontSize: 12 * byWithScale(context),
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 8 * byWithScale(context),
                          ),
                          ColorPickerRow(callback: (color) {
                            setState(() {
                              editableTask =
                                  editableTask.copyWith(color: color);
                            });
                          }),
                          SizedBox(
                            height: 16 * byWithScale(context),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                buildUpdateDeleteButtons()
              ],
            ),
          ),
        ),
      )),
    );
  }

  // Sends edited task to bloc
  Widget buildUpdateDeleteButtons() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: WideRoundedButton(
              enable: true,
              textColor: Colors.white,
              enableColor: Color(0xffE24F4F),
              disableColor: Color(0xffE24F4F),
              callback: () {
                BlocProvider.of<DailytasksBloc>(context)
                    .add(DailytasksUpdateTaskAndShiftOther(task: editableTask));
                Navigator.pop(context);
              },
              text: 'Update Task'),
        ),
        SizedBox(
          height: 8,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: WideRoundedButton(
              enable: true,
              textColor: Colors.black,
              enableColor: Colors.transparent,
              disableColor: Colors.transparent,
              callback: () {
                BlocProvider.of<DailytasksBloc>(context)
                    .add(DailytasksDeleteTask(task: editableTask));
                Navigator.pop(context);
              },
              text: 'Delete Task'),
        ),
        SizedBox(
          height: 8 * byWithScale(context),
        ),
      ],
    );
  }

  Widget buildTimePicker() {
    return SizedBox(
      height: 120 * byWithScale(context),
      child: FittedBox(
        child: SizedBox(
            height: 190,
            child: CupertinoTimerPicker(
                initialTimerDuration: editableTask.timeStart
                    .difference(DateUtils.dateOnly(editableTask.timeStart)),
                mode: CupertinoTimerPickerMode.hm,
                onTimerDurationChanged: (v) {
                  DateTime timeStart =
                      DateUtils.dateOnly(editableTask.timeStart).add(v);

                  setState(() {
                    editableTask = editableTask.copyWith(timeStart: timeStart);
                  });
                })),
      ),
    );
  }

  Container buildTitleInputSection() {
    return Container(
      decoration: BoxDecoration(
          // color: Colors.red,
          border:
              Border(bottom: BorderSide(width: 1, color: Color(0xffB1B1B1)))),
      padding: EdgeInsets.only(bottom: 2),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        textBaseline: TextBaseline.alphabetic,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
              onTap: () => openImgPicker(),
              child: TaskIconInRound(
                  taskColor: editableTask.color, iconId: editableTask.iconId)),
          SizedBox(
            width: 4,
          ),
          Expanded(
            child: Container(
                child: SizedBox(
              height: 20 * byWithScale(context),
              child: TextFormField(
                // Change title
                onChanged: (value) {
                  setState(() {
                    editableTask = editableTask.copyWith(title: value);
                  });
                },

                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  // contentPadding: EdgeInsets.all(10),
                ),
                initialValue: editableTask.title,
                style: TextStyle(
                    color: Color(0xff373535),
                    fontSize: 12 * byWithScale(context)),
              ),
            )),
          )
        ],
      ),
    );
  }
}
