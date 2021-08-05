import 'dart:typed_data';

import 'package:flexible/board/widgets/task_tiles/components/cached_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invert_colors/invert_colors.dart';

import 'package:flexible/board/repository/image_repo_mock.dart';
import 'package:flexible/utils/adaptive_utils.dart';

class TaskIconInRound extends StatelessWidget {
  const TaskIconInRound({
    Key? key,
    required this.iconId,
    required this.taskColor,
    required this.onTap,
  }) : super(key: key);

  final String iconId;
  final Color taskColor;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        width: 35 * byWithScale(context),
        height: 35 * byWithScale(context),
        decoration: BoxDecoration(color: taskColor, shape: BoxShape.circle),
        child: InvertColors(
          child: Center(child: CachedIcon(imageID: iconId)),
        ),
      ),
    );
  }
}
