import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flexible/board/copy_task_dialog.dart';
import 'package:flexible/board/models/task.dart';
import 'package:flexible/board/task_editor.dart';
import 'package:flexible/board/widgets/mini_buttons_with_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskTile extends StatefulWidget {
  final Task task;
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
                          fontSize: 13,
                          fontWeight: FontWeight.w400))),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 59,
                  ),
                  buildMainIcon(),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: buildTextSection(),
                  ),
                  widget.task.isDonable ? buildCheckbox(context) : SizedBox(),
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
            BoxShadow(
                color: widget.task.color.withOpacity(0.75),
                blurRadius: 20,
                offset: Offset(0, 10))
          ],
          color: widget.task.color,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Image.asset(
          'src/icons/Additional.png',
          scale: 1.1,
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
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          widget.task.title,
          style: TextStyle(
              color: Color(0xff545353),
              fontSize: 18,
              fontWeight: FontWeight.w600,
              decoration: widget.task.isDone
                  ? TextDecoration.lineThrough
                  : TextDecoration.none),
        ),
        Text(
          widget.task.subtitle,
          style: TextStyle(
              color: Color(0xff545353),
              fontSize: 14,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 16,
        ),
        buildSubButtons()
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
              )
            : Image.asset(
                'src/icons/checkbox_unchecked.png',
                scale: 1.2,
              ),
      ),
    );
  }
}
