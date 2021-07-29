import 'package:dots_indicator/dots_indicator.dart';
import 'package:flexible/board/widgets/flexible_text.dart';
import 'package:flexible/board/widgets/glassmorph_layer.dart';
import 'package:flexible/board/widgets/weather_bg.dart';
import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flexible/utils/main_backgroung_gradient.dart';
import 'package:flexible/widgets/wide_rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HelperPage extends StatefulWidget {
  HelperPage({required this.callback});

  final VoidCallback callback;

  @override
  _HelperPageState createState() => _HelperPageState();
}

class _HelperPageState extends State<HelperPage> {
  final PageController pageController = PageController();

  onContinue() {
    // If all pages showed call
    if (pageController.page == subPages.length - 1) {
      widget.callback();
    }

    // show next subpage
    pageController.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  late final List<Widget> subPages;
  double currentPage = 0;

  @override
  void initState() {
    super.initState();
    subPages = [
      Helper2(
        callback: () => onContinue(),
      ),
      Helper1(
        callback: () => onContinue(),
      ),
      Helper4(
        callback: () => onContinue(),
      ),
      Helper5(
        callback: () => onContinue(),
      ),
      Helper3(
        callback: () => onContinue(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    pageController.addListener(() {
      setState(() {
        currentPage = pageController.page!;
      });
    });
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
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: true,
            child: Stack(children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('src/helper/backgroundimage.png'),
                    fit: BoxFit.cover,
                  ),
                ) /* add child content here */,
              ),
              buildBody(context)
            ]),
          ),
        ],
      ),
    ));
  }

  Widget buildBody(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        print(constraints);
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 16 * byWithScale(context),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(32 / hpRatio(context)),
                child: Stack(
                  children: [
                    // WeatherBg(),
                    Positioned.fill(child: GlassmorphLayer()),
                    PageView(
                        physics: BouncingScrollPhysics(),
                        controller: pageController,
                        children: subPages)
                  ],
                ),
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 60),
            //   child: WideRoundedButton(
            //     text: 'Continue',
            //     enable: true,
            //     textColor: Colors.white,
            //     enableColor: Color(0xffE24F4F),
            //     disableColor: Color(0xffE24F4F).withOpacity(0.25),
            //     callback: () => onContinue(),
            //   ),
            // ),
            SizedBox(
              height: 16 * byWithScale(context),
            ),
            DotsIndicator(
                decorator: DotsDecorator(
                    activeColor: Color(0xffE24F4F),
                    color: Color(0xffE24F4F).withOpacity(0.4)),
                dotsCount: subPages.length,
                position: currentPage)
          ],
        );
      },
    );
  }
}

class Helper1 extends StatelessWidget {
  final VoidCallback callback;

  const Helper1({
    Key? key,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(
          flex: 1,
        ),
        FlexibleText(),
        Spacer(
          flex: 2,
        ),
        Text(
          'Plain',
          style: TextStyle(
              color: Colors.white, fontSize: 32, fontWeight: FontWeight.w700),
        ),
        Text(
          'Schedule of all affairs and events',
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),
        ),
        Spacer(
          flex: 1,
        ),
        Spacer(
          flex: 4,
        ),
        Image.asset(
          'src/helper/helper.png',
          height: 300 / hpRatio(context),
        ),
        Spacer(
          flex: 3,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 60),
          child: WideRoundedButton(
            text: 'CONTINUE',
            enable: true,
            textColor: Colors.white,
            enableColor: Color(0xffE24F4F),
            disableColor: Color(0xffE24F4F).withOpacity(0.25),
            callback: () => callback(),
          ),
        ),
        SizedBox(
          height: 16 * byWithScale(context),
        ),
      ],
    );
  }
}

class Helper2 extends StatelessWidget {
  final VoidCallback callback;

