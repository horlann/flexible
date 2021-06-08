import 'package:flexible/board/widgets/glassmorph_layer.dart';
import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flexible/utils/main_backgroung_gradient.dart';
import 'package:flexible/widgets/wide_rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    // Lock portreit mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    print(MediaQuery.of(context).size.shortestSide);
    print(MediaQuery.of(context).devicePixelRatio);

    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        gradient: mainBackgroundGradient,
      ),
      child: SafeArea(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: true,
              child: buildBody(context),
            ),
          ],
        ),
      ),
    ));
  }

  Widget buildBody(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double helpHeight() {
          if (constraints.maxHeight > 600) {
            return 500;
          }
          if (constraints.maxHeight > 500) {
            return 450;
          }
          return 400;
        }

        print(constraints);
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 16 * byWithScale(context),
            ),
            Text(
              'fleXible',
              style: TextStyle(
                  color: Color(0xffE24F4F),
                  fontSize: 32,
                  fontWeight: FontWeight.w700),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(32 / hpRatio(context)),
                child: Stack(
                  children: [
                    Positioned.fill(child: GlassmorphLayer()),
                    SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      child: SizedBox(
                        height: helpHeight(),
                        width: double.maxFinite,
                        child: PageView(
                            physics: BouncingScrollPhysics(),
                            controller: pageController,
                            children: subPages),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 60),
              child: WideRoundedButton(
                text: 'Continue',
                enable: true,
                textColor: Colors.white,
                enableColor: Color(0xffE24F4F),
                disableColor: Color(0xffE24F4F).withOpacity(0.25),
                callback: () => onContinue(),
              ),
            ),
            SizedBox(
              height: 16 * byWithScale(context),
            ),
          ],
        );
      },
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
          height: 16 / hpRatio(context),
        ),
        Text(
          'Welcome',
          style: TextStyle(
              color: Color(0xffE24F4F),
              fontSize: 32,
              fontWeight: FontWeight.w700),
        ),
        SizedBox(
          height: 8 / hpRatio(context),
        ),
        Text(
          'Flexible',
          style: TextStyle(
              color: Color(0xffE24F4F),
              fontSize: 24,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 32 / hpRatio(context),
        ),
        Text(
          'Bring structure to your day',
          style: TextStyle(
              color: Color(0xffE24F4F),
              fontSize: 16,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 16 / hpRatio(context),
        ),
        Image.asset(
          'src/helper/wtf.png',
          height: 300 / hpRatio(context),
        ),
        SizedBox(
          height: 32 / hpRatio(context),
        ),
      ],
    );
    ;
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
          height: 16 / hpRatio(context),
        ),
        Text(
          'Plain',
          style: TextStyle(
              color: Color(0xffE24F4F),
              fontSize: 32,
              fontWeight: FontWeight.w700),
        ),
        SizedBox(
          height: 8 / hpRatio(context),
        ),
        Text(
          'Diary',
          style: TextStyle(
              color: Color(0xffE24F4F),
              fontSize: 24,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 32 / hpRatio(context),
        ),
        Text(
          'Schedule of all affairs and events',
          style: TextStyle(
              color: Color(0xffE24F4F),
              fontSize: 16,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 16 / hpRatio(context),
        ),
        Image.asset(
          'src/helper/document.png',
          height: 300 / hpRatio(context),
        ),
        SizedBox(
          height: 32 / hpRatio(context),
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
          height: 16 / hpRatio(context),
        ),
        Text(
          'Plain',
          style: TextStyle(
              color: Color(0xffE24F4F),
              fontSize: 32,
              fontWeight: FontWeight.w700),
        ),
        SizedBox(
          height: 8 / hpRatio(context),
        ),
        Text(
          'Diary',
          style: TextStyle(
              color: Color(0xffE24F4F),
              fontSize: 24,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 32 / hpRatio(context),
        ),
        Text(
          'Start with a simple task',
          style: TextStyle(
              color: Color(0xffE24F4F),
              fontSize: 16,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 16 / hpRatio(context),
        ),
        Image.asset(
          'src/helper/task.png',
          height: 250 / hpRatio(context),
        ),
        SizedBox(
          height: 16 / hpRatio(context),
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
          height: 16 / hpRatio(context),
        ),
        Text(
          'Good',
          style: TextStyle(
              color: Color(0xffE24F4F),
              fontSize: 32,
              fontWeight: FontWeight.w700),
        ),
        SizedBox(
          height: 8 / hpRatio(context),
        ),
        Text(
          'Morning',
          style: TextStyle(
              color: Color(0xffE24F4F),
              fontSize: 24,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 32 / hpRatio(context),
        ),
        Text(
          'Start with a simple task',
          style: TextStyle(
              color: Color(0xffE24F4F),
              fontSize: 16,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 16 / hpRatio(context),
        ),
        Image.asset(
          'src/helper/time.png',
          height: 250 / hpRatio(context),
        ),
        SizedBox(
          height: 32 / hpRatio(context),
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
