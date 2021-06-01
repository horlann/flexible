import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SystemTile extends StatefulWidget {
  final DateTime showTime;
  final String title;
  final String subtitle;
  final Image image;
  final VoidCallback callback;
  SystemTile({
    Key? key,
    required this.showTime,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.callback,
  }) : super(key: key);
  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<SystemTile> {
  // DateTime currentTime = DateTime.now();
  bool showSubButtons = false;

  String geTimeString(DateTime date) => date.toString().substring(11, 16);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            showSubButtons = !showSubButtons;
          });
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          child: Stack(
            children: [
              Positioned(
                  top: 16,
                  child: Text(geTimeString(widget.showTime),
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
                  buildSubButtons(),
                  SizedBox(
                    width: 25,
                  ),
                ],
              ),
            ],
          ),
        ),
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
                color: Color(0xffEE7579), blurRadius: 20, offset: Offset(0, 10))
          ],
          color: Color(0xffEE7579),
          borderRadius: BorderRadius.circular(25),
        ),
        child: widget.image);
  }

  Column buildTextSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 4,
        ),
        Text(
          '${geTimeString(widget.showTime)}',
          style: TextStyle(
              color: Color(0xff545353),
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          widget.title,
          style: TextStyle(
            color: Color(0xff545353),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          widget.subtitle,
          style: TextStyle(
              color: Color(0xff545353),
              fontSize: 14,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }

  // Button under task
  // Shows when user tap on task tile
  Widget buildSubButtons() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: AnimatedCrossFade(
        duration: Duration(milliseconds: 200),
        crossFadeState: showSubButtons
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        firstChild: SizedBox(),
        secondChild: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            miniButton(
                text: 'Edit Time',
                iconAsset: 'src/icons/edit.png',
                callback: () => widget.callback()),
          ],
        ),
      ),
    );
  }

  Widget miniButton(
      {required String text,
      required String iconAsset,
      VoidCallback? callback}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (callback != null) {
            callback();
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
            color: Color(0xff4077C1).withOpacity(0.75),
            borderRadius: BorderRadius.circular(8),
            // border: Border.all(color: Color(0xffF66868), width: 2),
          ),
          child: Row(
            children: [
              Image.asset(
                iconAsset,
                width: 8,
                height: 8,
                fit: BoxFit.cover,
              ),
              SizedBox(
                width: 2,
              ),
              Text(
                text,
                style: TextStyle(fontSize: 8, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
