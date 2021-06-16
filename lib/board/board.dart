import 'dart:math';
import 'package:flexible/board/models/tasks/regular_taks.dart';
import 'package:flexible/board/models/tasks/supertask.dart';
import 'package:flexible/board/turbo_sliver_sticky_scroll.dart';
import 'package:flexible/board/widgets/supertask_tile..dart';
import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flexible/widgets/message_snakbar.dart';
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
        child: BlocConsumer<DailytasksBloc, DailytasksState>(
      listener: (context, state) {
        if (state is DailytasksCommon) {
          if (state.askForSuperInsert) {
            print('ask user');

            ScaffoldMessenger.of(context).showSnackBar(buildSuperAsk(context));
          }
          if (state.message.isNotEmpty) {
            ScaffoldMessenger.of(context)
                .showSnackBar(messageSnakbar(text: state.message));
          }
        }
      },
      builder: (context, state) {
        print(state);
        if (state is DailytasksCommon) {
          List<Widget> tasks = state.tasks
              .map((e) {
                if (e is RegularTask) {
                  if (e.period.inMilliseconds == 0) {
                    return TaskTile(task: e);
                  } else {
                    return PeriodicTaskTile(task: e);
                  }
                }
                return SuperTaskTile(task: e as SuperTask);
              })
              .cast<Widget>()
              .toList();
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

  // Ask user for insert supertask into current day
  SnackBar buildSuperAsk(BuildContext context) {
    return SnackBar(
        duration: Duration(seconds: 60),
        backgroundColor: Colors.transparent,
        content: Center(
          child: Container(
            padding: EdgeInsets.all(32),
            decoration: BoxDecoration(
                color: Color(0xffF66868),
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    'Would you like to insert your super tasks into free time gap?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14 * byWithScale(context))),
                SizedBox(
                  height: 14 * byWithScale(context),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        BlocProvider.of<DailytasksBloc>(context)
                            .add(DailytasksSuperInsert());
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      },
                      child: Text('Yes',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14 * byWithScale(context))),
                    ),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      },
                      child: Text('No',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14 * byWithScale(context))),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
