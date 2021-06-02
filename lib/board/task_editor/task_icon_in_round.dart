import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flexible/board/repository/image_repo_mock.dart';

class TaskIconInRound extends StatelessWidget {
  const TaskIconInRound({
    Key? key,
    required this.iconId,
    required this.taskColor,
  }) : super(key: key);

  final String iconId;
  final Color taskColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
          color: taskColor, borderRadius: BorderRadius.circular(16)),
      child: Center(
        child: FutureBuilder(
          future:
              RepositoryProvider.of<ImageRepoMock>(context).imageById(iconId),
          builder: (context, AsyncSnapshot<Uint8List> snapshot) {
            if (snapshot.hasData) {
              return Image.memory(
                snapshot.data!,
                width: 20,
                height: 20,
                gaplessPlayback: true,
              );
            }

            return Image.asset(
              'src/icons/noimage.png',
              width: 20,
              height: 20,
            );
          },
        ),
      ),
    );
  }
}
