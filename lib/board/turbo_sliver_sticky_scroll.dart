import 'package:flexible/board/widgets/adding_tile.dart';
import 'package:flexible/board/widgets/sliver_persistant_header.dart';
import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';

class TurboAnimatedScrollView extends StatefulWidget {
  final List<Widget> childrens;
  const TurboAnimatedScrollView({
    Key? key,
    required this.childrens,
  }) : super(key: key);

  @override
  _TurboAnimatedScrollViewState createState() =>
      _TurboAnimatedScrollViewState();
}

class _TurboAnimatedScrollViewState extends State<TurboAnimatedScrollView> {
  ScrollController scr = ScrollController();
  double topOverscroll = 16;
  double bottomOverscroll = 0;
  double bottomLinePadding = 32;
  late List<Widget> childrensWithoutLast;

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

    // Move to end of list
    // coz sliver are revesed
    // work as shit

    // void movetoStart() {
    //   if (scr.hasClients) {
    //     scr.jumpTo(scr.position.maxScrollExtent);
    //   } else {
    //     Timer(Duration(milliseconds: 1), () => movetoStart());
    //   }
    // }
    // movetoStart();

    updateChildrensWOL();
  }

  // Copy list without last element
  // Last element should shown separately
  updateChildrensWOL() {
    childrensWithoutLast = List.from(widget.childrens);
    childrensWithoutLast.removeLast();
  }

  @override
  void didUpdateWidget(covariant TurboAnimatedScrollView oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateChildrensWOL();
    topOverscroll = 16;
    bottomLinePadding = 32;
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
                      maxExtent: bottomOverscroll + bottomOverscroll,
                      child: SizedBox())),
              // Adding section with last tile
              // grows up when main sliver is fully scrolled
              SliverPersistentHeader(
                  pinned: true,
                  floating: false,
                  delegate: SliverPersisHeader(
                      minExtent: 150,
                      maxExtent: 240,
                      child: Container(
                          child: OverflowBox(
                        alignment: Alignment.topCenter,
                        maxHeight: 260,
                        child: Column(
                          children: [AddingTile(), widget.childrens.last],
                        ),
                      )))),
              // Main sliver
              SliverClip(
                child: SliverList(
                    delegate: SliverChildListDelegate(
                        childrensWithoutLast.reversed.toList())),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
