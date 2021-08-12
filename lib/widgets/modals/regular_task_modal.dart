import 'package:flexible/board/models/tasks/task.dart';
import 'package:flexible/board/widgets/task_tiles/components/hidable_lock.dart';
import 'package:flexible/subscription/bloc/subscribe_bloc.dart';
import 'package:flexible/utils/colors.dart';
import 'package:flexible/utils/triangle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegularTaskModal extends StatefulWidget {
  final Task task;
  final Function onEditTap;
  final Function onLockTap;
  final Function onCopyTap;
  final double topPadding;

  RegularTaskModal(this.task, this.topPadding, this.onEditTap, this.onLockTap,
      this.onCopyTap);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<RegularTaskModal> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );
  late Task task;
  bool copyButtonHold = false;
  bool editButtonHold = false;

  @override
  initState() {
    super.initState();
    task = widget.task;
    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var data = MediaQuery.of(context);
    return GestureDetector(
        onTap: () async {
         
          _controller.reverse().then((value) => Navigator.pop(context));
        },
        child: Container(
            color: Colors.transparent,
            height: -63 +
                data.size.height -
                data.viewInsets.bottom -
                data.viewInsets.top -
                data.padding.top -
                data.padding.bottom -
                data.viewPadding.bottom -
                data.viewPadding.top,
            width: data.size.width,
            child: GestureDetector(
                child: Stack(children: [
              Positioned(
                  left: 0,
                  right: 0,
                  top: widget.topPadding,
                  child: ScaleTransition(
                    scale: _animation,
                    child: Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(width: 1, height: 1),
                            Container(
                                decoration:
                                    BoxDecoration(boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Color.fromRGBO(235, 5, 15, .16),
                                      blurRadius: 22,
                                      spreadRadius: 1)
                                ]),
                                child: Column(children: [
                                  CustomPaint(
                                      painter: TrianglePainter(
                                          strokeColor: Colors.white,
                                          strokeWidth: 10,
                                          paintingStyle: PaintingStyle.fill),
                                      child: Container(height: 15, width: 20)),
                                  Container(
                                      height: 52,
                                      //width: 256,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                                onTapCancel: () {
                                                  setState(() =>
                                                      editButtonHold = false);
                                                },
                                                onTapUp: (d) {
                                                  setState(() =>
                                                      editButtonHold = false);
                                                },
                                                onTapDown: (d) {
                                                  setState(() =>
                                                      editButtonHold = true);
                                                },
                                                child: Material(
                                                    animationDuration: Duration(
                                                        milliseconds: 250),
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(8)),
                                                    child: InkWell(
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(8)),
                                                        splashColor: redMain,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        child: Container(
                                                            height: 52,
                                                            width: 100,
                                                            child: Center(
                                                                child: Text(
                                                                    "Edit",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            25,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontFamily:
                                                                            "Mikado",
                                                                        color: editButtonHold == true
                                                                            ? Colors.white
                                                                            : redMain)))),
                                                        onTap: () async {
                                                          Navigator.pop(
                                                              context);
                                                          await widget.onEditTap
                                                              .call();
                                                        }))),
                                            Builder(builder:
                                                (BuildContext context) {
                                              if (BlocProvider.of<
                                                      SubscribeBloc>(context)
                                                  .state is Subscribed) {
                                                return Wrap(
                                                  children: [
                                                    Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10),
                                                        child: HidableTimeLock(
                                                            locked:
                                                                task.timeLock,
                                                            onTap: () async {
                                                              setState(() {
                                                                task = task.copyWith(
                                                                    timeLock: !task
                                                                        .timeLock);
                                                              });
                                                              // Navigator.pop(
                                                              //     context);
                                                              await widget
                                                                  .onLockTap
                                                                  .call();
                                                            },
                                                            showLock: true,
                                                            color: redMain,
                                                            size: 25)),
                                                    GestureDetector(
                                                        onTapCancel: () {
                                                          setState(() =>
                                                              copyButtonHold =
                                                                  false);
                                                        },
                                                        onTapUp: (d) {
                                                          setState(() =>
                                                              copyButtonHold =
                                                                  false);
                                                        },
                                                        onTapDown: (d) {
                                                          setState(() =>
                                                              copyButtonHold =
                                                                  true);
                                                        },
                                                        child: Material(
                                                            animationDuration:
                                                                Duration(
                                                                    milliseconds:
                                                                        250),
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        8)),
                                                            child: InkWell(
                                                                borderRadius:
                                                                    BorderRadius.all(
                                                                        Radius.circular(
                                                                            8)),
                                                                splashColor:
                                                                    redMain,
                                                                highlightColor:
                                                                    Colors
                                                                        .transparent,
                                                                child: Container(
                                                                    height: 52,
                                                                    width: 100,
                                                                    child: Center(
                                                                        child: Text(
                                                                            "Copy",
                                                                            style: TextStyle(
                                                                                fontSize: 25,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontFamily: "Mikado",
                                                                                color: copyButtonHold == true ? Colors.white : redMain)))),
                                                                onTap: () async {
                                                                  Navigator.pop(
                                                                      context);
                                                                  await widget
                                                                      .onCopyTap
                                                                      .call();
                                                                })))
                                                  ],
                                                );
                                              } else {
                                                return Container();
                                              }
                                            }),
                                          ]))
                                ])),
                            Container(width: 1, height: 1)
                          ]),
                    ),
                  ))
            ]))));
  }
}
