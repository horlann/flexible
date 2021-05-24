import 'dart:async';

import 'package:flutter/material.dart';

class EmptyTaskTile extends StatefulWidget {
  @override
  _EmptyTaskTileState createState() => _EmptyTaskTileState();
}

class _EmptyTaskTileState extends State<EmptyTaskTile> {
  DateTime currentTime = DateTime.now();

  String timeString({required DateTime time}) =>
      time.toString().substring(11, 16);

  @override
  void initState() {
    super.initState();
    dutoupdateTime();
  }

  void dutoupdateTime() {
    if (this.mounted) {
      Timer(Duration(seconds: 30), () => dutoupdateTime());

      setState(() {
        currentTime = DateTime.now();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            child: Text(
              timeString(time: currentTime),
              style: TextStyle(color: Color(0xff545353)),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Text(
              timeString(time: currentTime.add(Duration(minutes: 4))),
              style: TextStyle(color: Color(0xff545353)),
            ),
          ),
          Positioned(
            left: 58,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Color(0xff707070).withOpacity(0.5),
                            blurRadius: 10)
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    )),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 120,
              ),
              Expanded(
                child: Wrap(
                  children: [
                    Container(
                      width: double.maxFinite,
                      child: Text(
                        '${timeString(time: currentTime)} - ${timeString(time: currentTime.add(Duration(minutes: 4)))}',
                        style:
                            TextStyle(fontSize: 16, color: Color(0xff545353)),
                      ),
                    ),
                    SizedBox(
                      height: 4,
                      width: 1,
                    ),
                    Container(
                      width: double.maxFinite,
                      child: Text(
                        'New Task',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff545353),
                        ),
                      ),
                    ),
                    Container(
                      width: double.maxFinite,
                      child: Text(
                        'Ultra nice day',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff545353),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Color(0xff707070).withOpacity(0.5),
                        blurRadius: 10)
                  ],
                ),
                child: Image.asset(
                  'src/icons/checkbox_unchecked.png',
                  scale: 1.2,
                ),
              ),
              SizedBox(
                width: 24,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
