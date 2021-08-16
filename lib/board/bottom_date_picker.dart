// Show bar with selected day
// Shift day by arrow arround date
// On tap transforms to week calendar
import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flexible/board/calendar_dialog.dart';
import 'package:flexible/board/week_calendar.dart';
import 'package:flexible/board/widgets/mini_red_button.dart';
import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flexible/weather/bloc/weather_bloc.dart';
import 'package:flexible/weather/openweather_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class BottomDatePicker extends StatefulWidget {
  @override
  _BottomDatePickerState createState() => _BottomDatePickerState();
}

class _BottomDatePickerState extends State<BottomDatePicker>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late AnimationController controller2;
  late Animation<double> animation;
  late Animation<double> animation2;
  bool showCalendar = false;
  bool selected = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = new AnimationController(
        duration: Duration(milliseconds: 300), vsync: this)
      ..addListener(() => setState(() {}));
    controller2 = new AnimationController(
        duration: Duration(milliseconds: 300), vsync: this)
      ..addListener(() => setState(() {}));
    animation = Tween(begin: 0.0, end: 550.0).animate(controller);
    animation2 = Tween(begin: 0.0, end: 550.0).animate(controller2);
  }

  void showCalendarDialog() {
    DateTime showday = BlocProvider.of<DailytasksBloc>(context).showDay;
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => CalendarDialog(
          focusedDay: showday,
          withTail: true,
          onSelect: (selectedDay) => onCalendarSelect(selectedDay)),
    );
  }

  onCalendarSelect(selectedDay) {
    BlocProvider.of<DailytasksBloc>(context)
        .add(DailytasksSetDay(day: selectedDay));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    controller2.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    String currentDate(DateTime date) =>
        DateFormat('dd.LLLL yyyy').format(date);

    return BlocBuilder<DailytasksBloc, DailytasksState>(
      builder: (context, state) {
        void onTapRight() {
          BlocProvider.of<DailytasksBloc>(context)
              .add(DailytasksSetDay(day: state.showDay.add(Duration(days: 1))));
          controller2.reset();

        }

        void onTapLeft() {
          BlocProvider.of<DailytasksBloc>(context).add(
              DailytasksSetDay(day: state.showDay.subtract(Duration(days: 1))));
          controller2.reset();
        }

        void onTapToday() {
          BlocProvider.of<DailytasksBloc>(context)
              .add(DailytasksSetDay(day: DateTime.now()));
        }

        return Column(
          children: [
            AnimatedCrossFade(
                reverseDuration: Duration(milliseconds: 300),

                duration: Duration(milliseconds: 300),
                crossFadeState: showCalendar
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                firstChild: SizedBox(),
                secondChild: WeekCalendar(showCalendar: showCalendar)),

            SizedBox(
              width: 300 * byWithScale(context),
              child: Padding(
                padding: EdgeInsets.only(left: 8 * byWithScale(context)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AnimatedCrossFade(
                      sizeCurve: Curves.ease,
                      secondCurve: Curves.decelerate,
                      reverseDuration: Duration(milliseconds: 500),
                      duration: Duration(milliseconds: 500),
                      crossFadeState: showCalendar
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      firstChild: MiniWhiteButton(
                        text: 'Today',
                        callback: () => onTapToday(),
                      ),
                      secondChild: GestureDetector(
                        onTap: () => onTapLeft(),
                        child: Container(
                          color: Colors.transparent,
                          alignment: Alignment.center,
                          width: 65 * byWithScale(context),
                          height: 40 * byWithScale(context),
                          child: Image.asset(
                            'src/icons/arrow_left.png',
                            width: 24 * byWithScale(context),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showCalendar = !showCalendar;
                          selected = !selected;
                        });
                      },
                      child: BlocBuilder<WeatherBloc, WeatherState>(
                        builder: (context, weatherState) {
                          return Text(
                            currentDate(state.showDay),
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18 * byWithScale(context),
                                color: weatherState.daylight == DayLight.dark
                                    ? Colors.white
                                    : Color(0xffE24F4F)),
                          );
                        },
                      ),
                    ),
                    AnimatedCrossFade(
                      sizeCurve: Curves.ease,
                      secondCurve: Curves.decelerate,
                      reverseDuration: Duration(milliseconds: 500),
                      duration: Duration(milliseconds: 500),
                      crossFadeState: showCalendar
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      firstChild: MiniWhiteButton(
                        text: 'Go to date',
                        callback: () => onTapToday(),
                      ),
                      secondChild: GestureDetector(
                        onTap: () => onTapLeft(),
                        child: Container(
                          color: Colors.transparent,
                          alignment: Alignment.center,
                          width: 65 * byWithScale(context),
                          height: 40 * byWithScale(context),
                          child: Image.asset(
                            'src/icons/arrow_right.png',
                            width: 24 * byWithScale(context),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
