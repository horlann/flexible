import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flutter/material.dart';

class MiniRedButton extends StatelessWidget {
  final VoidCallback callback;
  final String text;
  const MiniRedButton({
    Key? key,
    required this.callback,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => callback(),
      child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: 8 * byWithScale(context),
              vertical: 4 * byWithScale(context)),
          decoration: BoxDecoration(
              color: Color(0xffF66868),
              borderRadius: BorderRadius.circular(12)),
          child: Text(text,
              style: TextStyle(
                  fontSize: 10 * byWithScale(context),
                  color: Colors.white,
                  fontWeight: FontWeight.w900))),
    );
  }
}
