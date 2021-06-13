import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flutter/material.dart';

class SuperTaskGlobasDurationSlider extends StatelessWidget {
  final Duration duration;
  final Function(Duration duration) onChange;

  final List<int> hours = [1, 5, 10, 30, 60, 90, 180];

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
                '${duration.inHours.toString()} hours',
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
              value: hours.indexOf(duration.inHours).toDouble(),
              onChanged: (v) => onChange(
                Duration(hours: hours[v.toInt()]),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                  7,
                  (index) => Text(
                        '${hours[index]} h',
                        style: TextStyle(fontSize: 8 * byWithScale(context)),
                      ))),
        )
      ],
    );
  }
}
