import 'package:flexible/board/calendar_dialog.dart';
import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flutter/material.dart';

class DeadLineChooser extends StatelessWidget {
  final DateTime timeStart;
  final DateTime initialDeadline;
  final Function(DateTime date) onChange;
  const DeadLineChooser({
    Key? key,
    required this.timeStart,
    required this.initialDeadline,
    required this.onChange,
  }) : super(key: key);

  Duration get deadlineDuration {
    return initialDeadline.difference(timeStart);
  }

  void showCalendar(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return CalendarDialog(
            focusedDay: DateTime.now(),
            onSelect: (date) {
              Navigator.pop(context);
              print(date);
              onChange(date);
            });
      },
    );
  }

  bool get isCustomDeadline {
    if (deadlineDuration.inDays == 7) {
      return false;
    } else if (deadlineDuration.inDays == 14) {
      return false;
    } else if (deadlineDuration.inDays == 30) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildButton(context,
              text: 'Week',
              active: deadlineDuration.inDays == 7 ? true : false,
              callback: () => onChange(timeStart.add(Duration(days: 7)))),
          buildButton(context,
              text: '2 Weeks',
              active: deadlineDuration.inDays == 14 ? true : false,
              callback: () => onChange(timeStart.add(Duration(days: 14)))),
          buildButton(context,
              text: 'Month',
              active: deadlineDuration.inDays == 30 ? true : false,
              callback: () => onChange(timeStart.add(Duration(days: 30)))),
          buildButton(context,
              active: isCustomDeadline,
              text: isCustomDeadline
                  ? initialDeadline.toString().substring(0, 10)
                  : 'Choose', callback: () {
            // todo
            showCalendar(context);
          }),
        ],
      ),
    );
  }

  ClipRRect buildButton(BuildContext context,
      {required String text, bool active = false, required Function callback}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(byWithScale(context) * 19),
      child: Material(
        color: active ? Color(0xffE24F4F) : Colors.white,
        child: InkWell(
          onTap: () => callback(),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(byWithScale(context) * 19),
                border: Border.all(color: Color(0xffE24F4F), width: 1.5)
            ),
            padding: EdgeInsets.symmetric(
                vertical: 3 * byWithScale(context),
                horizontal: 8 * byWithScale(context)),
            child: Text(text,
                style: TextStyle(
                  fontSize: 10 * byWithScale(context),
                  color: !active ? Color(0xffE24F4F) : Colors.white,
                )),
          ),
        ),
      ),
    );
  }
}
