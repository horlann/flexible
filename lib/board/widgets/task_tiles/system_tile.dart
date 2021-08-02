import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:invert_colors/invert_colors.dart';

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
    bool isLessThen350() => MediaQuery.of(context).size.width < 350;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          widget.callback.call();
          // setState(() {
          //   showSubButtons = !showSubButtons;
          // });
        },
        child: Container(
          margin: EdgeInsets.only(top: 16),
          child: Stack(
            children: [
              Positioned(
                top: 16,
                child: Text(geTimeString(widget.showTime),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10 * byWithScale(context),
                        fontWeight: FontWeight.w400)),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: isLessThen350() ? 40 : 59,
                  ),
                  buildMainIcon(),
                  // SizedBox(
                  //   width: 20,
                  // ),
                  Expanded(
                    child: buildTextSection(),
                  ),
                  // buildSubButtons(),
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
            //BoxShadow(
            //    color: Color(0xffEE7579), blurRadius: 20, offset: Offset(0, 10))
          ],
          color: Color(0xffE24F4F),
          borderRadius: BorderRadius.circular(25),
        ),
        child: InvertColors(child: widget.image));
  }

  Widget buildTextSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              '${geTimeString(widget.showTime)}',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12 * byWithScale(context),
                  fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              widget.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12 * byWithScale(context),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
