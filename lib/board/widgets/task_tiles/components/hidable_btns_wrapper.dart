// Button under task
// Shows when user tap on task tile
import 'package:flutter/material.dart';

class HidableButtonsWrapper extends StatelessWidget {
  const HidableButtonsWrapper({
    Key? key,
    required this.showSubButtons,
    required this.children,
  }) : super(key: key);

  final bool showSubButtons;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: Duration(milliseconds: 200),
      crossFadeState:
          showSubButtons ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      firstChild: SizedBox(),
      secondChild: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: children,
      ),
    );
  }
}
