import 'package:flutter/material.dart';

SnackBar circularSnakbar({required String text}) {
  return SnackBar(
      backgroundColor: Color(0xffE24F4F),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(text),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        ],
      ));
}
