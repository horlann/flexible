import 'dart:math';

import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flexible/board/models/day_options.dart';
import 'package:flexible/board/task_editor/ogtimepicker.dart';
import 'package:flexible/board/widgets/close_button.dart';
import 'package:flexible/board/widgets/glassmorph_layer.dart';
import 'package:flexible/board/widgets/weather_bg.dart';
import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:glassmorphism/glassmorphism.dart';

class DayOptionsEditor extends StatefulWidget {
  final DayOptions dayOptions;

  const DayOptionsEditor({
    Key? key,
    required this.dayOptions,
  }) : super(key: key);

  @override
  _TaskEditorState createState() => _TaskEditorState();
}

class _TaskEditorState extends State<DayOptionsEditor> {
  late DayOptions editableOptions;

  @override
  void initState() {
    super.initState();
    // Copy task for edit
    editableOptions = widget.dayOptions.copyWith();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox.expand(
        child: Stack(
          children: [
            Container(
              child: WeatherBg(),
              width: double.infinity,
              height: double.infinity,
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(18),
                // Stack uses for make layer of glass
                child: Stack(
                  children: [
                    // the glass layer
                    // fill uses for adopt is size
                    Positioned.fill(child: GlassmorphLayer()),
                    CloseButtonn(callback: (){Navigator.pop(context);},),

                    Column(
                      children: [
                        Spacer(
                          flex: 1,
                        ),
                        Text(
                          'Edit Day time',
                          style: TextStyle(
                            fontSize: 80 / pRatio(context),
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Spacer(
                          flex: 2,
                        ),
                        Text(
                          'When do you usually wake up?',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 48 / pRatio(context),
                              fontWeight: FontWeight.w400),
                        ),
                        Spacer(
                          flex: 1,
                        ),
                        buildWakeTimePicker(),
                        Spacer(
                          flex: 2,
                        ),
                        Text(
                          'When do you usually go to bed?',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 48 / pRatio(context),
                              fontWeight: FontWeight.w400),
                        ),
                        Spacer(
                          flex: 1,
                        ),
                        buildSleepTimePicker(),
                        Spacer(
                          flex: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            BlocProvider.of<DailytasksBloc>(context).add(
                                DailytasksUpdateDayOptions(
                                    dayOptions: editableOptions));
                            Navigator.pop(context);
                          },
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 32 * byWithScale(context),
                                  vertical: 8 * byWithScale(context)),
                              decoration: BoxDecoration(
                                  color: Color(0xffE24F4F),
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text(
                                'UPDATE TIME',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 48 / pRatio(context),
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                        Spacer(
                          flex: 1,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            // buildUpdateDeleteButtons()
          ],
        ),
      ),
    );
  }

  Widget buildWakeTimePicker() {
    return GestureDetector(
      onHorizontalDragDown: (details) {},
      child: OgTimePicker(
        initTime: widget.dayOptions.wakeUpTime,
        onChange: (time) {
          setState(() {
            setState(() {
              editableOptions = editableOptions.copyWith(
                  wakeUpTime:
                      time.add(Duration(milliseconds: Random().nextInt(100))));
            });
          });
        },
      ),
    );
    // return SizedBox(
    //   child: Container(
    //     // height: 150,
    //     margin: EdgeInsets.symmetric(horizontal: 40 * byWithScale(context)),
    //     padding: EdgeInsets.symmetric(vertical: 10 * byWithScale(context)),
    //     decoration: BoxDecoration(
    //         color: Colors.white,
    //         boxShadow: [
    //           BoxShadow(
    //               color: Color(0xff000B2B).withOpacity(0.4),
    //               blurRadius: 8 * byWithScale(context))
    //         ],
    //         borderRadius:
    //             BorderRadius.all(Radius.circular(15 * byWithScale(context)))),
    //     child: Stack(
    //       children: [
    //         Positioned.fill(
    //           child: Align(
    //             child: Text(
    //               ":",
    //               style: TextStyle(fontSize: 20),
    //             ),
    //             alignment: Alignment.center,
    //           ),
    //         ),
    //         Center(
    //           child: TimePickerSpinner(
    //             alignment: Alignment.center,
    //             isForce2Digits: true,
    //             is24HourMode: true,
    //             time: widget.dayOptions.wakeUpTime,
    //             itemHeight: 30 * byWithScale(context),
    //             itemWidth: 60 * byWithScale(context),
    //             normalTextStyle: TextStyle(
    //                 color: Colors.grey, fontSize: 15 * byWithScale(context)),
    //             highlightedTextStyle: TextStyle(
    //                 color: Colors.black, fontSize: 15 * byWithScale(context)),
    //             spacing: 0,
    //             minutesInterval: 1,
    //             onTimeChange: (time) {
    //               setState(() {
    //                 editableOptions = editableOptions.copyWith(
    //                     wakeUpTime: time.add(
    //                         Duration(milliseconds: Random().nextInt(100))));
    //               });
    //             },
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  Widget buildSleepTimePicker() {
    return GestureDetector(
      onHorizontalDragDown: (details) {},
      child: OgTimePicker(
        initTime: widget.dayOptions.goToSleepTime,
        onChange: (time) {
          setState(() {
            setState(() {
              editableOptions = editableOptions.copyWith(
                  goToSleepTime:
                      time.add(Duration(milliseconds: Random().nextInt(100))));
            });
          });
        },
      ),
    );

    // return SizedBox(
    //   child: Container(
    //     margin: EdgeInsets.symmetric(horizontal: 40 * byWithScale(context)),
    //     padding: EdgeInsets.symmetric(vertical: 10 * byWithScale(context)),
    //     decoration: BoxDecoration(
    //         color: Colors.white,
    //         boxShadow: [
    //           BoxShadow(
    //               color: Color(0xff000B2B).withOpacity(0.4),
    //               blurRadius: 8 * byWithScale(context))
    //         ],
    //         borderRadius:
    //             BorderRadius.all(Radius.circular(15 * byWithScale(context)))),
    //     child: Stack(
    //       children: [
    //         Positioned.fill(
    //           child: Align(
    //             child: Text(
    //               ":",
    //               style: TextStyle(fontSize: 20),
    //             ),
    //             alignment: Alignment.center,
    //           ),
    //         ),
    //         Center(
    //           child: TimePickerSpinner(
    //             alignment: Alignment.center,
    //             isForce2Digits: true,
    //             is24HourMode: true,
    //             time: widget.dayOptions.goToSleepTime,
    //             itemHeight: 30 * byWithScale(context),
    //             itemWidth: 60 * byWithScale(context),
    //             normalTextStyle: TextStyle(
    //                 color: Colors.grey, fontSize: 15 * byWithScale(context)),
    //             highlightedTextStyle: TextStyle(
    //                 color: Colors.black, fontSize: 15 * byWithScale(context)),
    //             spacing: 0,
    //             minutesInterval: 1,
    //             onTimeChange: (time) {
    //               setState(() {
    //                 editableOptions = editableOptions.copyWith(
    //                     goToSleepTime: time.add(
    //                         Duration(milliseconds: Random().nextInt(100))));
    //                 //DateTime wakeUpTime =
    //                 //DateUtils.dateOnly(editableOptions.wakeUpTime).add(time);
    //                 //_dateTime = time;
    //               });
    //             },
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  GlassmorphicContainer buildGlassmorphicLayer() {
    return GlassmorphicContainer(
      width: double.maxFinite,
      height: double.maxFinite,
      borderRadius: 40,
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
    );
  }
}
