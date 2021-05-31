import 'dart:math';
import 'dart:ui';

import 'package:flexible/board/widgets/glassmorphic_bg_shifted.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glassmorphism/glassmorphism.dart';

import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flexible/board/models/task.dart';
import 'package:flexible/board/sliver_persistant_header.dart';
import 'package:flexible/board/widgets/empty_task_tile.dart';
import 'package:flexible/board/widgets/periodic_task_tile..dart';
import 'package:flexible/board/widgets/task_tile.dart';

class Board extends StatefulWidget {
  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  // Uses for count new tasks
  int taskCount = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GlassmorphicBackgroundShifted(
        child: BlocBuilder<DailytasksBloc, DailytasksState>(
      builder: (context, state) {
        if (state is DailytasksCommon) {
          List<Widget> tasks = state.tasks.map((e) {
            if (e.period.inMilliseconds == 0) {
              return TaskTile(task: e);
            } else {
              return PeriodicTaskTile(task: e);
            }
          }).toList();
          return TurboAnimatedScrollView(
            childrens: tasks,
          );
        }
        // to do loading
        return SizedBox();
      },
    ));
  }

  // Show empty tile with text and button underneeth
}

class AddingTile extends StatefulWidget {
  @override
  _AddingTileState createState() => _AddingTileState();
}

class _AddingTileState extends State<AddingTile> {
  int taskCount = 0;
  addNewTask(BuildContext context) {
    DateTime dayForAdd = BlocProvider.of<DailytasksBloc>(context).state.showDay;
    var newtask = Task(
      uuid: null,
      isDone: false,
      title: 'TheTask ${++taskCount}',
      subtitle: 'Nice ${taskCount}day',
      // add task to showed date with current time
      timeStart: DateUtils.dateOnly(dayForAdd).add(Duration(
          hours: DateTime.now().hour, minutes: DateTime.now().minute - 5)),
      period: Duration(),
      isDonable: true,
      // generate random color
      color: Color.fromRGBO(Random().nextInt(256), Random().nextInt(256),
          Random().nextInt(256), 1),
    );

    BlocProvider.of<DailytasksBloc>(context)
        .add(DailytasksAddTask(task: newtask));
  }

