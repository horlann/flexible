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
import 'package:table_calendar/table_calendar.dart';

class BottomDatePicker extends StatefulWidget {
  @override
  _BottomDatePickerState createState() => _BottomDatePickerState();

  BottomDatePicker({
    Key? key,
    required this.callback,
    required this.currentPos,
  }) : super(key: key);
  final Function(DateTime date) callback;
  int currentPos;
}

class _BottomDatePickerState extends State<BottomDatePicker> {
  bool showCalendar = false;

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
  Widget build(BuildContext context) {
    String currentDate(DateTime date) =>
        DateFormat('dd.LLLL yyyy').format(date);

    return BlocBuilder<DailytasksBloc, DailytasksState>(
      builder: (context, state) {
        void onTapRight() {
          BlocProvider.of<DailytasksBloc>(context)
              .add(DailytasksSetDay(day: state.showDay.add(Duration(days: 1))));
          widget.callback(state.showDay.add(Duration(days: 1)));
        }

        void onTapLeft() {
          BlocProvider.of<DailytasksBloc>(context).add(
              DailytasksSetDay(day: state.showDay.subtract(Duration(days: 1))));
          widget.callback(state.showDay.subtract(Duration(days: 1)));

        }

        void onTapToday() {
          BlocProvider.of<DailytasksBloc>(context)
              .add(DailytasksSetDay(day: DateTime.now()));
        }

        return Column(
          children: [
            AnimatedCrossFade(
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
                      duration: Duration(milliseconds: 200),
                      crossFadeState: showCalendar
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      firstChild: MiniWhiteButton(
                        text: 'Today',
                        callback: () => onTapToday(),
                      ),
                      secondChild: GestureDetector(
                        onTap: () => onTapLeft(),
                        child: Image.asset(
                          'src/icons/arrow_left.png',
                          width: 22 * byWithScale(context),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showCalendar = !showCalendar;
                        });
                      },
                      child: BlocBuilder<WeatherBloc, WeatherState>(
                        builder: (context, weatherState) {
                          return Container(
                            height: 50,
                            child: Center(
                              child: Text(
                                currentDate(state.showDay),
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17 * byWithScale(context),
                                    color:
                                        weatherState.daylight == DayLight.dark
                                            ? Colors.white
                                            : Color(0xffE24F4F)),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    AnimatedCrossFade(
                      duration: Duration(milliseconds: 200),
                      crossFadeState: showCalendar
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      firstChild: MiniWhiteButton(
                        text: 'Go to Date',
                        callback: () => showCalendarDialog(),
                      ),
                      secondChild: GestureDetector(
                        onTap: () => onTapRight(),
                        child: Image.asset(
                          'src/icons/arrow_right.png',
                          width: 22 * byWithScale(context),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    )
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