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
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
              ),
              Text('Edit',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))
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

            valueIndicatorShape: PaddleSliderValueIndicatorShape(),
            valueIndicatorColor: Colors.redAccent,
            valueIndicatorTextStyle: TextStyle(
              color: Colors.white,
            ),
            trackHeight: 6.0,
          ),
          child: Slider(
            max: 8,
            min: 0,
            value: period.inHours.toDouble(),
            // activeColor: Colors.grey,
            // inactiveColor: Colors.grey,
            onChanged: (v) => callback(
              Duration(hours: v.toInt()),
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
                        style: TextStyle(fontSize: 12),
                      ))),
        )
      ],
    );
  }
}
