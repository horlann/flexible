import 'package:flexible/board/board.dart';
import 'package:flexible/utils/main_backgroung_gradient.dart';
import 'package:flutter/material.dart';

class FlexibleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE9E9E9),
      body: SafeArea(
        child: SizedBox.expand(
          child: Container(
            decoration: BoxDecoration(gradient: mainBackgroundGradient),
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
    );
  }

  // static fake bar
  Widget buildDateBottomBar() {
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
              '22 April 2021',
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
