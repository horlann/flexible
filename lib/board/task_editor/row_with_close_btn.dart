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
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 16),
            child: Image.asset(
              'src/icons/close.png',
              width: 24,
              fit: BoxFit.fitWidth,
            ),
          )
        ],
      ),
    );
  }
}
