import 'dart:async';
import 'package:flexible/board/models/tasks/supertask.dart';
import 'package:flexible/board/widgets/task_tiles/components/cached_icon.dart';
import 'package:flexible/widgets/modals/super_task_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invert_colors/invert_colors.dart';
import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flexible/board/copy_task_dialog.dart';
import 'package:flexible/board/models/tasks/regular_taks.dart';
import 'package:flexible/board/models/tasks/task.dart';
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
        // color: Colors.red,
        margin: EdgeInsets.symmetric(vertical: 16),
        child: Stack(
          children: [
            Positioned(
                top: 2,
                child: Container(
                  alignment: Alignment.center,
                  width: isLessThen350() ? 40 : 59,
                  child: Text(geTimeString(timeStart()),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10 * byWithScale(context),
                          fontWeight: FontWeight.w400)),
                )),
            timeDiffEquality() > 1
                ? SizedBox()
                : (timeDiffEquality() == 0
                    ? SizedBox()
                    : Positioned(
                        top: (110 * timeDiffEquality()) + 12,
                        child: Container(
                          alignment: Alignment.center,
                          width: isLessThen350() ? 40 : 59,
                          child: Text(
                            geTimeString(DateTime.now()),
                            style: TextStyle(
                                fontSize: 10 * byWithScale(context),
                                color: Colors.white),
                          ),
                        ),
                      )),
            Positioned(
                bottom: 0,
                child: Container(
                  alignment: Alignment.center,
                  width: isLessThen350() ? 40 : 59,
                  // color: Colors.red,
                  child: Text(geTimeString(timeEnd()),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10 * byWithScale(context),
                          fontWeight: FontWeight.w400)),
                )),
            Row(
              children: [
                SizedBox(
                  width: isLessThen350() ? 40 : 59,
                ),
                iconsAndBgLayer(),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                      children: widget.tasks
                          .map((e) => TileBody(
                              task: e,
                              isFirst: widget.tasks.first == e,
                              isLast: widget.tasks.last == e))
                          .toList()),
                ),
              ],
            ),
            // Column(
            //     children: widget.tasks
            //         .map((e) => TileBody(
            //             task: e,
            //             isFirst: widget.tasks.first == e,
            //             isLast: widget.tasks.last == e))
            //         .toList())
          ],
        ),
      ),
    );
  }

  Widget iconsAndBgLayer() {
    // DateTime date = DateTime.fromMillisecondsSinceEpoch(1628097968662);
    DateTime date = DateTime.now();
    Duration timerange = timeEnd().difference(timeStart());
    double height = widget.tasks.length * 120;
    double elementOffset = -120;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.25),
              blurRadius: 10 * byWithScale(context))
        ],
        // color: Color(0xffCAC8C4),
        borderRadius: BorderRadius.circular(25),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Bottom Layer for shadow
            Container(
              height: height,
              width: 50,
            ),
            ...widget.tasks
                .map((e) {
                  // Blessed math shit

                  elementOffset += 120;
                  // print(elementOffset);
                  var gap = e.timeStart.add(e.period).difference(e.timeStart);
                  // print(gap);
                  var dateOf = date.difference(e.timeStart);
                  // print(dateOf);
                  bool isPos = !dateOf.isNegative;
                  // print(isPos);
                  double hMP = dateOf.inMinutes / gap.inMinutes;
                  // print(hMP);
                  double height = 120 * hMP;
                  // print(height);
                  Duration overtime =
                      date.difference(e.timeStart.add(e.period));
                  // print(overtime.inMinutes);

                  return Positioned(
                    top: elementOffset,
                    child: Container(
                      color: Color(0xffD1D1D1),
                      height: 120,
                      width: 50,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            child: Container(
                                color: e.color.withOpacity(
                                    hMP >= 1 || e.isDone ? 1 : 0.2)),
                            height: 120,
                            width: 50,
                          ),
                          // Color fill from top to bottom by done time
                          if (hMP > 0 && hMP <= 1 || e.period.inMinutes == 0)
                            Positioned(
                              child: Container(color: e.color.withOpacity(1)),
                              height: e.period.inMinutes == 0 ? 120 : height,
                              width: 50,
                            ),
                          Container(
                              height: 120,
                              width: 50,
                              child: InvertColors(
                                  child: Center(
                                      child: CachedIcon(
                                imageID: e.iconId,
                                key: Key(e.iconId),
                              )))),
                          // Show tale with overtime if is undoned yet
                          if (widget.tasks.last != e && hMP > 1 && !e.isDone)
                            Positioned(
                              left: 12.5,
                              bottom: -12.5,
                              child: ClipOval(
                                child: Container(
                                  alignment: Alignment.center,
                                  color: e.color,
                                  width: 25,
                                  height: 25,
                                  child: Text(
                                      overtime.inMinutes > timerange.inMinutes
                                          ? '∞'
                                          : overtime.inMinutes.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                      )),
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                  );
                })
                .toList()
                .reversed,
            // donedOverlay()
          ],
        ),
      ),
    );
  }

  // Deprecated
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
      onTap: () {
        if (widget.task is RegularTask) {
          showModal(
              context,
              RegularTaskModal(
                  widget.task,
                  _getOffset(widget.task.key)?.top ?? 0,
                  () => onEditClicked(context, task: widget.task),
                  () => onLockClicked(context, task: widget.task),
                  () => showCopyDialog(task: widget.task)));
        }
        if (widget.task is SuperTask) {
          showModal(
              context,
              SuperTaskModal(widget.task, _getOffset(widget.task.key)?.top ?? 0,
                  () => onLockClicked(context, task: widget.task)));
        }
      },
      child: Stack(
        children: [
          // Use as last layer or it brake all animations
          Container(
            key: widget.task.key,
          ),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: buildTextSection(task: widget.task)),
                          DoneCheckbox(
                              checked: widget.task.isDone,
                              onClick: () =>
                                  onCheckClicked(context, task: widget.task))
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 25,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextSection({required Task task}) {
    Widget superTaskProgress() {
      if (task is SuperTask) {
        String iTime = task.globalDurationLeft.toString().substring(0, 4);
        String allTime = task.globalDuration.toString().substring(0, 4);

        return Text(
          '$iTime/$allTime',
          style: TextStyle(
              color: Colors.white,
              fontSize: 12 * byWithScale(context),
              fontWeight: FontWeight.w400),
        );
      } else {
        return SizedBox();
      }
    }

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
              fontWeight: FontWeight.w600,
              decoration: widget.task.isDone
                  ? TextDecoration.lineThrough
                  : TextDecoration.none),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          task.title,
          style: TextStyle(
              color: Colors.white,
              fontSize: 14 * byWithScale(context),
              fontWeight: FontWeight.w600,
              decoration: task.isDone
                  ? TextDecoration.lineThrough
                  : TextDecoration.none),
        ),
        superTaskProgress(),
      ],
    );
  }
}