  const Helper2({
    Key? key,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Spacer(
          flex: 1,
        ),
        FlexibleText(),
        Spacer(
          flex: 2,
        ),
        Text(
          'Welcome',
          style: TextStyle(
              color: Colors.white, fontSize: 32, fontWeight: FontWeight.w700),
        ),
        Text(
          'Flexible bring structure to your day',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
        ),
        Spacer(
          flex: 4,
        ),
        Image.asset(
          'src/helper/helper_second.png',
          height: 300 / hpRatio(context),
        ),
        Spacer(
          flex: 3,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 60),
          child: WideRoundedButton(
            text: 'CONTINUE',
            enable: true,
            textColor: Colors.white,
            enableColor: Color(0xffE24F4F),
            disableColor: Color(0xffE24F4F).withOpacity(0.25),
            callback: () => callback(),
          ),
        ),
        SizedBox(
          height: 16 * byWithScale(context),
        ),
      ],
    );
  }
}

class Helper3 extends StatelessWidget {
  final VoidCallback callback;

  const Helper3({
    Key? key,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Spacer(
          flex: 1,
        ),
        FlexibleText(),
        Spacer(
          flex: 2,
        ),
        Text(
          'Increase productivity',
          style: TextStyle(
              color: Colors.white, fontSize: 32, fontWeight: FontWeight.w700),
        ),
        Text(
          'Start with your first task',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
        ),
        Spacer(
          flex: 4,
        ),
        Image.asset(
          'src/helper/helper_third.png',
          height: 250 / hpRatio(context),
        ),
        Spacer(
          flex: 4,
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
        Spacer(
          flex: 3,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 60),
          child: WideRoundedButton(
            text: 'GET STARTED',
            enable: true,
            textColor: Colors.white,
            enableColor: Color(0xffE24F4F),
            disableColor: Color(0xffE24F4F).withOpacity(0.25),
            callback: () => callback(),
          ),
        ),
        SizedBox(
          height: 16 * byWithScale(context),
        )
      ],
    );
  }
}

class Helper4 extends StatelessWidget {
  final VoidCallback callback;

  const Helper4({
    Key? key,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Spacer(
          flex: 1,
        ),
        FlexibleText(),
        Spacer(
          flex: 2,
        ),
        // ignore: unrelated_type_equality_checks
        Text(
          'Good morning',
          style: TextStyle(
              color: Colors.white, fontSize: 32, fontWeight: FontWeight.w700),
        ),
        Spacer(
          flex: 1,
        ),
        Text(
          'When do you  usually wake up',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
        ),
//        Image.asset(
//          'src/helper/helper_morning.png',
//          height: 500 / hpRatio(context),
//        ),
        Container(
          height: 350 / hpRatio(context),
          child: Image.asset(
            'src/helper/helper_morning.png',
            fit: BoxFit.cover,
          ),
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
        Spacer(
          flex: 3,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 60),
          child: WideRoundedButton(
            text: 'CONTINUE',
            enable: true,
            textColor: Colors.white,
            enableColor: Color(0xffE24F4F),
            disableColor: Color(0xffE24F4F).withOpacity(0.25),
            callback: () => callback(),
          ),
        ),
        SizedBox(
          height: 16 * byWithScale(context),
        )
      ],
    );
  }
}

class Helper5 extends StatelessWidget {
  final VoidCallback callback;

  const Helper5({
    Key? key,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Spacer(
          flex: 1,
        ),
        FlexibleText(),
        Spacer(
          flex: 2,
        ),
        // ignore: unrelated_type_equality_checks
        Text(
          'Good night',
          style: TextStyle(
              color: Colors.white, fontSize: 32, fontWeight: FontWeight.w700),
        ),
        Spacer(
          flex: 1,
        ),
        Text(
          'When do you  usually wake up',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
        ),
//        Image.asset(
//          'src/helper/helper_morning.png',
//          height: 500 / hpRatio(context),
//        ),
        Container(
          height: 350 / hpRatio(context),
          child: Image.asset(
            'src/helper/helper_morning.png',
            fit: BoxFit.cover,
          ),
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
        Spacer(
          flex: 3,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 60),
          child: WideRoundedButton(
            text: 'CONTINUE',
            enable: true,
            textColor: Colors.white,
            enableColor: Color(0xffE24F4F),
            disableColor: Color(0xffE24F4F).withOpacity(0.25),
            callback: () => callback(),
          ),
        ),
        SizedBox(
          height: 16 * byWithScale(context),
        )
      ],
    );
  }
}
