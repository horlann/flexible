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
          ),
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
            child: TextFormField(
              onChanged: (value) {
                onChange(value);
              },
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8 * byWithScale(context)),
                isCollapsed: true,
                isDense: true,
                labelText: 'Type task here',
                labelStyle: TextStyle(color: Colors.grey.withOpacity(0.6)),
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
                  // height: 2,
                  color: Color(0xff373535),
                  fontSize: 12 * byWithScale(context)),
            ),
          )
        ],
      ),
    );
  }
}
