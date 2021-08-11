import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flexible/utils/adaptive_utils.dart';

class OgTimePicker extends StatefulWidget {
  final DateTime initTime;
  final Function(DateTime time) onChange;
  const OgTimePicker({
    Key? key,
    required this.initTime,
    required this.onChange,
  }) : super(key: key);
  @override
  _OgTimePickerState createState() => _OgTimePickerState();
}

class _OgTimePickerState extends State<OgTimePicker> {
  late PageController _hPontroller;
  late PageController _mPcontroller;
  late int mValue;
  late int hValue;

  @override
  void initState() {
    super.initState();
    _hPontroller = PageController(
        viewportFraction: 0.4, initialPage: 360 + widget.initTime.hour);
    _mPcontroller = PageController(
        viewportFraction: 0.4, initialPage: 360 + widget.initTime.minute);
    hValue = widget.initTime.hour;
    mValue = widget.initTime.minute;
  }

  onChanged() {
    // print(widget.initTime);
    DateTime time = DateUtils.dateOnly(widget.initTime)
        .add(Duration(hours: hValue, minutes: mValue));
    // print(time);
    widget.onChange(time);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40 * byWithScale(context)),
      padding: EdgeInsets.symmetric(vertical: 10 * byWithScale(context)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(
            15 * byWithScale(context),
          ),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              child: Text(
                ":",
                style: TextStyle(fontSize: 20),
              ),
              alignment: Alignment.center,
            ),
          ),
          Row(
            children: [
              // Spacer(
              //   flex: 2,
              // ),
              Flexible(
                child: Container(
                  height: 150,
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollEndNotification) {
                        Timer(Duration(milliseconds: 1), () {
                          _hPontroller.animateToPage(_hPontroller.page!.round(),
                              duration: Duration(milliseconds: 400),
                              curve: Curves.bounceOut);
                        });
                      }
                      return false;
                    },
                    child: PageView.builder(
                      physics: BouncingScrollPhysics(),
                      pageSnapping: false,
                      scrollDirection: Axis.vertical,
                      controller: _hPontroller,
                      allowImplicitScrolling: true,
                      // itemCount: 60,
                      itemBuilder: (context, index) {
                        return Container(
                          // color: Colors.red,
                          padding:
                              EdgeInsets.only(left: 32 * byWithScale(context)),
                          child: Center(
                            child: Text((index % 24).toString().padLeft(2, '0'),
                                style: TextStyle(
                                    color: (hValue == (index % 24))
                                        ? Colors.black
                                        : Colors.grey,
                                    fontSize: 55 / pRatio(context))),
                          ),
                        );
                      },
                      onPageChanged: (value) {
                        setState(() {
                          hValue = value % 24;
                        });
                        onChanged();
                      },
                    ),
                  ),
                ),
              ),
              // Spacer(
              //   flex: 1,
              // ),
              Flexible(
                child: Container(
                  height: 150,
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollEndNotification) {
                        Timer(Duration(milliseconds: 1), () {
                          _mPcontroller.animateToPage(
                              _mPcontroller.page!.round(),
                              duration: Duration(milliseconds: 400),
                              curve: Curves.bounceOut);
                        });
                      }
                      return false;
                    },
                    child: PageView.builder(
                      physics: BouncingScrollPhysics(),
                      pageSnapping: false,
                      scrollDirection: Axis.vertical,
                      controller: _mPcontroller,
                      allowImplicitScrolling: true,
                      // itemCount: 60,
                      itemBuilder: (context, index) {
                        return Container(
                          // color: Colors.red,
                          padding:
                              EdgeInsets.only(right: 32 * byWithScale(context)),
                          child: Center(
                            child: Text((index % 60).toString().padLeft(2, '0'),
                                style: TextStyle(
                                    color: (mValue == (index % 60))
                                        ? Colors.black
                                        : Colors.grey,
                                    fontSize: 55 / pRatio(context))),
                          ),
                        );
                      },
                      onPageChanged: (value) {
                        setState(() {
                          mValue = value % 60;
                        });
                        onChanged();
                      },
                    ),
                  ),
                ),
              ),
              // Spacer(
              //   flex: 2,
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
