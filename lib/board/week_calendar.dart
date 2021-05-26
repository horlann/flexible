import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

class WeekCalendar extends StatelessWidget {
  const WeekCalendar({
    Key? key,
    required this.showCalendar,
  }) : super(key: key);

  final bool showCalendar;

  @override
  Widget build(BuildContext context) {
    // RepositoryProvider.of<DailytasksBloc>(context);
    TextStyle calTextStyle = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w900,
      color: Color(0xff716D6E),
      height: 0,
    );
    TextStyle daysTextStyle =
        TextStyle(fontSize: 10, color: Color(0xff7D8388), height: 0);

    return AnimatedCrossFade(
      duration: Duration(milliseconds: 300),
      crossFadeState:
          showCalendar ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      firstChild: SizedBox(),
      secondChild: BlocBuilder<DailytasksBloc, DailytasksState>(
        builder: (context, state) {
          return SizedBox(
            // height: 60,
            width: 280,
            child: TableCalendar(
              selectedDayPredicate: (day) {
                return isSameDay(state.showDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                RepositoryProvider.of<DailytasksBloc>(context)
                    .add(DailytasksSetDay(day: selectedDay));
                // setState(() {
                //   _selectedDay = selectedDay;
                //   // _focusedDay = focusedDay;
                // });
              },

              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Color(0xffE24F4F).withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                markerSizeScale: 3,
                isTodayHighlighted: false,
                // todayDecoration: Decor,
                defaultTextStyle: calTextStyle,
                holidayTextStyle: calTextStyle,
                todayTextStyle: calTextStyle,
                weekendTextStyle: calTextStyle,
                outsideTextStyle: calTextStyle,
                disabledTextStyle: calTextStyle,
                rangeEndTextStyle: calTextStyle,
                selectedTextStyle: calTextStyle,
                rangeStartTextStyle: calTextStyle,
                withinRangeTextStyle: calTextStyle,
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: daysTextStyle,
                weekendStyle: daysTextStyle,
              ),
              // dayHitTestBehavior: HitTestBehavior.deferToChild,

              startingDayOfWeek: StartingDayOfWeek.monday,
              rowHeight: 40,
              headerVisible: false,
              calendarFormat: CalendarFormat.week,
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: state.showDay,
            ),
          );
        },
      ),
    );
  }
}
