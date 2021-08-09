import 'package:another_flushbar/flushbar.dart';
import 'package:flexible/board/models/tasks/regular_taks.dart';
import 'package:flexible/board/models/tasks/supertask.dart';
import 'package:flexible/board/models/tasks/task.dart';
import 'package:flexible/board/turbo_sliver_sticky_scroll.dart';
import 'package:flexible/board/widgets/task_tiles/grouped_task_tile.dart';
import 'package:flexible/board/widgets/task_tiles/supertask_tile..dart';
import 'package:flexible/subscription/bloc/subscribe_bloc.dart';
import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flexible/utils/modal.dart';
import 'package:flexible/utils/tasks_sort.dart';
import 'package:flexible/widgets/message_snakbar.dart';
import 'package:flexible/widgets/modals/regular_task_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flexible/board/widgets/glassmorphic_bg_shifted.dart';
import 'package:flexible/board/widgets/task_tiles/periodic_task_tile..dart';
import 'package:flexible/board/widgets/task_tiles/regulartask_tile.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class Board extends StatefulWidget {
  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  @override
  void initState() {
    super.initState();

    // If user subscribed ask for supertask insertion
    SubscribeState state = BlocProvider.of<SubscribeBloc>(context).state;
    if (state is Subscribed) {
      BlocProvider.of<DailytasksBloc>(context).add(DailytasksAskForInsert());
    }
  }

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
            showSnackBar(context, state.message, false);
          }
            }
          },
          builder: (context, state) {
            print(state);
            if (state is DailytasksCommon) {
              List<List<Task>> taskGrouped =
              groupingSortByStartTime(tasks: state.tasks);

              List<Widget> tasks = [];

              taskGrouped.forEach((element) {
                if (element.length > 1) {
                  for (var e in element) if (e.key == null) e.key = GlobalKey();
                  tasks.add(GroupedTaskTile(tasks: element));
                } else {
                  var task = element.first;
                  if (task.key == null) task.key = GlobalKey();
                  if (task is RegularTask) {
                    if (task.period.inMilliseconds == 0) {
                      tasks.add(RegularTaskTile(task: task));
                    } else {
                      tasks.add(PeriodicTaskTile(task: task));
                    }
                  } else {
                    tasks.add(SuperTaskTile(task: task as SuperTask));
                  }
                }
              });

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

  void showSnackBar(BuildContext buildContext, String text,
      bool isProgressive) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    Flushbar(
      message: text,
      barBlur: 20,
      mainButton: isProgressive ? Padding(
        padding: const EdgeInsets.only(right: 15.0, top: 10, bottom: 10),
        child: CircularProgressIndicator(
          strokeWidth: 5,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ) : SizedBox(),
      duration: Duration(seconds: 2),
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: BorderRadius.all(Radius.circular(16)),
      backgroundColor: Color(0xffE24F4F),
      margin: const EdgeInsets.symmetric(horizontal: 11),
      messageText: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          )),
    )
      ..show(context);
  }
}
