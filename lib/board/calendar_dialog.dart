// Show dialog with transparent background and month calendar inside
// When click on day calendar is closes
import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextStyle calTextStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Colors.white,
      // height: 0,
    );

    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 330,
            width: double.maxFinite,
            child: Dialog(
                insetAnimationCurve: Curves.bounceInOut,
                insetAnimationDuration: Duration(milliseconds: 200),
                insetPadding: EdgeInsets.symmetric(horizontal: 8),
                backgroundColor: Colors.transparent,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    color: Color(0xffF66868),
                    child: TableCalendar(
                      onDaySelected: (selectedDay, focusedDay) {
                        BlocProvider.of<DailytasksBloc>(context)
                            .add(DailytasksSetDay(day: selectedDay));
                        Navigator.pop(context);
                      },
                      selectedDayPredicate: (day) {
                        return isSameDay(
                            BlocProvider.of<DailytasksBloc>(context).showDay,
                            day);
                      },
                      rowHeight: 35,
                      headerStyle: HeaderStyle(
                          titleTextStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          leftChevronIcon:
                              Icon(Icons.chevron_left, color: Colors.white),
                          rightChevronIcon:
                              Icon(Icons.chevron_right, color: Colors.white),
                          formatButtonVisible: false,
                          titleCentered: true,
                          headerPadding: EdgeInsets.symmetric(horizontal: 50)),
                      calendarStyle: CalendarStyle(
                        selectedDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.5),
                        ),
                        isTodayHighlighted: false,
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
                        weekdayStyle: calTextStyle,
                        weekendStyle: calTextStyle,
                      ),
                      calendarFormat: CalendarFormat.month,
                      firstDay: DateTime.utc(2010, 10, 16),
                      lastDay: DateTime.utc(2030, 3, 14),
                      focusedDay:
                          BlocProvider.of<DailytasksBloc>(context).showDay,
                    ),
                  ),
                )),
          ),
          SizedBox(
            height: 40,
            child: Align(
              alignment: Alignment.topRight,
              child: Image.asset('src/tipTail.png'),
            ),
          ),
          SizedBox(
            height: 45,
          )
        ],
      ),
    );
  }
}
