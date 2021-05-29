// Show bar with selected day
// Shift day by arrow arround date
// On tap transforms to week calendar
import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flexible/board/calendar_dialog.dart';
import 'package:flexible/board/week_calendar.dart';
import 'package:flexible/board/widgets/mini_red_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class BottomDatePicker extends StatefulWidget {
  @override
  _BottomDatePickerState createState() => _BottomDatePickerState();
}

class _BottomDatePickerState extends State<BottomDatePicker> {
  bool showCalendar = false;

  void showCalendarDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => CalendarDialog(
          focusedDay: BlocProvider.of<DailytasksBloc>(context).showDay,
          withTail: true,
          onSelect: (selectedDay) {
            BlocProvider.of<DailytasksBloc>(context)
                .add(DailytasksSetDay(day: selectedDay));
            Navigator.pop(context);
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    String currentDate(DateTime date) =>
        DateFormat('yyyy-LLLL-dd').format(date);

    return BlocBuilder<DailytasksBloc, DailytasksState>(
      builder: (context, state) {
        void onTapRight() {
          BlocProvider.of<DailytasksBloc>(context)
              .add(DailytasksSetDay(day: state.showDay.add(Duration(days: 1))));
        }

        void onTapLeft() {
          BlocProvider.of<DailytasksBloc>(context).add(
              DailytasksSetDay(day: state.showDay.subtract(Duration(days: 1))));
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
              width: 380,
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AnimatedCrossFade(
                      duration: Duration(milliseconds: 200),
                      crossFadeState: showCalendar
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      firstChild: MiniRedButton(
                        text: 'Today',
                        callback: () => onTapToday(),
                      ),
                      secondChild: GestureDetector(
                        onTap: () => onTapLeft(),
                        child: Image.asset(
                          'src/icons/arrow_left.png',
                          width: 32,
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
                      child: Text(
                        currentDate(state.showDay),
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 28,
                            color: Color(0xffF66868)),
                      ),
                    ),
                    AnimatedCrossFade(
                      duration: Duration(milliseconds: 200),
                      crossFadeState: showCalendar
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      firstChild: MiniRedButton(
                        text: 'Go to Date',
                        callback: () => showCalendarDialog(),
                      ),
                      secondChild: GestureDetector(
                        onTap: () => onTapRight(),
                        child: Image.asset(
                          'src/icons/arrow_right.png',
                          width: 32,
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
