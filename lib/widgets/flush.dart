import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

Flushbar showFlush(BuildContext buildContext, String text, bool isProgressive) {
  return Flushbar(
    message: text,
    barBlur: 20,
    mainButton: isProgressive
        ? Padding(
            padding: const EdgeInsets.only(right: 15.0, top: 10, bottom: 10),
            child: CircularProgressIndicator(
              strokeWidth: 5,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : SizedBox(),
    duration: Duration(seconds: 2),
    flushbarPosition: FlushbarPosition.TOP,
    borderRadius: BorderRadius.all(Radius.circular(16)),
    backgroundColor: Color(0xffE24F4F),
    margin: const EdgeInsets.symmetric(horizontal: 11),
    messageText: Center(
        child: Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
    )),
  );
}
