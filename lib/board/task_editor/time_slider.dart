import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flutter/material.dart';

class TimeSlider extends StatelessWidget {
  final Duration period;
  final Function(Duration) callback;

  const TimeSlider({required this.period, required this.callback});

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
                '${period.inHours.toString()} hours',
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
              max: 4 * byWithScale(context),
              min: 0,
              value: period.inHours.toDouble(),
              // activeColor: Colors.grey,
              // inactiveColor: Colors.grey,
              onChanged: (v) => callback(
                Duration(hours: v.toInt()),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                  9,
                  (index) => Text(
                        '$index h',
                        style: TextStyle(fontSize: 8 * byWithScale(context)),
                      ))),
        )
      ],
    );
  }
}
