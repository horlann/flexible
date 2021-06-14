import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flutter/material.dart';

class TitleInputSection extends StatelessWidget {
  const TitleInputSection({
    required this.initValue,
    required this.onChange,
    required this.child,
  });

  final String initValue;
  final Function(String text) onChange;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          // color: Colors.red,
          border:
              Border(bottom: BorderSide(width: 1, color: Color(0xffB1B1B1)))),
      padding: EdgeInsets.only(bottom: 2),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        textBaseline: TextBaseline.alphabetic,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          child,
          SizedBox(
            width: 4,
          ),
          Expanded(
            child: Container(
                child: SizedBox(
              height: 20 * byWithScale(context),
              child: TextFormField(
                // Change title
                onChanged: (value) {
                  onChange(value);
                },

                decoration: InputDecoration(
                  labelText: 'Task name',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  // contentPadding: EdgeInsets.all(10),
                ),
                initialValue: initValue,
                style: TextStyle(
                    color: Color(0xff373535),
                    fontSize: 12 * byWithScale(context)),
              ),
            )),
          )
        ],
      ),
    );
  }
}
