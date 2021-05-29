import 'package:flutter/material.dart';

class PeriodicTaskTile extends StatefulWidget {
  final bool completed;
  final String name;
  final DateTime timeStart;
  final DateTime timeEnd;
  PeriodicTaskTile(
      {this.completed = false,
      this.name = 'Taskname',
      required this.timeStart,
      required this.timeEnd});
  @override
  _PeriodicTaskTileState createState() => _PeriodicTaskTileState();
}

class _PeriodicTaskTileState extends State<PeriodicTaskTile> {
  late bool completed;
  late String name;
  late TextEditingController _editingController;
  bool _isEditingText = false;

  @override
  void initState() {
    super.initState();
    completed = widget.completed;
    name = widget.name;
    _editingController = TextEditingController(text: name);
  }

  onCheckClicked(BuildContext context) {
    setState(() {
      completed = !completed;
    });
  }

  String timeString(DateTime time) => time.toString().substring(10, 16);

  double timeDiffEquality() {
    DateTime currt = DateTime.now();
    print(currt.timeZoneOffset);

    if (currt.difference(widget.timeStart).inMinutes > 0 &&
        currt.difference(widget.timeEnd).inMinutes < 0) {
      var dif = widget.timeEnd.difference(widget.timeStart).inMinutes;
      var currFromStart = currt.difference(widget.timeStart).inMinutes;

      return currFromStart / dif;
    }

    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Stack(
        children: [
          timeDiffEquality() == 0
              ? SizedBox()
              : Positioned(
                  top: 150 * timeDiffEquality(),
                  child: Text(
                    timeString(DateTime.now()),
                    style: TextStyle(color: Color(0xff545353)),
                  ),
                ),
          Positioned(
            top: 0,
            child: Text(
              timeString(widget.timeStart),
              style: TextStyle(color: Color(0xff545353)),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Text(
              timeString(widget.timeEnd),
              style: TextStyle(color: Color(0xff545353)),
            ),
          ),
          Positioned(
            left: 58,
            child: Stack(
              children: [
                Container(
                  height: 150,
                  width: 50,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Color(0xff707070).withOpacity(0.5),
                            blurRadius: 10)
                      ],
                      color: Color(0xffCAC8C4),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Color(0xff707070))),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    height: 150,
                    width: 50,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ClipRect(
                        child: Align(
                          heightFactor: timeDiffEquality(),
                          child: Container(
                            height: 150,
                            width: 50,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xff707070).withOpacity(0.5),
                                    blurRadius: 10)
                              ],
                              color: Color(0xffEE7579),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                    height: 150,
                    width: 50,
                    child: Image.asset(
                      'src/icons/Additional.png',
                      scale: 1.1,
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
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 8,
                    children: [
                      !_isEditingText
                          ? Text(
                              timeString(widget.timeStart),
                              style: TextStyle(
                                  fontSize: 16, color: Color(0xff545353)),
                            )
                          : SizedBox(width: 0.0, height: 0.0),
                      buildTextField()
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => onCheckClicked(context),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Color(0xff707070).withOpacity(0.5),
                          blurRadius: 10)
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

  Widget buildTextField() {
    if (_isEditingText) {
      return SizedBox(
          child: TextField(
              onSubmitted: (newValue) {
                setState(() {
                  name = newValue;
                  _isEditingText = false;
                });
              },
              autofocus: true,
              controller: _editingController,
              style: TextStyle(
                  height: 0,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff545353),
                  decoration: completed
                      ? TextDecoration.lineThrough
                      : TextDecoration.none),
              decoration: new InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding:
                    EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 0),
              )));
    }

    return InkWell(
      onTap: () {
        setState(() {
          _isEditingText = true;
        });
      },
      child: Text(
        name,
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xff545353),
            decoration:
                completed ? TextDecoration.lineThrough : TextDecoration.none),
      ),
    );
  }
}
