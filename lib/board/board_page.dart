import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flexible/board/board.dart';
import 'package:flexible/board/repository/sqflire_tasks_repo.dart';
import 'package:flexible/board/week_calendar.dart';
import 'package:flexible/board/widgets/mini_red_button.dart';
import 'package:flexible/utils/main_backgroung_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class BoardPage extends StatefulWidget {
  @override
  _BoardPageState createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  bool showCalendar = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE9E9E9),
      body: SafeArea(
        child: SizedBox.expand(
          child: BlocProvider(
            create: (context) => DailytasksBloc(tasksRepo: SqfliteTasksRepo()),
            child: Container(
              decoration: BoxDecoration(
                gradient: mainBackgroundGradient,
                // image: DecorationImage(
                //   image: AssetImage('src/testbg.jpg'),
                //   fit: BoxFit.cover,
                // ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  Expanded(child: Board()),
                  SizedBox(
                    height: 16,
                  ),
                  WeekCalendar(showCalendar: showCalendar),
                  buildDateBottomBar(),
                  SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDateBottomBar() {
    String currentDate(DateTime date) =>
        DateFormat('yyyy-LLLL-dd').format(date);

    return BlocBuilder<DailytasksBloc, DailytasksState>(
      builder: (context, state) {
        void onTapRight() {
          BlocProvider.of<DailytasksBloc>(context)
              .add(DailytasksSetDay(day: state.showDay.add(Duration(days: 1))));
        }

        void onTapLeft() {
          BlocProvider.of<DailytasksBloc>(context).add(
              DailytasksSetDay(day: state.showDay.subtract(Duration(days: 1))));
        }

        void onTapToday() {
          BlocProvider.of<DailytasksBloc>(context)
              .add(DailytasksSetDay(day: DateTime.now()));
        }

        return SizedBox(
          width: 380,
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AnimatedCrossFade(
                  duration: Duration(milliseconds: 200),
                  crossFadeState: showCalendar
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: MiniRedButton(
                    text: 'Today',
                    callback: () => onTapToday(),
                  ),
                  secondChild: GestureDetector(
                    onTap: () => onTapLeft(),
                    child: Image.asset(
                      'src/icons/arrow_left.png',
                      width: 32,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showCalendar = !showCalendar;
                    });
                  },
                  child: Text(
                    currentDate(state.showDay),
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 28,
                        color: Color(0xffF66868)),
                  ),
                ),
                AnimatedCrossFade(
                  duration: Duration(milliseconds: 200),
                  crossFadeState: showCalendar
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: MiniRedButton(
                    text: 'Go to Date',
                    callback: () => {},
                  ),
                  secondChild: GestureDetector(
                    onTap: () => onTapRight(),
                    child: Image.asset(
                      'src/icons/arrow_right.png',
                      width: 32,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
