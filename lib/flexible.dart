import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flexible/board/board.dart';
import 'package:flexible/board/repository/sqflire_tasks_repo.dart';
import 'package:flexible/utils/main_backgroung_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class FlexibleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
    String currentDate() => DateFormat('yyyy-LLLL-dd').format(DateTime.now());

    return SizedBox(
      width: 380,
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'src/icons/arrow_left.png',
              width: 32,
              fit: BoxFit.fitWidth,
            ),
            Text(
              currentDate(),
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 28,
                  color: Color(0xffF66868)),
            ),
            Image.asset(
              'src/icons/arrow_right.png',
              width: 32,
              fit: BoxFit.fitWidth,
            )
          ],
        ),
      ),
    );
  }
}
