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
        padding: const EdgeInsets.only(left: 8, right: 16),
        child: Container(
            color: Colors.red.withOpacity(0.0),
            child: Stack(
              children: [
                GlassmorphicContainer(
                  margin: EdgeInsets.only(left: 44),
                  width: double.maxFinite,
                  height: double.maxFinite,
                  borderRadius: 30,
                  blur: 5,
                  border: 2,
                  linearGradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Color(0xFFffffff).withOpacity(0.6),
                        Color(0xfff4f3f3).withOpacity(0.2),
                        Color(0xFFffffff).withOpacity(0.6),
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
