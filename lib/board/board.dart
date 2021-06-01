import 'dart:math';
import 'package:flexible/board/turbo_sliver_sticky_scroll.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flexible/board/widgets/glassmorphic_bg_shifted.dart';
import 'package:flexible/board/widgets/periodic_task_tile..dart';
import 'package:flexible/board/widgets/task_tile.dart';

class Board extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlassmorphicBackgroundShifted(
        child: BlocBuilder<DailytasksBloc, DailytasksState>(
      builder: (context, state) {
        if (state is DailytasksCommon) {
          List<Widget> tasks = state.tasks.map((e) {
            if (e.period.inMilliseconds == 0) {
              return TaskTile(task: e);
            } else {
              return PeriodicTaskTile(task: e);
            }
          }).toList();
          return TurboAnimatedScrollView(
            // key: Key(Random().nextInt(9999).toString()),
            tasks: tasks, dayOptions: state.dayOptions,
          );
        }
        // TODO loading
        return SizedBox();
      },
    ));
  }
}
