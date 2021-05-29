import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flexible/board/models/task.dart';
import 'package:flexible/board/task_editor.dart';
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
  late bool completed;
  bool showSubButtons = false;

  @override
  void initState() {
    super.initState();
    completed = widget.task.isDone;
  }

  onCheckClicked(BuildContext context) {
    setState(() {
      completed = !completed;
    });
    BlocProvider.of<DailytasksBloc>(context).add(
        DailytasksUpdateTask(task: widget.task.copyWith(isDone: completed)));
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

  String geTimeString(DateTime date) => date.toString().substring(11, 16);

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
                top: 2,
                child: Text(geTimeString(widget.task.timeStart),
                    style: TextStyle(
                        color: Color(0xff545353),
                        fontSize: 13,
                        fontWeight: FontWeight.w400))),
            Positioned(
                top: 32,
                child: Text(
                    geTimeString(widget.task.timeStart.add(widget.task.period)),
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
    );
  }

  Container buildMainIcon() {
    return Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Color(0xffEE7579).withOpacity(0.75),
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
          '${geTimeString(widget.task.timeStart)} - ${geTimeString(widget.task.timeStart.add(widget.task.period))}',
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
              decoration:
                  completed ? TextDecoration.lineThrough : TextDecoration.none),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          miniWhiteBorderedButton(
              text: 'Edit Task',
              iconAsset: 'src/icons/edit.png',
              callback: () => onEditClicked(context)),
          miniWhiteBorderedButton(
              text: 'Copy Task', iconAsset: 'src/icons/copy.png'),
          miniWhiteBorderedButton(
              text: 'Delete',
              iconAsset: 'src/icons/delete.png',
              callback: () => onDeleteClicked(context))
        ],
      ),
    );
  }

  Widget miniWhiteBorderedButton(
      {required String text,
      required String iconAsset,
      VoidCallback? callback}) {
    return InkWell(
      onTap: () {
        if (callback != null) {
          callback();
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color(0xffF66868), width: 2)),
        child: Row(
          children: [
            Image.asset(
              iconAsset,
              width: 8,
              height: 8,
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: 2,
            ),
            Text(
              text,
              style: TextStyle(fontSize: 8, color: Color(0xffF66868)),
            ),
          ],
        ),
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
        child: completed
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
