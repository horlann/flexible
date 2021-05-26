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
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
              color: Color(0xffF66868),
              borderRadius: BorderRadius.circular(12)),
          child: Text(text,
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w900))),
    );
  }
}
