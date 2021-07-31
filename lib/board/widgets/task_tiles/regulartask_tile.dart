import 'dart:typed_data';

import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flexible/board/copy_task_dialog.dart';
import 'package:flexible/board/models/tasks/regular_taks.dart';
import 'package:flexible/board/repository/image_repo_mock.dart';
import 'package:flexible/board/task_editor/task_editor.dart';
import 'package:flexible/board/widgets/task_tiles/components/hidable_btns_wrapper.dart';
import 'package:flexible/board/widgets/task_tiles/components/hidable_lock.dart';
import 'package:flexible/board/widgets/task_tiles/components/mini_buttons_with_icon.dart';
import 'package:flexible/board/widgets/task_tiles/components/done_checkbox.dart';
import 'package:flexible/subscription/bloc/subscribe_bloc.dart';
import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flexible/utils/modal.dart';
import 'package:flexible/widgets/modals/regular_task_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invert_colors/invert_colors.dart';

class RegularTaskTile extends StatefulWidget {
  final RegularTask task;
  RegularTaskTile({required this.task});
  @override
  _RegularTaskTileState createState() => _RegularTaskTileState();
}

class _RegularTaskTileState extends State<RegularTaskTile> {
  // DateTime currentTime = DateTime.now();
  bool showSubButtons = false;

  @override
  void initState() {
    super.initState();
  }

  bool isUnSubscribed() =>
      (BlocProvider.of<SubscribeBloc>(context).state is! Subscribed);

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
      key: widget.task.key,
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          showModal(
              context,
              RegularTaskModal(
                  widget.task,
                  _getOffset(widget.task.key)?.top ?? 0,
                  () => onEditClicked(context),
                  () => onLockClicked(context),
                  () => showCopyDialog()));
          // setState(() {
          //   showSubButtons = !showSubButtons;
          // });
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          child: Stack(
            children: [
              Positioned(
                top: 16,
                child: Text(geTimeString(widget.task.timeStart),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10 * byWithScale(context),
                        fontWeight: FontWeight.w400)),
              ),
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
                                        onTap: () => onLockClicked(context),
                                      ),
                                widget.task.isDonable
                                    ? DoneCheckbox(
                                        checked: widget.task.isDone,
                                        onClick: () => onCheckClicked(context))
                                    : SizedBox(),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        HidableButtonsWrapper(
                            showSubButtons: showSubButtons,
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
                            ]),
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

  Widget buildTextSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 4,
        ),
        Text(
          '${geTimeString(widget.task.timeStart)}',
          style: TextStyle(
              color: Colors.white,
              fontSize: 14 * byWithScale(context),
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          widget.task.title,
          style: TextStyle(
              color: Colors.white,
              fontSize: 14 * byWithScale(context),
              fontWeight: FontWeight.w400,
              decoration: widget.task.isDone
                  ? TextDecoration.lineThrough
                  : TextDecoration.none),
        ),
        Text(
          widget.task.subtitle,
          style: TextStyle(
              color: Colors.white,
              fontSize: 12 * byWithScale(context),
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}
