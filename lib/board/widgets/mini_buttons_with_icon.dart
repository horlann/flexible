import 'package:flutter/material.dart';

class MiniButtonWithIcon extends StatelessWidget {
  const MiniButtonWithIcon({
    Key? key,
    required this.text,
    required this.color,
    required this.iconAsset,
    required this.callback,
  }) : super(key: key);

  final String text;
  final Color color;
  final String iconAsset;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          callback();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            // border: Border.all(color: Color(0xffF66868), width: 2),
          ),
          child: Row(
            children: [
              Image.asset(
                iconAsset,
                width: 8,
                height: 8,
                fit: BoxFit.cover,
              ),
              SizedBox(
                width: 2,
              ),
              Text(
                text,
                style: TextStyle(fontSize: 8, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
