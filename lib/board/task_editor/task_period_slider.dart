import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flutter/material.dart';

class TaskPeriodSlider extends StatelessWidget {
  final Duration period;
  final Function(Duration) callback;

  final List<Duration> durations = [
    Duration(minutes: 0),
    Duration(minutes: 5),
    Duration(minutes: 15),
    Duration(minutes: 30),
    Duration(minutes: 45),
    Duration(hours: 1),
    Duration(hours: 2),
    Duration(hours: 3),
    Duration(hours: 4),
    Duration(hours: 5),
  ];

  TaskPeriodSlider({required this.period, required this.callback});

  @override
  Widget build(BuildContext context) {
    //print(period.inHours.toString() + ' vb');
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                period.inHours < 1
                    ? '${period.inMinutes.toString()} minutes'
                    : '${period.inHours.toString()} ${period.inHours == 1 ? "hour" : 'hours'}',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 10 * byWithScale(context)),
              ),
              Text('',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 10 * byWithScale(context)))
            ],
          ),
        ),
        SliderTheme(
          data: SliderThemeData(
            // trackHeight: 2,
            activeTickMarkColor: Colors.white,
            inactiveTickMarkColor: Colors.white,

            //thumbColor: ColorAssets.themeColorMagenta,
            thumbColor: Color(0xffE24F4F),
            tickMarkShape: RoundSliderTickMarkShape(
                tickMarkRadius: 4 * byWithScale(context)),
            activeTrackColor: Color(0xffDDDDDD),
            inactiveTrackColor: Color(0xffDDDDDD),

            trackShape: RectangularSliderTrackShape(),
            // overlayColor: Colors.red.withAlpha(32),
            // overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
            thumbShape: RoundSliderThumbShape(
              enabledThumbRadius: 8 * byWithScale(context),
            ),

            valueIndicatorShape: PaddleSliderValueIndicatorShape(),
            valueIndicatorColor: Colors.redAccent,
            valueIndicatorTextStyle: TextStyle(
              color: Colors.white,
            ),
            trackHeight: 1.0 * byWithScale(context),
          ),
          child: SizedBox(
            height: 30 * byWithScale(context),
            child: Slider(
              max: 9,
              min: 0,
              value: durations.indexOf(period).toDouble(),
              // activeColor: Colors.grey,
              // inactiveColor: Colors.grey,
              onChanged: (v) =>
              {
                print(durations[v.toInt()].toString() + " int"),
                callback(durations[v.toInt()]),
              },
              divisions: 9,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 22, right: 18),
          child:
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              '0 ',
              style: TextStyle(fontSize: 8 * byWithScale(context)),
            ),
            Text(
              '5 ',
              style: TextStyle(fontSize: 8 * byWithScale(context)),
            ),
            Text(
              '15',
              style: TextStyle(fontSize: 8 * byWithScale(context)),
            ),
            Text(
              '30',
              style: TextStyle(fontSize: 8 * byWithScale(context)),
            ),
            Text(
              '45',
              style: TextStyle(fontSize: 8 * byWithScale(context)),
            ),
            Text(
              '1h',
              style: TextStyle(fontSize: 8 * byWithScale(context)),
            ),
            Text(
              '2h',
              style: TextStyle(fontSize: 8 * byWithScale(context)),
            ),
            Text(
              '3h',
              style: TextStyle(fontSize: 8 * byWithScale(context)),
            ),
            Text(
              ' 4h',
              style: TextStyle(fontSize: 8 * byWithScale(context)),
            ),
            Text(
              '5h',
              style: TextStyle(fontSize: 8 * byWithScale(context)),
            ),
          ]),
        )
      ],
    );
  }
}