  addBunchOfTasks(BuildContext context) {
    DateTime dayForAdd = BlocProvider.of<DailytasksBloc>(context).state.showDay;

    var newtask2 = Task(
      uuid: null,
      isDone: false,
      title: 'Demo task ${++taskCount}',
      subtitle: 'Nice turbo day',
      // add task to showed date with current time
      timeStart: DateUtils.dateOnly(dayForAdd).add(Duration(
          hours: DateTime.now().hour, minutes: DateTime.now().minute - 25)),
      period: Duration(),
      isDonable: true,
      // generate random color
      color: Color.fromRGBO(Random().nextInt(256), Random().nextInt(256),
          Random().nextInt(256), 1),
    );

    BlocProvider.of<DailytasksBloc>(context)
        .add(DailytasksAddTask(task: newtask2));

    var newtask3 = Task(
      uuid: null,
      isDone: false,
      title: 'Duration task',
      subtitle: 'Happy birthday',
      // add task to showed date with current time
      timeStart: DateUtils.dateOnly(dayForAdd).add(Duration(
          hours: DateTime.now().hour, minutes: DateTime.now().minute - 20)),
      period: Duration(hours: 1),
      isDonable: true,
      // generate random color
      color: Color.fromRGBO(Random().nextInt(256), Random().nextInt(256),
          Random().nextInt(256), 1),
    );

    BlocProvider.of<DailytasksBloc>(context)
        .add(DailytasksAddTask(task: newtask3));

    var newtask4 = Task(
      uuid: null,
      isDone: true,
      title: 'Finished task',
      subtitle: 'Ultra bright day',
      // add task to showed date with current time
      timeStart: DateUtils.dateOnly(dayForAdd).add(Duration(
          hours: DateTime.now().hour, minutes: DateTime.now().minute - 10)),
      period: Duration(),
      isDonable: true,
      // generate random color
      color: Color.fromRGBO(Random().nextInt(256), Random().nextInt(256),
          Random().nextInt(256), 1),
    );

    BlocProvider.of<DailytasksBloc>(context)
        .add(DailytasksAddTask(task: newtask4));

    var newtask5 = Task(
      uuid: null,
      isDone: false,
      title: 'Forwarded task',
      subtitle: 'Nice may day',
      // add task to showed date with current time
      timeStart:
          DateUtils.dateOnly(dayForAdd).add(Duration(hours: 21, minutes: 58)),
      period: Duration(),
      isDonable: true,
      // generate random color
      color: Color.fromRGBO(Random().nextInt(256), Random().nextInt(256),
          Random().nextInt(256), 1),
    );

    BlocProvider.of<DailytasksBloc>(context)
        .add(DailytasksAddTask(task: newtask5));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Positioned(
              left: 82,
              top: 40,
              child: Container(
                height: 3,
                width: 30,
                color: Color(0xff707070),
              ),
            ),
            Positioned(
              left: 80,
              top: 38,
              child: Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                    color: Color(0xffEE7579),
                    borderRadius: BorderRadius.circular(4)),
              ),
            ),
            Positioned(
              left: 115,
              top: 30,
              child: Text(
                'What else you have to do?',
                style: TextStyle(color: Color(0xff545353), fontSize: 18),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 50, left: 32),
              clipBehavior: Clip.none,
              height: 120,
              width: double.maxFinite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () => addNewTask(context),
                    onLongPressEnd: (v) => addBunchOfTasks(context),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xffEE7579).withOpacity(0.75),
                              blurRadius: 20,
                              offset: Offset(-10, 10))
                        ],
                      ),
                      child: Image.asset(
                        'src/icons/plus_btn.png',
                        scale: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

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
  double topOverscroll = 0;
  double bottomOverscroll = 0;

  @override
  void initState() {
    super.initState();
    scr.addListener(() {
      // Calc top overscroll in pixelds
      // uses with bouce scroll
      double negDim = scr.position.pixels - scr.position.maxScrollExtent;

      // 16 is padding over first tile
      if (negDim > -16) {
        setState(() {
          topOverscroll = negDim + 16;
        });
      }

      if (scr.offset < 0) {
        setState(() {
          bottomOverscroll = scr.offset.abs();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(bottomOverscroll);
    return SizedBox(
      // physics: BouncingScrollPhysics(),
      child: Stack(
        children: [
          // THis is line under widgets
          // Its size grow with list size
          Positioned.fill(
              child: Padding(
            padding: EdgeInsets.only(left: 82, top: topOverscroll, bottom: 0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Container(width: 3, color: Color(0xff707070))),
          )),

          // NestedScrollView(
          //   headerSliverBuilder:
          //       (BuildContext context, bool innerBoxIsScrolled) {
          //     // These are the slivers that show up in the "outer" scroll view.
          //     return <Widget>[
          //       SliverOverlapAbsorber(
          //         // This widget takes the overlapping behavior of the SliverAppBar,
          //         // and redirects it to the SliverOverlapInjector below. If it is
          //         // missing, then it is possible for the nested "inner" scroll view
          //         // below to end up under the SliverAppBar even when the inner
          //         // scroll view thinks it has not been scrolled.
          //         // This is not necessary if the "headerSliverBuilder" only builds
          //         // widgets that do not overlap the next sliver.
          //         handle:
          //             NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          //         sliver: SliverAppBar(
          //           title: const Text(
          //               'Books'), // This is the title in the app bar.
          //           pinned: true,
          //           expandedHeight: 150.0,
          //           backgroundColor: Colors.transparent,
          //           // The "forceElevated" property causes the SliverAppBar to show
          //           // a shadow. The "innerBoxIsScrolled" parameter is true when the
          //           // inner scroll view is scrolled beyond its "zero" point, i.e.
          //           // when it appears to be scrolled below the SliverAppBar.
          //           // Without this, there are cases where the shadow would appear
          //           // or not appear inappropriately, because the SliverAppBar is
          //           // not actually aware of the precise position of the inner
          //           // scroll views.
          //           // forceElevated: innerBoxIsScrolled,
          //         ),
          //       ),
          //     ];
          //   },
          //   body: Builder(
          //     // This Builder is needed to provide a BuildContext that is
          //     // "inside" the NestedScrollView, so that
          //     // sliverOverlapAbsorberHandleFor() can find the
          //     // NestedScrollView.
          //     builder: (BuildContext context) {
          //       return CustomScrollView(
          //         // The "controller" and "primary" members should be left
          //         // unset, so that the NestedScrollView can control this
          //         // inner scroll view.
          //         // If the "controller" property is set, then this scroll
          //         // view will not be associated with the NestedScrollView.
          //         // The PageStorageKey should be unique to this ScrollView;
          //         // it allows the list to remember its scroll position when
          //         // the tab view is not on the screen.

          //         slivers: <Widget>[
          //           SliverOverlapInjector(
          //             // This is the flip side of the SliverOverlapAbsorber
          //             // above.
          //             handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
          //                 context),
          //           ),
          //           SliverPadding(
          //             padding: const EdgeInsets.all(8.0),
          //             // In this example, the inner scroll view has
          //             // fixed-height list items, hence the use of
          //             // SliverFixedExtentList. However, one could use any
          //             // sliver widget here, e.g. SliverList or SliverGrid.
          //             sliver: SliverFixedExtentList(
          //               // The items in this example are fixed to 48 pixels
          //               // high. This matches the Material Design spec for
          //               // ListTile widgets.
          //               itemExtent: 48.0,
          //               delegate: SliverChildBuilderDelegate(
          //                 (BuildContext context, int index) {
          //                   // This builder is called for each child.
          //                   // In this example, we just number each list item.
          //                   return ListTile(
          //                     title: Text('Item $index'),
          //                   );
          //                 },
          //                 // The childCount of the SliverChildBuilderDelegate
          //                 // specifies how many children this inner list
          //                 // has. In this example, each tab has a list of
          //                 // exactly 30 items, but this is arbitrary.
          //                 childCount: 30,
          //               ),
          //             ),
          //           ),
          //         ],
          //       );
          //     },
          //   ),
          // )

          CustomScrollView(
            cacheExtent: 200,
            controller: scr,
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            reverse: true,
            slivers: <Widget>[
              SliverPersistentHeader(
                  pinned: false,
                  floating: false,
                  delegate: SliverPersisHeader(
                      minExtent: 0,
                      maxExtent: bottomOverscroll + bottomOverscroll,
                      child: SizedBox())),
              SliverPersistentHeader(
                  pinned: true,
                  floating: false,
                  delegate: SliverPersisHeader(
                      minExtent: 180, maxExtent: 240, child: AddingTile())),
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                (context, n) {
                  return widget.childrens[n];
                },
                childCount: widget.childrens.length,
              ))
              // SliverOverlapInjector(handle: handle)
            ],
          ),
        ],
      ),
    );
  }
}
