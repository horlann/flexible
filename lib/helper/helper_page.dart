import 'package:flexible/board/widgets/glassmorph_layer.dart';
import 'package:flexible/utils/main_backgroung_gradient.dart';
import 'package:flexible/widgets/wide_rounded_button.dart';
import 'package:flutter/material.dart';

class HelperPage extends StatelessWidget {
  HelperPage({required this.callback});

  final VoidCallback callback;
  final PageController pageController = PageController();
  final List<Widget> subPages = [
    Helper1(),
    Helper2(),
    Helper3(),
    Helper4(),
  ];

  onContinue() {
    // If all pages showed call
    if (pageController.page == subPages.length - 1) {
      callback();
    }

    // show next subpage
    pageController.nextPage(
        duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

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
                mainAxisSize: MainAxisSize.max,
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
                        SizedBox(
                          height: 500,
                          width: double.maxFinite,
                          child: PageView(
                              controller: pageController, children: subPages),
                        )
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 60),
                        child: WideRoundedButton(
                          text: 'Continue',
                          enable: true,
                          textColor: Colors.white,
                          enableColor: Color(0xffE24F4F),
                          disableColor: Color(0xffE24F4F).withOpacity(0.25),
                          callback: () => onContinue(),
                        ),
                      ),
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

class Helper1 extends StatelessWidget {
  const Helper1({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 16,
        ),
        Text(
          'Welcome',
          style: TextStyle(
              color: Color(0xffE24F4F),
              fontSize: 32,
              fontWeight: FontWeight.w700),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          'Flexible',
          style: TextStyle(
              color: Color(0xffE24F4F),
              fontSize: 24,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 32,
        ),
        Text(
          'Bring structure to your day',
          style: TextStyle(
              color: Color(0xffE24F4F),
              fontSize: 16,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 16,
        ),
        Image.asset(
          'src/helper/wtf.png',
          height: 250,
        ),
        SizedBox(
          height: 32,
        ),
      ],
    );
  }
}

class Helper2 extends StatelessWidget {
  const Helper2({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 16,
        ),
        Text(
          'Plain',
          style: TextStyle(
              color: Color(0xffE24F4F),
              fontSize: 32,
              fontWeight: FontWeight.w700),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          'Diary',
          style: TextStyle(
              color: Color(0xffE24F4F),
              fontSize: 24,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 32,
        ),
        Text(
          'Schedule of all affairs and events',
          style: TextStyle(
              color: Color(0xffE24F4F),
              fontSize: 16,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 16,
        ),
        Image.asset(
          'src/helper/document.png',
          height: 250,
        ),
        SizedBox(
          height: 32,
        ),
      ],
    );
  }
}

class Helper3 extends StatelessWidget {
  const Helper3({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 16,
        ),
        Text(
          'Plain',
          style: TextStyle(
              color: Color(0xffE24F4F),
              fontSize: 32,
              fontWeight: FontWeight.w700),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          'Diary',
          style: TextStyle(
              color: Color(0xffE24F4F),
              fontSize: 24,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 32,
        ),
        Text(
          'Start with a simple task',
          style: TextStyle(
              color: Color(0xffE24F4F),
              fontSize: 16,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 16,
        ),
        Image.asset(
          'src/helper/task.png',
          height: 250,
        ),
        SizedBox(
          height: 32,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            'Stop wasting time - divide your day into small tasks',
            style: TextStyle(
                color: Color(0xffE24F4F),
                fontSize: 14,
                fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}

class Helper4 extends StatelessWidget {
  const Helper4({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 16,
        ),
        Text(
          'Good',
          style: TextStyle(
              color: Color(0xffE24F4F),
              fontSize: 32,
              fontWeight: FontWeight.w700),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          'Morning',
          style: TextStyle(
              color: Color(0xffE24F4F),
              fontSize: 24,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 32,
        ),
        Text(
          'Start with a simple task',
          style: TextStyle(
              color: Color(0xffE24F4F),
              fontSize: 16,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 16,
        ),
        Image.asset(
          'src/helper/time.png',
          height: 250,
        ),
        SizedBox(
          height: 32,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            'You can change this later in the settings',
            style: TextStyle(
                color: Color(0xffE24F4F),
                fontSize: 14,
                fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}
