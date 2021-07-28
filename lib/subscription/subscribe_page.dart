import 'dart:ui';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flexible/authentification/code_verification_page.dart';
import 'package:flexible/authentification/sign_in_page.dart';
import 'package:flexible/authentification/terms_of_use.dart';
import 'package:flexible/board/widgets/glassmorph_layer.dart';
import 'package:flexible/board/widgets/weather_bg.dart';
import 'package:flexible/helper/helper_page.dart';
import 'package:flexible/helper/helper_wrapper.dart';
import 'package:flexible/subscription/bloc/subscribe_bloc.dart';
import 'package:flexible/subscription/subscription_wrapper.dart';
import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flexible/utils/main_backgroung_gradient.dart';
import 'package:flexible/widgets/wide_rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubscribePage extends StatefulWidget {
  SubscribePage({Key? key}) : super(key: key);

  @override
  _SubscribePageState createState() => _SubscribePageState();
}

class _SubscribePageState extends State<SubscribePage> {
  final RemoteConfig remoteConfig = RemoteConfig.instance;

  noThx() {
    var state = BlocProvider.of<SubscribeBloc>(context).state;
    if (state is AskForSubscribe && state.showAreYouSurePopup) {
      ScaffoldMessenger.of(context).showSnackBar(auSure(context, onYes: () {
        BlocProvider.of<SubscribeBloc>(context).add(Decline());
      }));
      print('show ppp');
    }
    // BlocProvider.of<SubscribeBloc>(context).add(Decline());
  }

  restoreSub() {
    BlocProvider.of<SubscribeBloc>(context).add(Restore());
  }

  subscribe() {
    BlocProvider.of<SubscribeBloc>(context).add(Subscribe());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        gradient: mainBackgroundGradient,
      ),
      child: SafeArea(
          child: Stack(
        children: [
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
          buildBody(context),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                  left: 48 * byWithScale(context),
                  right: 48 * byWithScale(context),
                  bottom: 8 * byWithScale(context)),
              child: WideRoundedButton(
                  enable: true,
                  fontSizw: 15,
                  enableColor: Colors.transparent,
                  textColor: Color(0xffE24F4F),
                  text: 'NO,THANKS',
                  disableColor: Color(0xffE24F4F).withOpacity(0.25),
                  callback: () => Navigator.push(
                        context,
                        //MaterialPageRoute(builder: (context) => HelperWrapper(child: Container(color: Colors.green,))),
                        MaterialPageRoute(builder: (context) => noThx()),
                      )),
            ),
          ),
        ],
      )),
    ));
  }

  Widget buildBody(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          right: 50 / pRatio(context),
          left: 50 / pRatio(context),
          top: 40 / pRatio(context),
          bottom: 190 / pRatio(context)),
      child: Stack(
        children: [
          Positioned.fill(child: GlassmorphLayer()),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [

//              Padding(
//                padding:
//                    EdgeInsets.symmetric(horizontal: 12 * byWithScale(context)),
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: [
////                    GestureDetector(
////                      onTap: () {
////                        BlocProvider.of<SubscribeBloc>(context).add(Decline());
////                      },
////                      child: Image.asset(
////                        'src/icons/return.png',
////                        width: 20 * byWithScale(context),
////                      ),
////                    ),
//                    BlocBuilder<SubscribeBloc, SubscribeState>(
//                      builder: (context, state) {
//                        if (state is AskForSubscribe && state.showInfoPopup) {
//                          return GestureDetector(
//                              onTap: () {
//                                Navigator.push(
//                                    context,
//                                    CupertinoPageRoute(
//                                      builder: (context) => TermsPage(),
//                                    ));
//                              },
//                              child: Icon(Icons.info));
//                        }
//                        return SizedBox();
//                      },
//                    )
//                  ],
//                ),
//              ),
              Center(
                  child: Text(
                    "Flexible",
                style: TextStyle(
                    fontSize: 35 * byWithScale(context),
                    fontWeight: FontWeight.w900,
                    color: Color(0xffE24F4F)),
                  )),
              Center(
                child: Text(
                  'Thanks for using the app!',
                  style: TextStyle(
                      fontSize: 18 * byWithScale(context),
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
              Spacer(
                flex: 5,
              ),
              buildTip(context,
                  title: 'Stay on track with reminders',
                  subtitle:
                      'Get notifications when a task starts end ends.You can even complete tasks without opening the app                             '),
              Spacer(
                flex: 1,
              ),
              buildTip(context,
                  title: 'Import calendar events',
                  subtitle:
                      'Automatically add your calendar events to your day plan.'),
              Spacer(
                flex: 1,
              ),
              buildTip(context,
                  title: 'Plan recurring events',
                  subtitle:
                      'Repeat events daily , on certain weekdays, weekly or monthly.'),
              Spacer(
                flex: 1,
              ),
              buildTip(context,
                  title: 'Support the development',
                  subtitle: 'Help me continue working on improving Flexible.'),
              Spacer(
                flex: 1,
              ),

              Spacer(
                flex: 1,
              ),
              Padding(
                padding:
                EdgeInsets.symmetric(horizontal: 30 * byWithScale(context)),
                child: WideRoundedButton(
                  enable: true,
                  fontSizw: 15,
                  enableColor: Color(0xffE24F4F),
                  textColor: Colors.white,
                  text: 'SUBSCRIBE',
                  disableColor: Color(0xffE24F4F).withOpacity(0.25),
                  callback: () => subscribe(),
                ),
              ),
              SizedBox(
                height: 10 * byWithScale(context),
              ),
              Padding(
                padding:
                EdgeInsets.symmetric(horizontal: 30 * byWithScale(context)),
                child: WideRoundedButton(
                  enable: true,
                  fontSizw: 15,
                  enableColor: Color(0xffE24F4F),
                  textColor: Colors.white,
                  text: 'RESTORE PURCHASHES',
                  disableColor: Color(0xffE24F4F).withOpacity(0.25),
                  callback: () => restoreSub(),
                ),
              ),
              SizedBox(
                height: 10 * byWithScale(context),
              ),
            ],
          )
        ],
      ),
    );
  }

  Column buildTip(BuildContext context,
      {required String title, required String subtitle}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20 * byWithScale(context)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 3.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Image.asset(
                    'src/icons/done.png',
                    width: 13 * byWithScale(context),
                    color: Colors.red,
                    fit: BoxFit.fitWidth,
                  ),),
              ),
              SizedBox(
                width: 15,
              ),
              Wrap(
                direction: Axis.vertical,
                //mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 13 * byWithScale(context),
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 55,
                    width: 200 * byWithScale(context),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          subtitle,
                          maxLines: 5,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                              fontSize: 11 * byWithScale(context),
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: 2 * byWithScale(context),
        ),
      ],
    );
  }
}

SnackBar auSure(BuildContext context, {required Function onYes}) {
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
              Text('Are you sure?',
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
                      // BlocProvider.of<DailytasksBloc>(context)
                      //     .add(DailytasksSuperInsert());
                      // ScaffoldMessenger.of(context).hideCurrentSnackBar();

                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      onYes();
                    },
                    child: Text('Yes',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14 * byWithScale(context))),
                  ),
                  GestureDetector(
                    onTap: () {
                      // ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
