import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flexible/board/models/tasks/task.dart';
import 'package:flexible/board/repository/sqFliteRepository/sqflire_tasks.dart';
import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flexible/weather/bloc/weather_bloc.dart';
import 'package:flexible/weather/openweather_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

class WeekCalendar extends StatefulWidget {
  const WeekCalendar({
    Key? key,
    required this.showCalendar,
  }) : super(key: key);

  final bool showCalendar;

  @override
  _WeekCalendarState createState() => _WeekCalendarState();
}

class _WeekCalendarState extends State<WeekCalendar> {
  late DateTime fday;

  @override
  void initState() {
    super.initState();
    fday = RepositoryProvider.of<DailytasksBloc>(context).state.showDay;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DailytasksBloc, DailytasksState>(
      listener: (context, state) {
        fday = state.showDay;
      },
      listenWhen: (previous, current) {
        return previous.showDay.millisecondsSinceEpoch !=
            current.showDay.millisecondsSinceEpoch;
      },
      builder: (context, state) {
        return !widget.showCalendar
            ? SizedBox()
            : SizedBox(
                // height: 60,
                width: 250 * byWithScale(context),
                // Logic for providing nuber on events on day
                child: BlocBuilder<WeatherBloc, WeatherState>(
                    builder: (contextWeather, stateWeather) {
                  var day;
                  return FutureBuilder(
                      future: RepositoryProvider.of<SqfliteTasksRepo>(context)
                          .tasksByPeriod(
                              from: fday.subtract(Duration(days: 7)),
                              to: fday.add(Duration(days: 7))),
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

                        TextStyle calTextStyle = TextStyle(
                          fontSize: 10 * byWithScale(context),
                          fontWeight: FontWeight.w400,
                          color: stateWeather.daylight == DayLight.dark
                              ? Colors.white
                              : Colors.black,
                          height: 0,
                        );
                        TextStyle weekendTextStyle = TextStyle(
                          fontSize: 10 * byWithScale(context),
                          fontWeight: FontWeight.w600,
                          color: Color(0xffE24F4F),
                          height: 0,
                        );
                        TextStyle daysTextStyle = TextStyle(
                            fontSize: 10,
                            color: stateWeather.daylight == DayLight.dark
                                ? Colors.white
                                : Colors.black,
                            height: 2);
                        TextStyle weekenddTextStyle = TextStyle(
                            fontSize: 10,
                            color: Color(0xffE24F4F),
                            height: 2,
                            fontWeight: FontWeight.w600);
                        TextStyle selectedTextStyle = TextStyle(
                            fontSize: 10,
                            color: stateWeather.daylight == DayLight.dark
                                ? Colors.white
                                : Colors.black,
                            height: 2);

                        return TableCalendar(
                          selectedDayPredicate: (day) {
                            return isSameDay(state.showDay, day);
                          },
                          onDaySelected: (selectedDay, focusedDay) {
                            RepositoryProvider.of<DailytasksBloc>(context)
                                .add(DailytasksSetDay(day: selectedDay));
                            day = selectedDay.weekday;
                          },

                          calendarStyle: CalendarStyle(
                            selectedDecoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0xffE24F4F).withOpacity(0.3),
                                      spreadRadius: 10,
                                      offset: Offset(0, -5))
                                ]),
                            // markerSizeScale: 1,
                            markerDecoration: BoxDecoration(
                              color: Color(0xffE24F4F),
                              shape: BoxShape.circle,
                            ),
                            isTodayHighlighted: false,
//                             todayDecoration:  BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 boxShadow: [
//                                   BoxShadow(
//                                       color: Color(0xffE24F4F),
//                                       spreadRadius: 10,
//                                       offset: Offset(0, -5))
//                                 ]),

                            defaultTextStyle: calTextStyle,
                            holidayTextStyle: calTextStyle,
                            todayTextStyle: calTextStyle,
                            weekendTextStyle: weekendTextStyle,
                            outsideTextStyle: calTextStyle,
                            disabledTextStyle: calTextStyle,
                            rangeEndTextStyle: calTextStyle,
                            selectedTextStyle: calTextStyle.copyWith(
                                color: day == 6
                                    ? Colors.deepOrange
                                    : Colors.white),
                            rangeStartTextStyle: calTextStyle,
                            withinRangeTextStyle: calTextStyle,
                          ),
                          daysOfWeekStyle: DaysOfWeekStyle(
                            weekdayStyle: daysTextStyle,
                            weekendStyle: weekenddTextStyle,
                          ),

                          // dayHitTestBehavior: HitTestBehavior.deferToChild,

                          startingDayOfWeek: StartingDayOfWeek.monday,
                          rowHeight: 40,
                          headerVisible: false,
                          calendarFormat: CalendarFormat.week,
                          firstDay: DateTime.utc(2010, 10, 16),
                          lastDay: DateTime.utc(2030, 3, 14),
                          focusedDay: fday,
                          onPageChanged: (focusedDay) {
                            setState(() {
                              fday = focusedDay;
                            });
                          },
                          eventLoader: (day) {
                            // Mask good morning and good night
                            List events = getEventByDay(day);
                            // print('get ev > $day');
                            return events;
                          },
                        );
                      });
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
