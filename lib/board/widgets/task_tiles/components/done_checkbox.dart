import 'package:flutter/material.dart';

class DoneCheckbox extends StatelessWidget {
  const DoneCheckbox({
    Key? key,
    required this.onClick,
    required this.checked,
  }) : super(key: key);

  final Function onClick;
  final bool checked;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClick(),
      child: Container(
          margin: EdgeInsets.only(top: 12),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Color(0xff6E6B6B).withOpacity(0.75),
                  blurRadius: 20,
                  offset: Offset(0, 10))
            ],
          ),
          child: AnimatedCrossFade(
              firstCurve: Curves.easeOut,
              secondCurve: Curves.easeIn,
              firstChild: Image.asset(
                'src/icons/checkbox_checked.png',
                scale: 1.2,
              ),
              secondChild: Image.asset(
                'src/icons/checkbox_unchecked.png',
                scale: 1.2,
              ),
              crossFadeState: checked
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: Duration(milliseconds: 300))),
    );
  }
}
