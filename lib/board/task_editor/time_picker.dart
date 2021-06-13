import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimePicker extends StatelessWidget {
  const TimePicker({
    required this.timeStart,
    required this.callback,
  });

  final DateTime timeStart;
  final Function(DateTime time) callback;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120 * byWithScale(context),
      child: FittedBox(
        child: SizedBox(
            height: 190,
            child: CupertinoTimerPicker(
                initialTimerDuration:
                    timeStart.difference(DateUtils.dateOnly(timeStart)),
                mode: CupertinoTimerPickerMode.hm,
                onTimerDurationChanged: (v) {
                  callback(DateUtils.dateOnly(timeStart).add(v));
                })),
      ),
    );
  }
}
