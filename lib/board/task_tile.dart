import 'package:flutter/material.dart';

class TaskTile extends StatefulWidget {
  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Stack(
        children: [
          Positioned(top: 2, child: Text('123')),
          Positioned(top: 32, child: Text('123')),
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
                          color: Color(0xffEE7579).withOpacity(0.5),
                          blurRadius: 10)
                    ],
                    color: Color(0xffEE7579),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Image.asset(
                    'src/icons/Additional.png',
                    scale: 1.1,
                  )),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('21:10 - 21:30'),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'The Task ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Text('Nice sunny day'),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Color(0xff707070).withOpacity(0.5),
                        blurRadius: 10)
                  ],
                ),
                child: Image.asset(
                  'src/icons/checkbox_checked.png',
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
