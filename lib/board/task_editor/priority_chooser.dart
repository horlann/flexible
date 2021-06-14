import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flutter/material.dart';

class PriorityChooser extends StatelessWidget {
  final int initialPriority;
  final Function(int priority) onChange;
  const PriorityChooser(
      {Key? key, required this.initialPriority, required this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildButton(context,
            text: '1',
            active: initialPriority == 1,
            callback: () => onChange(1)),
        buildButton(context,
            text: '2',
            active: initialPriority == 2,
            callback: () => onChange(2)),
        buildButton(context,
            text: '3',
            active: initialPriority == 3,
            callback: () => onChange(3))
      ],
    );
  }

  Widget buildButton(BuildContext context,
      {required String text, bool active = false, required Function callback}) {
    return GestureDetector(
      onTap: () => callback(),
      child: Container(
        alignment: Alignment.center,
        height: 25 * byWithScale(context),
        width: 25 * byWithScale(context),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.20), blurRadius: 20)
            ],
            color: active ? Color(0xffE24F4F) : Colors.white,
            borderRadius: BorderRadius.circular(
              12 * byWithScale(context),
            )),
        child: Text(
          text,
          style: TextStyle(
              color: !active ? Colors.black : Colors.white,
              fontSize: 12 * byWithScale(context),
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
