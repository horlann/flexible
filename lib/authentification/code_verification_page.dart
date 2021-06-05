import 'package:flexible/board/widgets/glassmorph_layer.dart';
import 'package:flexible/utils/main_backgroung_gradient.dart';
import 'package:flutter/material.dart';

class CodeVerificationPage extends StatelessWidget {
  const CodeVerificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xffE9E9E9),
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            gradient: mainBackgroundGradient,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  SizedBox(
                    height: 32,
                  ),
                  Text(
                    'fleXible',
                    style: TextStyle(
                        color: Color(0xffE24F4F),
                        fontSize: 32,
                        fontWeight: FontWeight.w700),
                  ),
                  Padding(
                    padding: EdgeInsets.all(32),
                    child: Stack(
                      children: [
                        Positioned.fill(child: GlassmorphLayer()),
                        Column(
                          children: [
                            SizedBox(
                              width: double.maxFinite,
                            ),
                            SizedBox(
                              height: 32,
                            ),
                            Text(
                              'SMS protection',
                              style: TextStyle(
                                  color: Color(0xffE24F4F),
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              height: 32,
                            ),
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(40)),
                              child: Center(
                                child: Icon(
                                  Icons.person,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 32,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () => {},
                        child: Container(
                          height: 40,
                          width: double.maxFinite,
                          margin: EdgeInsets.symmetric(horizontal: 40),
                          decoration: BoxDecoration(
                              color: Color(0xffE24F4F),
                              borderRadius: BorderRadius.circular(30)),
                          child: Center(
                            child: Text(
                              'Continue',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
