import 'package:flutter/material.dart';

class SingleTimeTaskTile extends StatefulWidget {
  final bool completed;
  final String name;
  final DateTime timeStart;
  final DateTime timeEnd;
  SingleTimeTaskTile(
      {this.completed = false,
      this.name = 'Taskname',
      required this.timeStart,
      required this.timeEnd});
  @override
  _SingleTimeTaskTileState createState() => _SingleTimeTaskTileState();
}

class _SingleTimeTaskTileState extends State<SingleTimeTaskTile> {
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

  String timeString({required DateTime time}) =>
      time.toString().substring(11, 16);

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
              timeString(time: widget.timeStart),
              style: TextStyle(color: Color(0xff545353)),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Text(
              timeString(time: widget.timeEnd),
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
                      color: Color(0xffEE7579),
                      borderRadius: BorderRadius.circular(25),
                    ),
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
                child: Wrap(
                  children: [
                    Container(
                      width: double.maxFinite,
                      child: Text(
                        '${timeString(time: widget.timeStart)} - ${timeString(time: widget.timeEnd)}',
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
                        name,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff545353),
                            decoration: completed
                                ? TextDecoration.lineThrough
                                : TextDecoration.none),
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
                            decoration: completed
                                ? TextDecoration.lineThrough
                                : TextDecoration.none),
                      ),
                    ),
                    // !_isEditingText
                    //     ? Text(
                    //         '${timeString(time: widget.timeStart)} - ${timeString(time: widget.timeEnd)}',
                    //         style: TextStyle(
                    //             fontSize: 16, color: Color(0xff545353)),
                    //       )
                    //     : SizedBox(width: 0.0, height: 0.0),
                    // buildTextField()
                  ],
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
