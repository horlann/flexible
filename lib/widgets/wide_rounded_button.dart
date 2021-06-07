import 'package:flutter/material.dart';

class WideRoundedButton extends StatelessWidget {
  final bool enable;
  final Color textColor;
  final Color enableColor;
  final Color disableColor;
  final Function() callback;
  final String text;
  const WideRoundedButton({
    Key? key,
    required this.enable,
    required this.textColor,
    required this.enableColor,
    required this.disableColor,
    required this.callback,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: SizedBox(
        height: 40,
        child: Material(
          color: enable ? enableColor : disableColor,
          child: InkWell(
            onTap: () => enable ? callback() : {},
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
