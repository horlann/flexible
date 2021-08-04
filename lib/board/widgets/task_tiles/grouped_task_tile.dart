import 'dart:async';
import 'dart:typed_data';

import 'package:flexible/board/widgets/task_tiles/components/cached_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:invert_colors/invert_colors.dart';

import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flexible/board/copy_task_dialog.dart';
import 'package:flexible/board/models/tasks/regular_taks.dart';
import 'package:flexible/board/models/tasks/task.dart';
import 'package:flexible/board/repository/image_repo_mock.dart';
import 'package:flexible/board/task_editor/task_editor.dart';
import 'package:flexible/board/widgets/task_tiles/components/done_checkbox.dart';
import 'package:flexible/board/widgets/task_tiles/components/hidable_btns_wrapper.dart';
import 'package:flexible/board/widgets/task_tiles/components/hidable_lock.dart';
import 'package:flexible/board/widgets/task_tiles/components/mini_buttons_with_icon.dart';
import 'package:flexible/subscription/bloc/subscribe_bloc.dart';
import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flexible/utils/modal.dart';
import 'package:flexible/widgets/modals/regular_task_modal.dart';

class GroupedTaskTile extends StatefulWidget {
  final List<Task> tasks;
  GroupedTaskTile({required this.tasks});
  @override
  _GroupedTaskTileState createState() => _GroupedTaskTileState();
}

class _GroupedTaskTileState extends State<GroupedTaskTile> {
  @override
  void initState() {
    super.initState();
    updateUi();
  }

  // Start autoupdate cycle
  // Uses for correct time showing
  // Auto close if widget disposed
  updateUi() {
    if (this.mounted) {
      setState(() {});
      Timer(Duration(seconds: 10), () => updateUi());
    }
  }

  String geTimeString(DateTime date) => date.toString().substring(11, 16);

  bool isUnSubscribed() =>
      (BlocProvider.of<SubscribeBloc>(context).state is! Subscribed);

  DateTime timeStart() => widget.tasks.first.timeStart;
  DateTime timeEnd() =>
      widget.tasks.fold(timeStart(), (previousValue, element) {
        if (previousValue.millisecondsSinceEpoch <
            element.timeStart.add(element.period).millisecondsSinceEpoch) {
          return element.timeStart.add(element.period);
        } else {
          return previousValue;
        }
      });

