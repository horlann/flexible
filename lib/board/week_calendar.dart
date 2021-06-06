import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flexible/board/models/task.dart';
import 'package:flexible/board/repository/sqFliteTasksRepository/sqflire_tasks_repo.dart';
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
        TextStyle(fontSize: 10, color: Color(0xff7D8388), height: 2);

    return BlocBuilder<DailytasksBloc, DailytasksState>(
      builder: (context, state) {
        return !showCalendar
            ? SizedBox()
            : SizedBox(
                // height: 60,
                width: 280,
                // Logic for providing nuber on events on day
                child: FutureBuilder(
                    future: RepositoryProvider.of<SqfliteTasksRepo>(context)
                        .tasksByPeriod(
                            from: state.showDay.subtract(Duration(days: 30)),
                            to: state.showDay.add(Duration(days: 30))),
                    builder: (context, AsyncSnapshot<List<Task>> snapshot) {
                      List getEventByDay(DateTime day) {
                        if (snapshot.hasData) {
                          return snapshot.data!
                              .where((element) =>
                                  DateUtils.isSameDay(element.timeStart, day))
                              .toList();
                        }
                        return [];
                      }

                      return TableCalendar(
                        selectedDayPredicate: (day) {
                          return isSameDay(state.showDay, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          RepositoryProvider.of<DailytasksBloc>(context)
                              .add(DailytasksSetDay(day: selectedDay));
                        },

                        calendarStyle: CalendarStyle(
                          selectedDecoration:
                              BoxDecoration(shape: BoxShape.circle, boxShadow: [
                            BoxShadow(
                                color: Color(0xffE24F4F).withOpacity(0.3),
                                spreadRadius: 10,
                                offset: Offset(0, -5))
                          ]),
                          // markerSizeScale: 1,
                          markerDecoration: BoxDecoration(
                            color: Color(0xffE24F4F).withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
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
                        eventLoader: (day) {
                          // Mask good morning and good night
                          List events = getEventByDay(day);
                          return events;
                        },
                      );
                    }),
              );
      },
    );
  }
}

// Round date funcs
// uses for select period
DateTime startOfaDay(DateTime date) => DateUtils.dateOnly(date);
DateTime endOfaDay(DateTime date) =>
    DateUtils.dateOnly(date).add(Duration(days: 1));
