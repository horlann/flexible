import 'dart:typed_data';

import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flexible/board/copy_task_dialog.dart';
import 'package:flexible/board/models/tasks/regular_taks.dart';
import 'package:flexible/board/repository/image_repo_mock.dart';
import 'package:flexible/board/task_editor/task_editor.dart';
import 'package:flexible/board/widgets/mini_buttons_with_icon.dart';
import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invert_colors/invert_colors.dart';

class TaskTile extends StatefulWidget {
  final RegularTask task;
  TaskTile({required this.task});
  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  // DateTime currentTime = DateTime.now();
  bool showSubButtons = false;

  @override
  void initState() {
    super.initState();
  }

  onCheckClicked(BuildContext context) {
    BlocProvider.of<DailytasksBloc>(context).add(DailytasksUpdateTask(
        task: widget.task.copyWith(isDone: !widget.task.isDone)));
  }

  onEditClicked(BuildContext context) {
    Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => TaskEditor(task: widget.task),
            ))
        .then((value) =>
            BlocProvider.of<DailytasksBloc>(context).add(DailytasksUpdate()));
  }

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

  @override
  Widget build(BuildContext context) {
    bool isLessThen350() => MediaQuery.of(context).size.width < 350;

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
                  child: Text(geTimeString(widget.task.timeStart),
                      style: TextStyle(
                          color: Color(0xff545353),
                          fontSize: 10 * byWithScale(context),
                          fontWeight: FontWeight.w400))),
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
                                buildTimeLock(),
                                widget.task.isDonable
                                    ? buildCheckbox(context)
                                    : SizedBox(),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        buildSubButtons(),
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

  Widget buildTimeLock() {
    return AnimatedCrossFade(
      crossFadeState:
          showSubButtons ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: Duration(
        milliseconds: 200,
      ),
      firstChild: GestureDetector(
        onTap: () => onLockClicked(context),
        child: Container(
          margin: EdgeInsets.only(top: 14, right: 4),
          child: widget.task.timeLock
              ? Image.asset(
                  'src/icons/locked.png',
                  width: 18 * byWithScale(context),
                  height: 18 * byWithScale(context),
                )
              : Image.asset(
                  'src/icons/unlocked.png',
                  width: 18 * byWithScale(context),
                  height: 18 * byWithScale(context),
                ),
        ),
      ),
      secondChild: SizedBox(
        width: 26,
        height: 22,
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
                color: widget.task.color.withOpacity(0.75),
                blurRadius: 20,
                offset: Offset(0, 10))
          ],
          color: widget.task.color,
          borderRadius: BorderRadius.circular(25),
        ),
        child: InvertColors(
          child: Center(
            child: FutureBuilder(
              future: RepositoryProvider.of<ImageRepoMock>(context)
                  .imageById(widget.task.iconId),
              builder: (context, AsyncSnapshot<Uint8List> snapshot) {
                if (snapshot.hasData) {
                  return Image.memory(
                    snapshot.data!,
                    width: 24,
                    height: 24,
                    gaplessPlayback: true,
                  );
                }

                return Image.asset(
                  'src/task_icons/noimage.png',
                  width: 24,
                  height: 24,
                  gaplessPlayback: true,
                );
              },
            ),
          ),
        ));
  }

  Column buildTextSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 4,
        ),
        Text(
          '${geTimeString(widget.task.timeStart)}',
          style: TextStyle(
              color: Color(0xff545353),
              fontSize: 14 * byWithScale(context),
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          widget.task.title,
          style: TextStyle(
              color: Color(0xff545353),
              fontSize: 14 * byWithScale(context),
              fontWeight: FontWeight.w400,
              decoration: widget.task.isDone
                  ? TextDecoration.lineThrough
                  : TextDecoration.none),
        ),
        Text(
          widget.task.subtitle,
          style: TextStyle(
              color: Color(0xff545353),
              fontSize: 12 * byWithScale(context),
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  // Button under task
  // Shows when user tap on task tile
  Widget buildSubButtons() {
    return AnimatedCrossFade(
      duration: Duration(milliseconds: 200),
      crossFadeState:
          showSubButtons ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      firstChild: SizedBox(),
      secondChild: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MiniButtonWithIcon(
              color: Color(0xff4077C1).withOpacity(0.75),
              text: 'Edit Task',
              iconAsset: 'src/icons/edit.png',
              callback: () => onEditClicked(context)),
          MiniButtonWithIcon(
              color: Color(0xffF4D700).withOpacity(0.75),
              text: 'Copy Task',
              iconAsset: 'src/icons/copy.png',
              callback: () => showCopyDialog()),
        ],
      ),
    );
  }

  GestureDetector buildCheckbox(BuildContext context) {
    return GestureDetector(
      onTap: () => onCheckClicked(context),
      child: Container(
        margin: EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Color(0xff6E6B6B).withOpacity(0.75),
                blurRadius: 20,
                offset: Offset(0, 10))
          ],
        ),
        child: widget.task.isDone
            ? Image.asset(
                'src/icons/checkbox_checked.png',
                scale: 1.2,
                width: 18 * byWithScale(context),
              )
            : Image.asset(
                'src/icons/checkbox_unchecked.png',
                scale: 1.2,
                width: 18 * byWithScale(context),
              ),
      ),
    );
  }
}