  // Calc differense between current time and task period
  double timeDiffEquality() {
    DateTime currt = DateTime.now();
    if (currt.difference(timeStart()).inMinutes > 0) {
      var dif = timeEnd().difference(timeStart()).inMinutes;
      var currFromStart = currt.difference(timeStart()).inMinutes;
      return currFromStart / dif;
    }

    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    bool isLessThen350() => MediaQuery.of(context).size.width < 350;
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 16),
        child: Stack(
          children: [
            Positioned(
                top: 2,
                child: Text(geTimeString(timeStart()),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10 * byWithScale(context),
                        fontWeight: FontWeight.w400))),
            timeDiffEquality() > 1
                ? SizedBox()
                : (timeDiffEquality() == 0
                    ? SizedBox()
                    : Positioned(
                        top: (110 * timeDiffEquality()) + 12,
                        child: Text(
                          geTimeString(DateTime.now()),
                          style: TextStyle(
                              fontSize: 10 * byWithScale(context),
                              color: Colors.white),
                        ),
                      )),
            Positioned(
                bottom: 0,
                child: Text(geTimeString(timeEnd()),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10 * byWithScale(context),
                        fontWeight: FontWeight.w400))),
            // Row(
            //   children: [
            //     SizedBox(
            //       width: isLessThen350() ? 40 : 59,
            //     ),
            //     iconsLayerWithMovement(),
            //     SizedBox(
            //       width: 20,
            //     ),
            //     Expanded(
            //       child: Column(
            //           children: widget.tasks
            //               .map((e) => TileBody(
            //                   task: e,
            //                   isFirst: widget.tasks.first == e,
            //                   isLast: widget.tasks.last == e))
            //               .toList()),
            //     ),
            //   ],
            // ),
            Column(
                children: widget.tasks
                    .map((e) => TileBody(
                        task: e,
                        isFirst: widget.tasks.first == e,
                        isLast: widget.tasks.last == e))
                    .toList())
          ],
        ),
      ),
    );
  }

  Widget iconsLayerWithMovement() {
    double height = widget.tasks.length * 110;
    Duration timerange = timeEnd().difference(timeStart());

    DateTime date = DateTime.fromMillisecondsSinceEpoch(1628095968662);
    print(date);

    Widget donedOverlay() {
      double offset = 0;
      double kSize = 0;
      Color color = Colors.red;

      bool finded = false;
      widget.tasks.forEach((element) {
        if (!finded && element.isDone == false) {
          var timerange = timeEnd().difference(timeStart());
          // print(timerange);
          var offsetH = element.timeStart.difference(timeStart());
          // print(offsetH)
          offset = height * (offsetH.inMinutes / timerange.inMinutes);
          // print(offset);
          var tDiff = date.difference(timeStart());
          // print(tDiff);
          var preKSize =
              (height * (tDiff.inMinutes / timerange.inMinutes)) - offset;
          // print(kSize);
          kSize = preKSize < 0 ? 0 : preKSize;
          finded = true;
          color = element.color;
        }
      });

      return buildColorLayer(height: kSize, offset: offset, color: color);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Stack(
        children: [
          // Bottom Layer
          Container(
            height: height,
            width: 50,
            decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10)],
              color: Color(0xffCAC8C4),
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          ...widget.tasks.map((e) {
            // print(timerange);
            var offsetH = e.timeStart.difference(timeStart());
            // print(offsetH)
            double offset = height * (offsetH.inMinutes / timerange.inMinutes);
            // print(offset);
            double tDiff = e.period.inMinutes / timerange.inMinutes;
            // print(tDiff);
            double kSize = height * tDiff;

            // kSize = kSize < 50 ? 50 : kSize;
            print(kSize);

            return buildColorLayer(
                height: kSize,
                offset: offset,
                color: e.color.withOpacity(e.isDone ? 1 : 1));
          }),
          // donedOverlay()
        ],
      ),
    );
  }

  Positioned buildColorLayer(
      {required double height, required double offset, required Color color}) {
    return Positioned(
      top: offset,
      child: Container(
        color: color,
        height: height,
        width: 50,
      ),
    );
  }

  // Container(
  //           height: 100,
  //           width: 50,
  //           child: InvertColors(
  //             child: Center(
  //               child: Icon(Icons.ac_unit),
  //             ),
  //           )),
}

class TileBody extends StatefulWidget {
  const TileBody({
    Key? key,
    required this.task,
    required this.isFirst,
    required this.isLast,
  }) : super(key: key);

  final Task task;
  final bool isFirst;
  final bool isLast;

  @override
  _TileBodyState createState() => _TileBodyState();
}

