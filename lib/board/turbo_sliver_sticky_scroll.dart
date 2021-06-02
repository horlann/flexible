import 'package:flexible/board/day_options_editor.dart';
import 'package:flexible/board/widgets/system_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';

import 'package:flexible/board/models/day_options.dart';
import 'package:flexible/board/widgets/adding_tile.dart';
import 'package:flexible/board/widgets/sliver_persistant_header.dart';

class TurboAnimatedScrollView extends StatefulWidget {
  final List<Widget> tasks;
  final DayOptions dayOptions;
  const TurboAnimatedScrollView({
    Key? key,
    required this.tasks,
    required this.dayOptions,
  }) : super(key: key);

  @override
  _TurboAnimatedScrollViewState createState() =>
      _TurboAnimatedScrollViewState();
}

class _TurboAnimatedScrollViewState extends State<TurboAnimatedScrollView> {
  ScrollController scr = ScrollController();
  double topOverscroll = 16;
  double bottomOverscroll = 0;
  double bottomLinePadding = 48;

  @override
  void initState() {
    super.initState();

    // Calc overscrolls from controller
    // uses for revert bottom bouncing and clip timeline
    scr.addListener(() {
      double negDim = scr.position.pixels - scr.position.maxScrollExtent;

      // 16 is padding over first tile
      if (negDim > -16) {
        setState(() {
          topOverscroll = negDim + 16;
        });
      } else {
        setState(() {
          topOverscroll = 0;
        });
      }

      if (scr.offset < 0) {
        setState(() {
          bottomOverscroll = scr.offset.abs();
        });
      } else {
        setState(() {
          bottomOverscroll = 0;
        });
      }

      if (scr.offset < 32) {
        setState(() {
          bottomLinePadding = scr.offset.abs() + 32;
        });
      } else {
        setState(() {
          bottomLinePadding = 0;
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant TurboAnimatedScrollView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tasks.length != widget.tasks.length) {
      topOverscroll = 16;
      bottomLinePadding = 48;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: [
          // This is line under widgets
          // Its size grows with list size
          Positioned.fill(
              child: Padding(
            padding: EdgeInsets.only(
                left: 82, top: topOverscroll, bottom: bottomLinePadding),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Container(width: 3, color: Color(0xff707070))),
          )),
          // The sliver
          CustomScrollView(
            cacheExtent: 200,
            controller: scr,
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            reverse: true,
            slivers: <Widget>[
              // Fake space
              // Need to simulate bouncing like on dafault listview
              SliverPersistentHeader(
                  pinned: false,
                  floating: false,
                  delegate: SliverPersisHeader(
                      minExtent: 0,
                      maxExtent: bottomOverscroll,
                      child: SizedBox())),
              // Good night
              SliverList(
                  delegate: SliverChildListDelegate([
                SystemTile(
                    showTime: widget.dayOptions.goToSleepTime,
                    title: 'Good night',
                    subtitle: 'Sleep well',
                    image: Image.asset(
                      'src/icons/goodnight.png',
                      scale: 1.1,
                    ),
                    callback: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) =>
                                DayOptionsEditor(dayOptions: widget.dayOptions),
                          ));
                    })
              ])),
              // Adding section with last tile
              // grows up when main sliver is fully scrolled
              SliverPersistentHeader(
                  pinned: true,
                  floating: false,
                  delegate: SliverPersisHeader(
                    minExtent: 150,
                    maxExtent: 150,
                    child: AddingTile(),
                  )),
              // Main sliver
              SliverClip(
                child: SliverList(
                    delegate: SliverChildListDelegate(
                        widget.tasks.reversed.toList())),
              ),
              // Good morning
              SliverList(
                  delegate: SliverChildListDelegate([
                SystemTile(
                    showTime: widget.dayOptions.wakeUpTime,
                    title: 'Good morning',
                    subtitle: 'Have a nice day',
                    image: Image.asset(
                      'src/icons/morning.png',
                      scale: 1.1,
                    ),
                    callback: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) =>
                                DayOptionsEditor(dayOptions: widget.dayOptions),
                          ));
                    })
              ])),
            ],
          ),
        ],
      ),
    );
  }
}
