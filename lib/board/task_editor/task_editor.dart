import 'dart:math';
import 'dart:ui';

import 'package:another_flushbar/flushbar.dart';
import 'package:flexible/board/board_page.dart';
import 'package:flexible/board/task_editor/color_picker_row.dart';
import 'package:flexible/board/task_editor/icon_picker_page.dart';
import 'package:flexible/board/task_editor/ogtimepicker.dart';
import 'package:flexible/board/task_editor/routes.dart';
import 'package:flexible/board/task_editor/row_with_close_btn.dart';
import 'package:flexible/board/task_editor/task_icon_in_round.dart';
import 'package:flexible/board/task_editor/task_period_slider.dart';
import 'package:flexible/board/task_editor/title_input_section.dart';
import 'package:flexible/board/widgets/glassmorph_layer.dart';
import 'package:flexible/board/widgets/weather_bg.dart';
import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flexible/weather/bloc/weather_bloc.dart';
import 'package:flexible/weather/openweather_service.dart';
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
  GlobalKey key = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Copy task for edit
    editableTask = widget.task.copyWith();
  }

  // Open picker
  // Picker should return icon id as string
  openImgPicker() {
    print(_getOffset(key));
    Navigator.push(
        context,
        RevealRoute(
          page: IconPickerPage(
            text: editableTask.title,
          ),
          maxRadius: 800,
          centerAlignment: Alignment.center,
          centerOffset: _getOffset(key),
        )).then((iconId) {
      if (iconId != null) {
        setState(() {
          editableTask = editableTask.copyWith(iconId: iconId);
        });
      }
    });
  }

  Offset? _getOffset(GlobalKey? key) {
    if (key == null) return null;
    final renderObject = key.currentContext?.findRenderObject();
    var translation = renderObject?.getTransformTo(null).getTranslation();
    print(Offset(translation!.x, translation.y).toString());

    if (translation != null && renderObject?.paintBounds != null) {
      return Offset(translation.x, translation.y);
    } else {
      return null;
    }
  }

  void showSnackBar(
      BuildContext buildContext, String text, bool isProgressive) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    Flushbar(
      message: text,
      barBlur: 20,
      mainButton: isProgressive
          ? Padding(
              padding: const EdgeInsets.only(right: 15.0, top: 10, bottom: 10),
              child: CircularProgressIndicator(
                strokeWidth: 5,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : SizedBox(),
      duration: Duration(seconds: 2),
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: BorderRadius.all(Radius.circular(16)),
      backgroundColor: Color(0xffE24F4F),
      margin: const EdgeInsets.symmetric(horizontal: 11),
      messageText: Center(
          child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      )),
    )..show(context);
  }

  Widget build(BuildContext context) {
    print(editableTask.timeStart);
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
                    GestureDetector(
                      onHorizontalDragDown: (details) {},
                      child: OgTimePicker(
                        initTime: editableTask.timeStart,
                        onChange: (time) {
                          setState(() {
                            print(editableTask.timeStart);
                            print(time);
                            editableTask = editableTask.copyWith(
                                timeStart: time.add(Duration(
                                    milliseconds: Random().nextInt(100))));
                          });
                        },
                      ),
                    ),

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
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 16 * byWithScale(context)),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25)),
                        padding: EdgeInsets.symmetric(
                            horizontal: 5, vertical: 8 * byWithScale(context)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'What color should you task be?',
                              style: TextStyle(
                                  fontSize: 12 * byWithScale(context),
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 14 * byWithScale(context)),
                            ColorPickerRow(callback: (color) {
                              print(color);
                              setState(() {
                                editableTask =
                                    editableTask.copyWith(color: color);
                              });
                            }),
                          ],
                        ),
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
                              showSnackBar(context,
                                  'Task title shouldn\'t be empty', false);
                            } else {
                              BlocProvider.of<DailytasksBloc>(context).add(
                                  DailytasksUpdateTaskAndShiftOther(
                                      task: editableTask));
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
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: BlocBuilder<WeatherBloc, WeatherState>(
            builder: (buildcontext, state) {
              return WideRoundedButton(
                  enable: true,
                  textColor: state.daylight == DayLight.dark
                      ? Colors.white
                      : Colors.black,
                  enableColor: Colors.transparent,
                  disableColor: Colors.transparent,
                  callback: () {
                    BlocProvider.of<DailytasksBloc>(context)
                        .add(DailytasksDeleteTask(task: editableTask));
                    Navigator.of(context).push(_createRoute());
                  },
                  text: 'DELETE');
            },
          ),
        ),
        SizedBox(
          height: 8 * byWithScale(context),
        ),
      ],
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => BoardPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
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
    int c = 0;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10 * byWithScale(context)),
      child: Row(
        children: [
          GestureDetector(
            onDoubleTap: () {
              c++;
              print(c);
              if (c == 3) {
                print('Marked as ai suitable');
                showSnackBar(context, 'Marked as ai suitable', false);
              }
              editableTask = editableTask.copyWith(forAi: true);
            },
            child: Container(
              key: key,
              child: TaskIconInRound(
                iconId: editableTask.iconId,
                taskColor: editableTask.color,
                onTap: () => openImgPicker(),
              ),
            ),
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

class CircularRevealClipper extends CustomClipper<Path> {
  final double fraction;
  final Alignment centerAlignment;
  final Offset centerOffset;
  final double minRadius;
  final double maxRadius;

  CircularRevealClipper({
    required this.fraction,
    required this.centerAlignment,
    required this.centerOffset,
    required this.minRadius,
    required this.maxRadius,
  });

  @override
  Path getClip(Size size) {
    final Offset center = this.centerAlignment.alongSize(size) ??
        this.centerOffset ??
        Offset(size.width / 2, size.height / 2);
    final minRadius = this.minRadius ?? 0;
    final maxRadius = this.maxRadius ?? calcMaxRadius(size, center);

    return Path()
      ..addOval(
        Rect.fromCircle(
          center: center,
          radius: lerpDouble(minRadius, maxRadius, fraction)!,
        ),
      );
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;

  static double calcMaxRadius(Size size, Offset center) {
    final w = max(center.dx, size.width - center.dx);
    final h = max(center.dy, size.height - center.dy);
    return sqrt(w * w + h * h);
  }
}
