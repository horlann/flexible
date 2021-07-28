import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flexible/board/models/day_options.dart';
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
      backgroundColor: Color(0xffE9E9E9),
      body: SafeArea(
          child: SizedBox.expand(
            child: Container(
              decoration: BoxDecoration(
            color: Colors.green,
            // gradient: mainBackgroundGradient,
          ),
              child: Stack(
                children: [
              Container(
                child: WeatherBg(),
                width: double.infinity,
                height: double.infinity,
              ),
              Padding(
                padding: EdgeInsets.all(18),
                    // Stack uses for make layer of glass
                    child: Stack(
                      children: [
                        // the glass layer
                        // fill uses for adopt is size
                        Positioned.fill(child: GlassmorphLayer()),
                        Padding(
                          padding: EdgeInsets.only(left: 15 * byWithScale(
                              context)),
                          child: buildCloseButton(),
                        ),

                        Column(
                          children: [
                            Text(
                              'Edit Daytime',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Text(
                              'When do you want to do wake up',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            buildWakeTimePicker(),
                            SizedBox(
                              height: 56,
                            ),
                            Text(
                              'When do you want to go sleep',
                              style: TextStyle(color: Colors.white,
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            buildSleepTimePicker(),
                            SizedBox(
                              height: 70,
                            ),
                            GestureDetector(
                              onTap: () {
                                BlocProvider.of<DailytasksBloc>(context).add(
                                    DailytasksUpdateDayOptions(
                                        dayOptions: editableOptions));
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 40,
                                width: double.maxFinite,
                                margin: EdgeInsets.symmetric(horizontal: 70),
                                decoration: BoxDecoration(
                                    color: Color(0xffE24F4F),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Center(
                                  child: Text(
                                    'UPDATE TASK',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
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
        SizedBox(
          height: 16,
        ),
      ],
    );
  }

  SizedBox buildWakeTimePicker() {
    return SizedBox(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 60 * byWithScale(context)),
        padding: EdgeInsets.symmetric(horizontal: 20 * byWithScale(context)),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.all(Radius.circular(15 * byWithScale(context)))),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery
                    .of(context)
                    .size
                    .width * 0.03,
                top: MediaQuery
                    .of(context)
                    .size
                    .width * 0.105,
              ),
              child: Align(
                child: Text(":", style: TextStyle(fontSize: 20),),
                alignment: Alignment.center,
              ),
            ),
            Center(
              child: TimePickerSpinner(
                isForce2Digits: true,
                is24HourMode: true,
                time: widget.dayOptions.wakeUpTime,
                itemHeight: 30 * byWithScale(context),
                itemWidth: 30 * byWithScale(context),
                normalTextStyle: TextStyle(
                    color: Colors.grey, fontSize: 15 * byWithScale(context)),
                highlightedTextStyle: TextStyle(
                    color: Colors.black, fontSize: 15 * byWithScale(context)),
                spacing: 40,
                minutesInterval: 1,
                onTimeChange: (time) {
                  setState(() {
                    editableOptions =
                        editableOptions.copyWith(wakeUpTime: time);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox buildSleepTimePicker() {
    return SizedBox(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 60 * byWithScale(context)),
        padding: EdgeInsets.symmetric(horizontal: 20 * byWithScale(context)),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.all(Radius.circular(15 * byWithScale(context)))),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery
                    .of(context)
                    .size
                    .width * 0.105,
                left: MediaQuery
                    .of(context)
                    .size
                    .width * 0.03,

              ),
              child: Align(
                child: Text(":", style: TextStyle(fontSize: 20),),
                alignment: Alignment.center,
              ),
            ),
            Center(
              child: TimePickerSpinner(
                isForce2Digits: true,
                is24HourMode: true,
                time: widget.dayOptions.goToSleepTime,

                itemHeight: 30 * byWithScale(context),
                itemWidth: 30 * byWithScale(context),
                normalTextStyle: TextStyle(
                    color: Colors.grey, fontSize: 15 * byWithScale(context)),
                highlightedTextStyle: TextStyle(
                    color: Colors.black, fontSize: 15 * byWithScale(context)),
                spacing: 40,
                minutesInterval: 1,
                onTimeChange: (time) {
                  setState(() {
                    editableOptions =
                        editableOptions.copyWith(goToSleepTime: time);
                    //DateTime wakeUpTime =
                    //DateUtils.dateOnly(editableOptions.wakeUpTime).add(time);
                    //_dateTime = time;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCloseButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 16),
            child: Image.asset(
              'src/icons/close.png',
              width: 22,
              fit: BoxFit.fitWidth,
            ),
          )
        ],
      ),
    );
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
