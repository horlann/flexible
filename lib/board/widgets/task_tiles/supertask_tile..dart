import 'dart:async';
import 'dart:typed_data';
import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flexible/board/copy_task_dialog.dart';
import 'package:flexible/board/models/tasks/supertask.dart';
import 'package:flexible/board/repository/image_repo_mock.dart';
import 'package:flexible/board/widgets/task_tiles/components/cached_icon.dart';
import 'package:flexible/board/widgets/task_tiles/components/done_checkbox.dart';
import 'package:flexible/board/widgets/task_tiles/components/hidable_lock.dart';
import 'package:flexible/subscription/bloc/subscribe_bloc.dart';
import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flexible/utils/modal.dart';
import 'package:flexible/widgets/modals/super_task_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invert_colors/invert_colors.dart';

class SuperTaskTile extends StatefulWidget {
  final SuperTask task;
  final List<SuperTask> listSuperTask;
  SuperTaskTile({required this.task,required this.listSuperTask});
  @override
  _SuperTaskTileState createState() => _SuperTaskTileState();
}

class _SuperTaskTileState extends State<SuperTaskTile> {
  @override
  void initState() {
    super.initState();
    updateUi();
  }

  @override
  void didUpdateWidget(covariant SuperTaskTile oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  // DateTime currentTime = DateTime.now();
  bool showSubButtons = false;

  // Start autoupdate cycle
  // Uses for correct time showing
  // Auto close if widget disposed
  updateUi() {
    if (this.mounted) {
      setState(() {});
      Timer(Duration(seconds: 10), () => updateUi());
    }
  }

  bool isUnSubscribed() =>
      (BlocProvider.of<SubscribeBloc>(context).state is! Subscribed);

  onCheckClicked(BuildContext context) {
    BlocProvider.of<DailytasksBloc>(context)
        .add(DailytasksSuperTaskIteration(task: widget.task));
  }

  onEditClicked(BuildContext context) {}

  onDeleteClicked(BuildContext context) {
    BlocProvider.of<DailytasksBloc>(context)
        .add(DailytasksDeleteTask(task: widget.task));
  }

  onLockClicked(BuildContext context) {
    BlocProvider.of<DailytasksBloc>(context).add(DailytasksUpdateTask(
        task: widget.task.copyWith(timeLock: !widget.task.timeLock)));
  }

  void showCopyDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => CopyTaskDialog(
        task: widget.task,
      ),
    );
  }

  String geTimeString(DateTime date) => date.toString().substring(11, 16);

  // Calc differense between current time and task period
  double timeDiffEquality() {
    DateTime currt = DateTime.now();

    if (currt.difference(widget.task.timeStart).inMinutes > 0) {
      var dif = widget.task.timeStart
          .add(widget.task.period)
          .difference(widget.task.timeStart)
          .inMinutes;
      var currFromStart = currt.difference(widget.task.timeStart).inMinutes;
      return currFromStart / dif;
    }

    return 0.0;
  }

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

  @override
  Widget build(BuildContext context) {
    bool isLessThen350() => MediaQuery.of(context).size.width < 350;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          showModal(
              context,
              SuperTaskModal(widget.task, _getOffset(widget.task.key)?.top ?? 0,
                  () => onLockClicked(context)));
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          child: Stack(
            children: [
              // Use as last layer or it brake all animations
              Container(
                key: widget.task.key,
              ),
              Positioned(
                  top: 2,
                  child: Container(
                    alignment: Alignment.center,
                    width: isLessThen350() ? 40 : 59,
                    child: Text(geTimeString(widget.task.timeStart),
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
                    child: Text(
                        geTimeString(
                            widget.task.timeStart.add(widget.task.period)),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10 * byWithScale(context),
                            fontWeight: FontWeight.w400)),
                  )),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: isLessThen350() ? 40 : 59,
                  ),
                  buildMainIcon(),
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
                            Expanded(child: buildTextSection()),
                            Row(
                              children: [
                                isUnSubscribed()
                                    ? SizedBox()
                                    : HidableTimeLock(
                                        locked: widget.task.timeLock,
                                        showLock: showSubButtons,
                                        onTap: () => onLockClicked(context)),
                                DoneCheckbox(
                                    checked: widget.task.isDone,
                                    onClick: () => onCheckClicked(context))
                              ],
                            ),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMainIcon() {
    return Hero(
      tag: widget.task,
      child: Stack(
        children: [
          Container(
            height: 150,
            width: 50,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: widget.task.color.withOpacity(0.75), blurRadius: 10)
              ],
              color: Color(0xffCAC8C4),
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Container(
              height: 150,
              width: 50,
              child: Align(
                alignment: Alignment.topCenter,
                child: ClipRect(
                  child: Align(
                    heightFactor: timeDiffEquality(),
                    child: Container(
                      height: 150,
                      width: 50,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xff707070).withOpacity(0.5),
                              blurRadius: 10)
                        ],
                        color: widget.task.color,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
              height: 150,
              width: 50,
              child: InvertColors(
                child: Center(
                  child: CachedIcon(
                    imageID: widget.task.iconId,
                    key: Key(widget.task.iconId),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget buildTextSection() {
    String iTime = "";
    widget.listSuperTask.forEach((superTask) {
      if (superTask.uuid == widget.task.superTaskId) {
        iTime = superTask.globalDurationLeft.toString().substring(0, 4);
      }
    });
    if (iTime.isEmpty)
    {
      iTime = widget.task.globalDurationLeft.toString().substring(0, 4);
    }
    String allTime = widget.task.globalDuration.toString().substring(0, 4);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 4,
        ),
        Text(
          '${geTimeString(widget.task.timeStart)} - ${geTimeString(widget.task.timeStart.add(widget.task.period))}',
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
          widget.task.title,
          style: TextStyle(
              color: Colors.white,
              fontSize: 14 * byWithScale(context),
              fontWeight: FontWeight.w600,
              decoration: widget.task.isDone
                  ? TextDecoration.lineThrough
                  : TextDecoration.none),
        ),
        Text(
          '$iTime/$allTime',
          style: TextStyle(
              color: Colors.white,
              fontSize: 12 * byWithScale(context),
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
