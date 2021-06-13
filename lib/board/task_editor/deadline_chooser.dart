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

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildButton(context,
            text: 'Week',
            callback: () => onChange(timeStart.add(Duration(days: 7)))),
        buildButton(context,
            text: '2 Weeks',
            callback: () => onChange(timeStart.add(Duration(days: 14)))),
        buildButton(context,
            text: 'Month',
            callback: () => onChange(timeStart.add(Duration(days: 30)))),
        buildButton(context, text: 'Choose', callback: () {
          // todo
        }),
      ],
    );
  }

  ClipRRect buildButton(BuildContext context,
      {required String text, required Function callback}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () => callback(),
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: 4 * byWithScale(context),
                horizontal: 6 * byWithScale(context)),
            child: Text(text,
                style: TextStyle(fontSize: 10 * byWithScale(context))),
          ),
        ),
      ),
    );
  }
}
