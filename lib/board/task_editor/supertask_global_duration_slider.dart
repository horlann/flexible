import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class SuperTaskGlobasDurationSlider extends StatelessWidget {
  int value = 0;
  final Duration duration;
  final Function(Duration duration) onChange;

  final List<Duration> durations = [
    Duration(minutes: 30),
    Duration(hours: 1),
    Duration(hours: 2),
    Duration(hours: 3),
    Duration(hours: 4),
    Duration(hours: 5),
    Duration(hours: 6),
    Duration(hours: 7),
    Duration(hours: 8),
    Duration(hours: 9),
    // Duration(hours: 10)
  ];

  SuperTaskGlobasDurationSlider(
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
                duration.inHours < 1
                    ? '${duration.inMinutes.toString()} minutes'
                    : '${duration.inHours.toString()} ${duration.inHours == 1 ? "hour" : 'hours'}',
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
//        SfSliderTheme(
//          child: SfSlider(
//            showDividers: false,
//            max: 6,
//            min: 0,
//            value: hours.indexOf(duration.inHours).toDouble(),
//            interval: 20,
//            showTicks: false,
//            showLabels: false,
//            enableTooltip: false,
//            minorTicksPerInterval: 1,
//            onChanged: (value) {
//              onChange(Duration(hours: hours[value.toInt()]),);
//            },
//          ),
//        ),
        SliderTheme(
          data: SliderThemeData(
            // trackHeight: 2,
            activeTickMarkColor: Colors.white,
            inactiveTickMarkColor: Colors.white,
            // thumbColor: ColorAssets.themeColorMagenta,
            thumbColor: Color(0xffE24F4F),
            tickMarkShape: RoundSliderTickMarkShape(
                tickMarkRadius: 4 * byWithScale(context)),

            activeTrackColor: Color(0xffDDDDDD),
            inactiveTrackColor: Colors.green,
            trackShape: RectangularSliderTrackShape(),
            // overlayColor: Colors.red.withAlpha(32),
            // overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
            thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: 8 * byWithScale(context),
                disabledThumbRadius: 10),
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
              inactiveColor: Colors.white,
              divisions: 9,
              max: 9,
              min: 0,
              value: durations.indexOf(duration).toDouble(),
              //value: 1,
              onChanged: (v) => onChange(durations[v.toInt()]),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 22, right: 16),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              '30m',
              style: TextStyle(fontSize: 8 * byWithScale(context)),
            ),
            Text(
              '1h  ',
              style: TextStyle(fontSize: 8 * byWithScale(context)),
            ),
            Text(
              '2h  ',
              style: TextStyle(fontSize: 8 * byWithScale(context)),
            ),
            Text(
              '3h  ',
              style: TextStyle(fontSize: 8 * byWithScale(context)),
            ),
            Text(
              '4h  ',
              style: TextStyle(fontSize: 8 * byWithScale(context)),
            ),
            Text(
              '5h  ',
              style: TextStyle(fontSize: 8 * byWithScale(context)),
            ),
            Text(
              '6h  ',
              style: TextStyle(fontSize: 8 * byWithScale(context)),
            ),
            Text(
              '7h ',
              style: TextStyle(fontSize: 8 * byWithScale(context)),
            ),
            Text(
              '8h ',
              style: TextStyle(fontSize: 8 * byWithScale(context)),
            ),
            Text(
              '9h ',
              style: TextStyle(fontSize: 8 * byWithScale(context)),
            ),
          ]),
        )
      ],
    );
  }
}
