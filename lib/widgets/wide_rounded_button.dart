import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flutter/material.dart';

class WideRoundedButton extends StatelessWidget {
  final bool enable;
  final Color textColor;
  final Color enableColor;
  final Color disableColor;
  final Color borderColor;
  final int? fontSizw;
  final Function() callback;
  final String text;
  const WideRoundedButton(
      {Key? key,
      required this.enable,
      required this.textColor,
      required this.enableColor,
      required this.disableColor,
      required this.callback,
      required this.text,
      this.fontSizw,
      this.borderColor = Colors.transparent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(25 * byWithScale(context)),
          child: SizedBox(
            height: 35 * byWithScale(context),
            child: Material(
              color: enable ? enableColor : disableColor,
              child: InkWell(
                onTap: () => enable ? callback() : {},
                child: Center(
                  child: Text(
                    text,
                    style: TextStyle(
                        color: textColor,
                        fontSize: (fontSizw ?? 16.0) * byWithScale(context),
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
                decoration: BoxDecoration(
              border: Border.all(color: borderColor),
                  borderRadius: BorderRadius.circular(25),
            )),
          ),
        ),
      ],
    );
  }
}
