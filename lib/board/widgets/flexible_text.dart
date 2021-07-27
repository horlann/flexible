import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flutter/cupertino.dart';

class FlexibleText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      "Flexible",
      style: TextStyle(
          fontSize: 38 * byWithScale(context),
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        color: Color(0xffFF0000),
      ),
    ));
  }
}
