import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class GlassmorphicBackgroundShifted extends StatelessWidget {
  const GlassmorphicBackgroundShifted({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
            left: 4 * byWithScale(context), right: 8 * byWithScale(context)),
        child: Container(
            color: Colors.red.withOpacity(0.0),
            child: Stack(
              children: [
                GlassmorphicContainer(
                  margin: EdgeInsets.only(left: 30 * byWithScale(context)),
                  width: double.maxFinite,
                  height: double.maxFinite,
                  borderRadius: 30,
                  blur: 0,
                  border: 0,
                  linearGradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Color(0xFFffffff).withOpacity(0.0),
                        Color(0xfff4f3f3).withOpacity(0.0),
                        Color(0xFFffffff).withOpacity(0.0),
                      ],
                      stops: [
                        0,
                        0.2,
                        1,
                      ]),
                  borderGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFffffff).withOpacity(0.15),
                      Color(0xFFffffff).withOpacity(0.15),
                      Color(0xFFFFFFFF).withOpacity(0.15),
                    ],
                  ),
                ),

                // Children here
                child,
              ],
            )));
  }
}
