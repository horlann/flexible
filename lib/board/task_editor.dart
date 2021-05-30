import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism/glassmorphism.dart';

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
                            'Edit Task',
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
                          buildColorPicker(),
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
                .add(DailytasksUpdateTask(task: editableTask));
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
                'Update Task',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        GestureDetector(
          onTap: () {
            BlocProvider.of<DailytasksBloc>(context)
                .add(DailytasksDeleteTask(task: editableTask));
            Navigator.pop(context);
          },
          child: Container(
            height: 40,
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(horizontal: 40),
            child: Center(
              child: Text(
                'Delete Task',
                style: TextStyle(
                    color: Colors.black,
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

  Widget buildColorPicker() {
    Widget colorPart({required Color color, required String name}) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            editableTask = editableTask.copyWith(color: color);
          },
          child: Row(
            children: [
              Text(name,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
              SizedBox(
                width: 4,
              ),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    color: color, borderRadius: BorderRadius.circular(10)),
              )
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Spacer(
            flex: 2,
          ),
          colorPart(color: Color(0xffE24F4F), name: 'Day'),
          Spacer(
            flex: 2,
          ),
          colorPart(color: Color(0xff1260C5).withOpacity(0.8), name: 'Night'),
          Spacer(
            flex: 2,
          ),
          colorPart(color: Colors.yellow, name: 'Classic'),
          Spacer(
            flex: 2,
          ),
          colorPart(color: Color(0xff373535).withOpacity(0.2), name: 'Custom'),
          Spacer(
            flex: 2,
          ),
        ],
      ),
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
          Image.asset(
            'src/icons/supermarket.png',
            width: 32,
          ),
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

class TimeSlider extends StatelessWidget {
  final Duration period;
  final Function(Duration) callback;

  const TimeSlider({required this.period, required this.callback});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${period.inHours.toString()} hours',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
              ),
              Text('Edit',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))
            ],
          ),
        ),
        SliderTheme(
          data: SliderThemeData(
            // trackHeight: 2,
            activeTickMarkColor: Colors.black,
            inactiveTickMarkColor: Colors.black,
            // thumbColor: ColorAssets.themeColorMagenta,
            thumbColor: Color(0xffE24F4F),
            activeTrackColor: Color(0xffDDDDDD),
            inactiveTrackColor: Color(0xffDDDDDD),
            trackShape: RectangularSliderTrackShape(),

            // overlayColor: Colors.red.withAlpha(32),
            // overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),

            valueIndicatorShape: PaddleSliderValueIndicatorShape(),
            valueIndicatorColor: Colors.redAccent,
            valueIndicatorTextStyle: TextStyle(
              color: Colors.white,
            ),
            trackHeight: 6.0,
          ),
          child: Slider(
            max: 8,
            min: 0,
            value: period.inHours.toDouble(),
            // activeColor: Colors.grey,
            // inactiveColor: Colors.grey,
            onChanged: (v) => callback(
              Duration(hours: v.toInt()),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                  9,
                  (index) => Text(
                        '$index h',
                        style: TextStyle(fontSize: 12),
                      ))),
        )
      ],
    );
  }
}
