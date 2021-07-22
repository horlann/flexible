import 'package:flutter/material.dart';

class HidableTimeLock extends StatelessWidget {
  const HidableTimeLock(
      {Key? key,
      required this.showLock,
      required this.onTap,
      required this.locked,
      this.color,
      this.size = 22})
      : super(key: key);

  final bool showLock;
  final bool locked;
  final Function onTap;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      crossFadeState:
          showLock ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: Duration(
        milliseconds: 200,
      ),
      firstChild: GestureDetector(
        onTap: () => onTap(),
        child: Container(
          margin: EdgeInsets.only(top: 14, right: 4),
          child: locked
              ? Image.asset(
                  'src/icons/locked.png',
                  width: size,
                  height: size,
                  color: color
                )
              : Image.asset(
                  'src/icons/unlocked.png',
                  width: size,
                  height: size,
                color: color
                ),
        ),
      ),
      secondChild: SizedBox(
        width: 26,
        height: 22,
      ),
    );
  }
}
