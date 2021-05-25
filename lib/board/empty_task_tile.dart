import 'dart:async';

import 'package:flutter/material.dart';

class EmptyTaskTile extends StatefulWidget {
  @override
  _EmptyTaskTileState createState() => _EmptyTaskTileState();
}

class _EmptyTaskTileState extends State<EmptyTaskTile> {
  DateTime currentTime = DateTime.now();

  void updateCurrentTime() {
    if (this.mounted) {
      Timer(Duration(seconds: 30), () => updateCurrentTime());
      setState(() {
        currentTime = DateTime.now();
      });
    }
  }

  String geTimeString(DateTime date) => date.toString().substring(10, 16);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Stack(
        children: [
          Positioned(
              top: 2,
              child: Text(geTimeString(currentTime),
                  style: TextStyle(
                      color: Color(0xff545353),
                      fontSize: 13,
                      fontWeight: FontWeight.w400))),
          Positioned(
              top: 32,
              child: Text(geTimeString(currentTime.add(Duration(minutes: 5))),
                  style: TextStyle(
                      color: Color(0xff545353),
                      fontSize: 13,
                      fontWeight: FontWeight.w400))),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 59,
              ),
              Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Color(0xffEE7579).withOpacity(0.75),
                          blurRadius: 20,
                          offset: Offset(0, 10))
                    ],
                    color: Color(0xffffffff),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Image.asset(
                    'src/icons/Additional.png',
                    scale: 1.1,
                  )),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      '${geTimeString(currentTime)} - ${geTimeString(currentTime.add(Duration(minutes: 5)))}',
                      style: TextStyle(
                          color: Color(0xff545353),
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      'Clean task',
                      style: TextStyle(
                          color: Color(0xff545353),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.none),
                    ),
                    Text(
                      'Nice sunny day',
                      style: TextStyle(
                          color: Color(0xff545353),
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Color(0xff6E6B6B).withOpacity(0.75),
                        blurRadius: 20,
                        offset: Offset(0, 10))
                  ],
                ),
                child: Image.asset(
                  'src/icons/checkbox_unchecked.png',
                  scale: 1.2,
                ),
              ),
              SizedBox(
                width: 25,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
