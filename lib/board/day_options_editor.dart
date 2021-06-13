import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism/glassmorphism.dart';

import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flexible/board/models/day_options.dart';
import 'package:flexible/board/models/tasks/regular_taks.dart';
import 'package:flexible/utils/main_backgroung_gradient.dart';

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
                      Positioned.fill(child: buildGlassmorphicLayer()),
                      Column(
                        children: [
                          buildCloseButton(),
                          Text(
                            'Edit Daytime',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Color(0xffE24F4F),
                            ),
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          Text(
                            'When do you want to do wake up',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          buildWakeTimePicker(),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            'When do you want to go sleep',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          buildSleepTimePicker(),
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
                .add(DailytasksUpdateDayOptions(dayOptions: editableOptions));
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
                'Update time settings',
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

  SizedBox buildWakeTimePicker() {
    return SizedBox(
        height: 190,
        child: CupertinoTimerPicker(
            initialTimerDuration: editableOptions.wakeUpTime
                .difference(DateUtils.dateOnly(editableOptions.wakeUpTime)),
            mode: CupertinoTimerPickerMode.hm,
            onTimerDurationChanged: (v) {
              DateTime wakeUpTime =
                  DateUtils.dateOnly(editableOptions.wakeUpTime).add(v);

              setState(() {
                editableOptions =
                    editableOptions.copyWith(wakeUpTime: wakeUpTime);
              });
            }));
  }

  SizedBox buildSleepTimePicker() {
    return SizedBox(
        height: 190,
        child: CupertinoTimerPicker(
            initialTimerDuration: editableOptions.goToSleepTime
                .difference(DateUtils.dateOnly(editableOptions.goToSleepTime)),
            mode: CupertinoTimerPickerMode.hm,
            onTimerDurationChanged: (v) {
              DateTime goToSleepTime =
                  DateUtils.dateOnly(editableOptions.goToSleepTime).add(v);

              setState(() {
                editableOptions =
                    editableOptions.copyWith(goToSleepTime: goToSleepTime);
              });
            }));
  }

  Widget buildCloseButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 16),
            child: Image.asset(
              'src/icons/close.png',
              width: 24,
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
