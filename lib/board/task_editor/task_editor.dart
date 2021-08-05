import 'package:flexible/board/task_editor/color_picker_row.dart';
import 'package:flexible/board/task_editor/icon_picker_page.dart';
import 'package:flexible/board/task_editor/row_with_close_btn.dart';
import 'package:flexible/board/task_editor/task_icon_in_round.dart';
import 'package:flexible/board/task_editor/task_period_slider.dart';
import 'package:flexible/board/task_editor/title_input_section.dart';
import 'package:flexible/board/widgets/glassmorph_layer.dart';
import 'package:flexible/board/widgets/weather_bg.dart';
import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flexible/widgets/wide_rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flexible/board/models/tasks/regular_taks.dart';
import 'package:flexible/utils/main_backgroung_gradient.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

// This widget aссузе Task instanse then copy and edit copy
// On edit done is send edited task to tasks bloc
class TaskEditor extends StatefulWidget {
  final RegularTask task;
  const TaskEditor({required this.task});

  @override
  _TaskEditorState createState() => _TaskEditorState();
}

class _TaskEditorState extends State<TaskEditor> {
  late RegularTask editableTask;

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

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xffE9E9E9),
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            gradient: mainBackgroundGradient,
          ),
          child: CustomScrollView(
            shrinkWrap: true,
            primary: false,
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: true,
                child: Stack(children: [
                  Container(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    child: WeatherBg(),
                  ),
                  SafeArea(child: buildBody(context))
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 16 * byWithScale(context),
                vertical: 8 * byWithScale(context)),
            // Stack uses for make layer of glass
            child: Stack(
              children: [
                // the glass layer
                // fill uses for adopt is size
                Positioned.fill(child: GlassmorphLayer()),
                RowWithCloseBtn(context: context),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //RowWithCloseBtn(context: context),
                    Padding(
                      padding: EdgeInsets.only(top: 15 * byWithScale(context)),
                      child: Text(
                        'Edit Task',
                        style: TextStyle(
                          fontSize: 26 * byWithScale(context),
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: typeTaskWidget(),
                    ),
                    Text(
                      'When do you want to do it...',
                      style: TextStyle(
                          fontSize: 48 / pRatio(context),
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 40 * byWithScale(context)),
                        padding: EdgeInsets.symmetric(
                            vertical: 8 * byWithScale(context)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              15 * byWithScale(context),
                            ),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: Align(
                                  child: Text(
                                    ":",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  alignment: Alignment.center,
                                ),
                              ),
                            ),
                            TimePickerSpinner(
                              alignment: Alignment.center,
                              isForce2Digits: true,
                              is24HourMode: true,
                              itemHeight: 30 * byWithScale(context),
                              itemWidth: 20 * byWithScale(context),
                              normalTextStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 48 / pRatio(context)),
                              highlightedTextStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 48 / pRatio(context)),
                              spacing: 20 * byWithScale(context),
                              minutesInterval: 1,
                              time: editableTask.timeStart,
                              onTimeChange: (time) {
                                setState(() {
                                  editableTask =
                                      editableTask.copyWith(timeStart: time);
                                });
                              },
                            ),
                          ],
                        )),
                    Wrap(
                      children: [
                        Text(
                          '...once ',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Color(0xffE24F4F),
                              fontSize: 10 * byWithScale(context),
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          'on ',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10 * byWithScale(context),
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          '${editableTask.timeStart.toString().substring(0, 10)}',
                          style: TextStyle(
                              color: Color(0xffE24F4F),
                              fontSize: 10 * byWithScale(context),
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    Text(
                      '...and how long it will take',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10 * byWithScale(context),
                          fontWeight: FontWeight.w400),
                    ),
                    TaskPeriodSlider(
                      period: editableTask.period,
                      callback: (Duration newPeriod) {
                        setState(() {
                          editableTask =
                              editableTask.copyWith(period: newPeriod);
                        });
                      },
                    ),

                    SizedBox(
                      height: 10 * byWithScale(context),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 16 * byWithScale(context)),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25)),
                      padding: EdgeInsets.symmetric(
                          horizontal: 5, vertical: 8 * byWithScale(context)),
                      child: Column(
                        children: [
                          Text(
                            'What color should you task be?',
                            style: TextStyle(
                                fontSize: 12 * byWithScale(context),
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 14 * byWithScale(context)),
                          ColorPickerRow(callback: (color, isActive) {
                            setState(() {
                              editableTask =
                                  editableTask.copyWith(color: color);
                            });
                          }),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 80),
                      child: WideRoundedButton(
                          enable: true,
                          textColor: Colors.white,
                          enableColor: Color(0xffE24F4F),
                          disableColor: Color(0xffE24F4F),
                          callback: () {
                            if (editableTask.title.isEmpty) {
                              print(editableTask);
                              showTopSnackBar(
                                context,
                                CustomSnackBar.info(
                                  backgroundColor: Color(0xffE24F4F),
                                  icon: Icon(
                                    Icons.announcement_outlined,
                                    color: Colors.white,
                                    size: 1,
                                  ),
                                  message: 'Task title shouldn\'t be empty',
                                ),
                              );
                            } else {
                              BlocProvider.of<DailytasksBloc>(context).add(
                                  DailytasksDeleteTask(task: editableTask));
                              Navigator.pop(context);
                            }
                          },
                          text: 'UPDATE TASK'),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        // Expanded(
        //   child: Container(height: 100, width: 100, color: Colors.red),
        // ),
        buildUpdateDeleteButtons()
      ],
    );
  }

  // Sends edited task to bloc
  Widget buildUpdateDeleteButtons() {
    return Column(
      children: [
//        Padding(
//          padding: EdgeInsets.symmetric(horizontal: 80),
//          child: WideRoundedButton(
//              enable: true,
//              textColor: Colors.white,
//              enableColor: Color(0xffE24F4F),
//              disableColor: Color(0xffE24F4F),
//              callback: () {
//                BlocProvider.of<DailytasksBloc>(context)
//                    .add(DailytasksUpdateTaskAndShiftOther(task: editableTask));
//                Navigator.pop(context);
//              },
//              text: 'UPDATE TASK'),
//        ),

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
              text: 'DELETE'),
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

//  Container buildTitleInputSection() {
//    return Container(
//      decoration: BoxDecoration(
//          // color: Colors.red,
//          border:
//              Border(bottom: BorderSide(width: 1, color: Color(0xffB1B1B1)))),
//      padding: EdgeInsets.only(bottom: 2),
//      margin: const EdgeInsets.symmetric(horizontal: 16),
//      child: Row(
//        textBaseline: TextBaseline.alphabetic,
//        crossAxisAlignment: CrossAxisAlignment.end,
//        children: [
//          TaskIconInRound(
//              onTap: () => openImgPicker(),
//              taskColor: editableTask.color,
//              iconId: editableTask.iconId),
//          SizedBox(
//            width: 4,
//          ),
//          Expanded(
//            child: Container(
//                child: SizedBox(
//              height: 20 * byWithScale(context),
//              child: TextFormField(
//                // Change title
//                onChanged: (value) {
//                  setState(() {
//                    editableTask = editableTask.copyWith(title: value);
//                  });
//                },
//
//                decoration: InputDecoration(
//                  border: InputBorder.none,
//                  focusedBorder: InputBorder.none,
//                  enabledBorder: InputBorder.none,
//                  errorBorder: InputBorder.none,
//                  disabledBorder: InputBorder.none,
//                  // contentPadding: EdgeInsets.all(10),
//                ),
//                initialValue: editableTask.title,
//                style: TextStyle(
//                    color: Color(0xff373535),
//                    fontSize: 12 * byWithScale(context)),
//              ),
//            )),
//          )
//        ],
//      ),
//    );
//  }
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
          TaskIconInRound(
              onTap: () => openImgPicker(),
              taskColor: editableTask.color,
              iconId: editableTask.iconId),
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

  Widget typeTaskWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10 * byWithScale(context)),
      child: Row(
        children: [
          TaskIconInRound(
            iconId: editableTask.iconId,
            taskColor: editableTask.color,
            onTap: () => openImgPicker(),
          ),
          SizedBox(
            width: 20 * byWithScale(context),
          ),
          Expanded(
            child: Container(
              // width: byWithScale(context) * 150,
              // height: byWithScale(context) * 35,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              child: TitleInputSection(
                initValue: editableTask.title,
                onChange: (String text) {
                  setState(() {
                    editableTask = editableTask.copyWith(title: text);
                  });
                },
                child: Container(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
