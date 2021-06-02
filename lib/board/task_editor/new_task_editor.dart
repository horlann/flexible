import 'package:flexible/board/task_editor/color_picker_row.dart';
import 'package:flexible/board/task_editor/icon_picker_page.dart';
import 'package:flexible/board/task_editor/row_with_close_btn.dart';
import 'package:flexible/board/task_editor/task_icon_in_round.dart';
import 'package:flexible/board/task_editor/time_slider.dart';
import 'package:flexible/board/widgets/glassmorph_layer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flexible/board/models/task.dart';
import 'package:flexible/utils/main_backgroung_gradient.dart';

class NewTaskEditor extends StatefulWidget {
  @override
  _NewTaskEditorState createState() => _NewTaskEditorState();
}

class _NewTaskEditorState extends State<NewTaskEditor> {
  late Task editableTask;

  @override
  void initState() {
    super.initState();
    // Create New Task

    ;
    editableTask = Task(
        title: 'New Task',
        subtitle: '',
        timeStart: BlocProvider.of<DailytasksBloc>(context).state.showDay,
        period: Duration(),
        isDone: false,
        isDonable: true,
        timeLock: false,
        color: Colors.grey,
        iconId: 'additional');
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
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(28),
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
                            'Create an Task',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Color(0xffE24F4F),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          buildTitleInputSection(),
                          SizedBox(
                            height: 24,
                          ),
                          Text(
                            'When do you want to do it...',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          buildTimePicker(),
                          Text(
                            '...once on ${editableTask.timeStart.toString().substring(0, 10)}',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            '...and how long it will take',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: 8,
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
                            height: 32,
                          ),
                          Text(
                            'What color shoulz you task be?',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          ColorPickerRow(callback: (color) {
                            setState(() {
                              editableTask =
                                  editableTask.copyWith(color: color);
                            });
                          }),
                          SizedBox(
                            height: 16,
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
        SizedBox(
          height: 16,
        ),
        GestureDetector(
          onTap: () {
            BlocProvider.of<DailytasksBloc>(context)
                .add(DailytasksAddTask(task: editableTask));
            Navigator.pop(context);
          },
          child: Container(
            height: 40,
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(horizontal: 40),
            decoration: BoxDecoration(
                color: Color(0xffE24F4F),
                borderRadius: BorderRadius.circular(30)),
            child: Center(
              child: Text(
                'Create Task',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }

  SizedBox buildTimePicker() {
    return SizedBox(
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
            }));
  }

  Container buildTitleInputSection() {
    return Container(
      decoration: BoxDecoration(
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
              height: 32,
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
                  contentPadding: EdgeInsets.all(0),
                ),
                initialValue: editableTask.title,
                style: TextStyle(color: Color(0xff373535)),
              ),
            )),
          )
        ],
      ),
    );
  }
}