class _TileBodyState extends State<TileBody> {
  Rect? _getOffset(GlobalKey? key) {
    if (key == null) return null;
    final renderObject = key.currentContext?.findRenderObject();
    var translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      return renderObject?.paintBounds
          .shift(Offset(translation.x, translation.y));
    } else {
      return null;
    }
  }

  bool showSubButtons = false;

  bool isUnSubscribed() =>
      (BlocProvider.of<SubscribeBloc>(context).state is! Subscribed);

  onCheckClicked(BuildContext context, {required Task task}) {
    BlocProvider.of<DailytasksBloc>(context)
        .add(DailytasksUpdateTask(task: task.copyWith(isDone: !task.isDone)));
  }

  onLockClicked(BuildContext context, {required Task task}) {
    BlocProvider.of<DailytasksBloc>(context).add(
        DailytasksUpdateTask(task: task.copyWith(timeLock: !task.timeLock)));
  }

  void showCopyDialog({required Task task}) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => CopyTaskDialog(
        task: task,
      ),
    );
  }

  onEditClicked(BuildContext context, {required Task task}) {
    if (!(task is RegularTask)) return;
    Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => TaskEditor(task: task),
            ))
        .then((value) =>
            BlocProvider.of<DailytasksBloc>(context).add(DailytasksUpdate()));
  }

  String geTimeString(DateTime date) => date.toString().substring(11, 16);

  @override
  Widget build(BuildContext context) {
    bool isLessThen350() => MediaQuery.of(context).size.width < 350;
    return InkWell(
      key: widget.task.key,
      onTap: () {
        showModal(
            context,
            RegularTaskModal(
                widget.task,
                _getOffset(widget.task.key)?.top ?? 0,
                () => onEditClicked(context, task: widget.task),
                () => onLockClicked(context, task: widget.task),
                () => showCopyDialog(task: widget.task)));
        // setState(() {
        //   showSubButtons = !showSubButtons;
        // });
      },
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: isLessThen350() ? 40 : 59,
            ),
            // LayoutBuilder(
            //   builder: (context, c) {
            //     return SizedBox(
            //         height: c.minHeight, child: buildIconsLayer(task: task));
            //   },
            // ),
            buildIconsLayer(task: widget.task),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: buildTextSection(task: widget.task)),
                      Row(
                        children: [
                          isUnSubscribed()
                              ? SizedBox()
                              : HidableTimeLock(
                                  locked: widget.task.timeLock,
                                  showLock: showSubButtons,
                                  onTap: () => onLockClicked(context,
                                      task: widget.task)),
                          widget.task.isDonable
                              ? DoneCheckbox(
                                  checked: widget.task.isDone,
                                  onClick: () => onCheckClicked(context,
                                      task: widget.task))
                              : SizedBox(),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  if (widget.task is RegularTask)
                    HidableButtonsWrapper(
                        showSubButtons: showSubButtons,
                        children: [
                          MiniButtonWithIcon(
                              color: Color(0xff4077C1).withOpacity(0.75),
                              text: 'Edit Task',
                              iconAsset: 'src/icons/edit.png',
                              callback: () => onEditClicked(context,
                                  task: widget.task as RegularTask)),
                          MiniButtonWithIcon(
                              color: Color(0xffF4D700).withOpacity(0.75),
                              text: 'Copy Task',
                              iconAsset: 'src/icons/copy.png',
                              callback: () => showCopyDialog(
                                  task: widget.task as RegularTask)),
                        ]),
                ],
              ),
            ),
            SizedBox(
              width: 25,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildIconsLayer({required Task task}) {
    double timeDiffEquality() {
      DateTime currt = DateTime.now();

      if (currt.difference(task.timeStart).inMinutes > 0) {
        var dif = task.timeStart
            .add(task.period)
            .difference(task.timeStart)
            .inMinutes;
        var currFromStart = currt.difference(task.timeStart).inMinutes;
        return currFromStart / dif;
      }

      return 0.0;
    }

    return Stack(
      children: [
        Container(
          width: 50,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: task.color.withOpacity(0.75), blurRadius: 10)
            ],
            color: task.color,
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(widget.isFirst ? 25 : 0),
                bottom: Radius.circular(widget.isLast ? 25 : 0)),
          ),
        ),
        // ClipRRect(
        //   borderRadius: BorderRadius.vertical(
        //       top: Radius.circular(isFirst ? 25 : 0),
        //       bottom: Radius.circular(isLast ? 25 : 0)),
        //   child: Container(
        //     // height: 50,
        //     width: 50,
        //     child: Align(
        //       alignment: Alignment.topCenter,
        //       child: ClipRect(
        //         child: Align(
        //           heightFactor: timeDiffEquality(),
        //           child: Container(
        //             // height: 150,
        //             width: 50,
        //             decoration: BoxDecoration(
        //               boxShadow: [
        //                 BoxShadow(
        //                     color: Color(0xff707070).withOpacity(0.5),
        //                     blurRadius: 10)
        //               ],
        //               color: task.color,
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        buildMainIcon(task: task)
      ],
    );
  }

  Container buildMainIcon({required Task task}) {
    return Container(
        height: 50,
        width: 50,
        child: InvertColors(
          child: Center(
            child: CachedIcon(
              imageID: widget.task.iconId,
            ),
          ),
        ));
  }

  Widget buildTextSection({required Task task}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 4,
        ),
        Text(
          '${geTimeString(task.timeStart)} - ${geTimeString(task.timeStart.add(task.period))}',
          style: TextStyle(
              color: Colors.white,
              fontSize: 14 * byWithScale(context),
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          task.title,
          style: TextStyle(
              color: Colors.white,
              fontSize: 14 * byWithScale(context),
              fontWeight: FontWeight.w400,
              decoration: task.isDone
                  ? TextDecoration.lineThrough
                  : TextDecoration.none),
        ),
      ],
    );
  }
}
