// Show dialog with transparent background and month calendar inside
// When click on day calendar is closes
import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarDialog extends StatelessWidget {
  final Function onSelect;
  final DateTime focusedDay;
  final bool withTail;
  final String header;
  const CalendarDialog(
      {required this.onSelect,
      required this.focusedDay,
      this.withTail = false,
      this.header = ''});
  @override
  Widget build(BuildContext context) {
    TextStyle calTextStyle = TextStyle(
      fontSize: 10 * byWithScale(context),
      fontWeight: FontWeight.w400,
      color: Colors.black,
      // height: 0,
    );

    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            // height: 250 * byWithScale(context),
            width: double.maxFinite,
            child: Dialog(
                insetAnimationCurve: Curves.bounceInOut,
                insetAnimationDuration: Duration(milliseconds: 200),
                insetPadding: EdgeInsets.symmetric(horizontal: 8),
                backgroundColor: Colors.transparent,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: EdgeInsets.all(16 * byWithScale(context)),
                    color: Colors.white,
                    child: Column(
                      children: [
                        if (header.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(
                                left: 16 * byWithScale(context),
                                right: 16 * byWithScale(context)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  header,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                                buildCloseButton(context)
                              ],
                            ),
                          ),
                        TableCalendar(
                            onDaySelected: (selectedDay, focusedDay) {
                              onSelect(selectedDay);
                            },
                            selectedDayPredicate: (day) {
                              return isSameDay(focusedDay, day);
                            },
                            rowHeight: 35,
                            headerStyle: HeaderStyle(
                                titleTextStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                                leftChevronIcon: Icon(Icons.chevron_left,
                                    color: Colors.black),
                                rightChevronIcon: Icon(Icons.chevron_right,
                                    color: Colors.black),
                                formatButtonVisible: false,
                                titleCentered: true,
                                headerPadding:
                                    EdgeInsets.symmetric(horizontal: 50)),
                            calendarStyle: CalendarStyle(
                              selectedDecoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.2),
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
                            focusedDay: focusedDay),
                      ],
                    ),
                  ),
                )),
          ),
          withTail
              ? SizedBox(
                  height: 30 * byWithScale(context),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Image.asset('src/tipTail.png'),
                  ),
                )
              : SizedBox(),
          SizedBox(
            height: 45,
          )
        ],
      ),
    );
  }

  Widget buildCloseButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            'src/icons/close.png',
            width: 18 * byWithScale(context),
            fit: BoxFit.fitWidth,
          )
        ],
      ),
    );
  }
}
