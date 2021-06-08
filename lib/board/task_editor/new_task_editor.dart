import 'package:flexible/board/task_editor/color_picker_row.dart';
import 'package:flexible/board/task_editor/icon_picker_page.dart';
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
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: buildBody(context),
              ),
            ],
          ),
        ),
      )),
    );
  }

  Column buildBody(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(16 * byWithScale(context)),
            // Stack uses for make layer of glass
            child: Stack(
              children: [
                // the glass layer
                // fill uses for adopt is size
                Positioned.fill(child: GlassmorphLayer()),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    buildTitleInputSection(),
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
                    Text(
                      '...and how long it will take',
                      style: TextStyle(
                          fontSize: 10 * byWithScale(context),
                          fontWeight: FontWeight.w400),
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
                    Text(
                      'What color should you task be?',
                      style: TextStyle(
                          fontSize: 12 * byWithScale(context),
                          fontWeight: FontWeight.w600),
                    ),
                    ColorPickerRow(callback: (color) {
                      setState(() {
                        editableTask = editableTask.copyWith(color: color);
                      });
                    }),
                  ],
                )
              ],
            ),
          ),
        ),
        buildUpdateDeleteButtons()
      ],
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
                    .add(DailytasksAddTask(task: editableTask));
                Navigator.pop(context);
              },
              text: 'Create Task'),
        ),
        SizedBox(
          height: 8 * byWithScale(context),
        ),
      ],
    );
  }

  SizedBox buildTimePicker() {
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
