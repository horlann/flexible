import 'dart:typed_data';

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
        width: 24 * byWithScale(context),
        height: 24 * byWithScale(context),
        decoration: BoxDecoration(
            color: taskColor, borderRadius: BorderRadius.circular(16)),
        child: InvertColors(
          child: Center(
            child: FutureBuilder(
              future: RepositoryProvider.of<ImageRepoMock>(context)
                  .imageById(iconId),
              builder: (context, AsyncSnapshot<Uint8List> snapshot) {
                if (snapshot.hasData) {
                  return Image.memory(
                    snapshot.data!,
                    width: 16 * byWithScale(context),
                    height: 16 * byWithScale(context),
                    gaplessPlayback: true,
                  );
                }

                return Image.asset(
                  'src/icons/noimage.png',
                  width: 16 * byWithScale(context),
                  height: 16 * byWithScale(context),
                  gaplessPlayback: true,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
