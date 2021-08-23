import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CloseButtonn extends StatelessWidget {
  final VoidCallback callback;

  const CloseButtonn({
    Key? key,
    required this.callback,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
       callback();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: 16 * byWithScale(context),
                right: 16 * byWithScale(context),
                top: 12 * byWithScale(context)),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Icon(
                Icons.close,
                size: 18 * byWithScale(context),
              ),
            ),
          )
        ],
      ),
    );
  }
}
