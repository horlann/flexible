import 'package:flexible/board/task_editor/row_with_close_btn.dart';
import 'package:flexible/board/widgets/flexible_text.dart';
import 'package:flexible/board/widgets/glassmorph_layer.dart';
import 'package:flexible/board/widgets/weather_bg.dart';
import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flexible/utils/main_backgroung_gradient.dart';
import 'package:flexible/widgets/wide_rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TermsPage extends StatefulWidget {
  TermsPage();

  @override
  _TermsPageState createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  late final PageController pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  final List<Widget> subPages = [
    Terms(),
    Privacy(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xffE9E9E9),
      body: SizedBox.expand(
        child: Center(
          child: Container(
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              gradient: mainBackgroundGradient,
            ),
            child: Stack(
              children: [
                Container(
                  child: WeatherBg(),
                  width: double.infinity,
                  height: double.infinity,
                ),
                SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(10 * byWithScale(context)),
                          child: Stack(
                            children: [
                              Positioned.fill(child: GlassmorphLayer()),
                              Align(
                                  alignment: Alignment.topCenter,
                                  child: FlexibleText()),
                              SizedBox(
                                // height: 500,
                                width: double.maxFinite,
                                child: PageView(
                                  physics: BouncingScrollPhysics(),
                                  onPageChanged: (value) {
                                    setState(() {
                                      _currentPage = value;
                                    });
                                  },
                                  controller: pageController,
                                  children: subPages,
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  height: byWithScale(context) * 35,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 60 * byWithScale(context)),
                                    child: WideRoundedButton(
                                      enable: true,
                                      fontSizw: 15,
                                      enableColor: Color(0xffE24F4F),
                                      textColor: Colors.white,
                                      text: 'CLOSE',
                                      disableColor:
                                          Color(0xffE24F4F).withOpacity(0.25),
                                      callback: () => Navigator.pop,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(subPages.length, (index) {
                          if (_currentPage == index) {
                            return Container(
                              width: 10,
                              height: 6,
                              margin: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  color: Color(0xffE24F4F),
                                  borderRadius: BorderRadius.circular(3)),
                            );
                          }
                          return Container(
                            width: 6,
                            height: 6,
                            margin: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                color: Color(0xffE24F4F).withOpacity(0.5),
                                borderRadius: BorderRadius.circular(6)),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Terms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50 * byWithScale(context),
        ),
        Text(
          'Terms of use',
          style: TextStyle(
              color: Colors.white,
              fontSize: 16 * byWithScale(context),
              fontWeight: FontWeight.w700),
        ),
        SizedBox(
          height: 4 * byWithScale(context),
        ),
        Flexible(
          child: Container(
            //height: 250,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  '"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 11 * byWithScale(context),
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 32,
        ),
      ],
    );
  }
}

class Privacy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50 * byWithScale(context),
        ),
        Text(
          'Privacy policy',
          style: TextStyle(
              color: Colors.white,
              fontSize: 16 * byWithScale(context),
              fontWeight: FontWeight.w700),
        ),
        SizedBox(
          height: 4 * byWithScale(context),
        ),
        Flexible(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                '"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 11 * byWithScale(context),
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ),

      ],
    );
  }
}
