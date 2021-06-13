import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flutter/material.dart';

class SuperTaskDailyDurationSlider extends StatelessWidget {
  final Duration duration;
  final Function(Duration duration) onChange;

  final List<Duration> durations = [
    Duration(minutes: 15),
    Duration(minutes: 30),
    Duration(hours: 1),
    Duration(hours: 2),
    Duration(hours: 3),
    Duration(hours: 4),
    Duration(hours: 5)
  ];

  SuperTaskDailyDurationSlider(
      {required this.duration, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${duration.toString().substring(0, 4)}',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 10 * byWithScale(context)),
              ),
              Text('Edit',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 10 * byWithScale(context)))
            ],
          ),
        ),
        SliderTheme(
          data: SliderThemeData(
            // trackHeight: 2,
            activeTickMarkColor: Colors.black,
            inactiveTickMarkColor: Colors.black,
            // thumbColor: ColorAssets.themeColorMagenta,
            thumbColor: Color(0xffE24F4F),

            activeTrackColor: Color(0xffDDDDDD),
            inactiveTrackColor: Color(0xffDDDDDD),
            trackShape: RectangularSliderTrackShape(),

            // overlayColor: Colors.red.withAlpha(32),
            // overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
            thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: 8 * byWithScale(context)),

            valueIndicatorShape: PaddleSliderValueIndicatorShape(),
            valueIndicatorColor: Colors.redAccent,
            valueIndicatorTextStyle: TextStyle(
              color: Colors.white,
            ),
            trackHeight: 3.0 * byWithScale(context),
          ),
          child: SizedBox(
            height: 30 * byWithScale(context),
            child: Slider(
              divisions: 6,
              max: 6,
              min: 0,
              value: durations.indexOf(duration).toDouble(),
              onChanged: (v) => onChange(durations[v.toInt()]),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              '15min',
              style: TextStyle(fontSize: 8 * byWithScale(context)),
            ),
            Text(
              '30min',
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
              '4h',
              style: TextStyle(fontSize: 8 * byWithScale(context)),
            ),
            Text(
              '5h',
              style: TextStyle(fontSize: 8 * byWithScale(context)),
            )
          ]),
        )
      ],
    );
  }
}
