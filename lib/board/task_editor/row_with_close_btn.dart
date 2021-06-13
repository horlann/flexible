import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flutter/material.dart';

class RowWithCloseBtn extends StatelessWidget {
  const RowWithCloseBtn({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: 16 * byWithScale(context),
                right: 16 * byWithScale(context),
                top: 12 * byWithScale(context)),
            child: Image.asset(
              'src/icons/close.png',
              width: 20 * byWithScale(context),
              fit: BoxFit.fitWidth,
            ),
          )
        ],
      ),
    );
  }
}
