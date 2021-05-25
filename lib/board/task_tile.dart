import 'dart:async';

import 'package:flutter/material.dart';

class TaskTile extends StatefulWidget {
  final bool completed;
  final String name;
  final DateTime timeStart;
  final DateTime timeEnd;
  TaskTile(
      {this.completed = false,
      this.name = 'Taskname',
      required this.timeStart,
      required this.timeEnd});
  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  DateTime currentTime = DateTime.now();
  late bool completed;

  @override
  void initState() {
    super.initState();
    completed = widget.completed;
  }

  onCheckClicked(BuildContext context) {
    setState(() {
      completed = !completed;
    });
  }

  void updateCurrentTime() {
    if (this.mounted) {
      Timer(Duration(seconds: 30), () => updateCurrentTime());
      setState(() {
        currentTime = DateTime.now();
      });
    }
  }

  String geTimeString(DateTime date) => date.toString().substring(11, 16);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Stack(
        children: [
          Positioned(
              top: 2,
              child: Text(geTimeString(widget.timeStart),
                  style: TextStyle(
                      color: Color(0xff545353),
                      fontSize: 13,
                      fontWeight: FontWeight.w400))),
          Positioned(
              top: 32,
              child: Text(geTimeString(widget.timeEnd),
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
              buildMainIcon(),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: buildTextSection(),
              ),
              buildCheckbox(context),
              SizedBox(
                width: 25,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container buildMainIcon() {
    return Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Color(0xffEE7579).withOpacity(0.75),
                blurRadius: 20,
                offset: Offset(0, 10))
          ],
          color: Color(0xffEE7579),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Image.asset(
          'src/icons/Additional.png',
          scale: 1.1,
        ));
  }

  Column buildTextSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 4,
        ),
        Text(
          '${geTimeString(widget.timeStart)} - ${geTimeString(widget.timeEnd)}',
          style: TextStyle(
              color: Color(0xff545353),
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          widget.name,
          style: TextStyle(
              color: Color(0xff545353),
              fontSize: 18,
              fontWeight: FontWeight.w600,
              decoration:
                  completed ? TextDecoration.lineThrough : TextDecoration.none),
        ),
        Text(
          'Nice sunny day',
          style: TextStyle(
              color: Color(0xff545353),
              fontSize: 14,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  GestureDetector buildCheckbox(BuildContext context) {
    return GestureDetector(
      onTap: () => onCheckClicked(context),
      child: Container(
        margin: EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Color(0xff6E6B6B).withOpacity(0.75),
                blurRadius: 20,
                offset: Offset(0, 10))
          ],
        ),
        child: completed
            ? Image.asset(
                'src/icons/checkbox_checked.png',
                scale: 1.2,
              )
            : Image.asset(
                'src/icons/checkbox_unchecked.png',
                scale: 1.2,
              ),
      ),
    );
  }
}
