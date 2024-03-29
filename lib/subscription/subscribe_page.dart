import 'dart:ui';

import 'package:flexible/board/widgets/glassmorph_layer.dart';
import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flexible/widgets/wide_rounded_button.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/subscribe_bloc.dart';

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
    } else {
      BlocProvider.of<SubscribeBloc>(context).add(Decline());
    }
  }

  restoreSub() {
    BlocProvider.of<SubscribeBloc>(context).add(Restore());
  }

  subscribe() {
    BlocProvider.of<SubscribeBloc>(context).add(Subscribe());
  }

  @override
  Widget build(BuildContext context) {
    double safeTopPadding = MediaQuery.of(context).padding.top;
    double safeBottomPadding = MediaQuery.of(context).padding.bottom;

    // This trick uses for expand content by display size
    // and provide scroll when keyboard is opens over fields
    // + bonus calc safe area
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SizedBox.expand(
        child: Container(
          //color: Colors.lightBlueAccent,
          decoration: BoxDecoration(
              // gradient: mainBackgroundGradient,
              image: DecorationImage(
                  image: AssetImage('src/helper/backgroundimage.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter)),
          child: SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        safeTopPadding -
                        safeBottomPadding),
                child: IntrinsicHeight(
                  child: buildBody(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          right: 50 / pRatio(context),
          left: 50 / pRatio(context),
          top: 40 / pRatio(context),
          bottom: 40 / pRatio(context)),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(child: GlassmorphLayer()),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Spacer(
                      flex: 1,
                    ),
                    Center(
                        child: Text(
                      "Flexible",
                      style: TextStyle(
                          fontSize: 32 * byWithScale(context),
                          fontWeight: FontWeight.w900,
                          color: Color(0xffE24F4F)),
                    )),
                    Center(
                      child: Text(
                        'Thanks for using the app!',
                        style: TextStyle(
                            fontSize: 20 * byWithScale(context),
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
                            'Get notifications when a task starts end ends.You can even complete tasks without opening the app'),
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
                        subtitle:
                            'Help me continue working on improving Flexible.'),
                    Spacer(
                      flex: 1,
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    Center(
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30 * byWithScale(context)),
                            child: BlocBuilder<SubscribeBloc, SubscribeState>(
                                builder: (context, state) {
                              String add_text = "";
                              String add_text1 = "";
                              if (state is AskForSubscribe) {
//                                print(state.products.first.prettyPrice
//                                        .toString() +
//                                    " k");

                                if (state.isscConfig.isNotEmpty &&
                                    state.products.isNotEmpty) {
                                  add_text =
                                      state.isscConfig.first.lineabovepricetext;
                                  add_text1 =
                                      "${state.products.first.prettyPrice} ${state.isscConfig.first.subscriptionduration} ${state.isscConfig.first.postpricetext}";
                                }
                              }
                              if (add_text.isEmpty) {
                                add_text = "Connection error";
                              }
                              if (add_text1.isEmpty) {
                                add_text1 = "Connection error";
                              }

                              return Column(
                                children: [
                                  Text(
                                    add_text,
                                    style: TextStyle(
                                        fontSize: 9* byWithScale(context),
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    add_text1,
                                    style: TextStyle(
                                        fontSize: 9 * byWithScale(context),
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                ],
                              );
                            }))),
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 30 * byWithScale(context)),
                        child: BlocBuilder<SubscribeBloc, SubscribeState>(
                            builder: (context, state) {
                          String button_text = "SUBSCRIBE";
                          if (state is AskForSubscribe) {
                            if (state.isscConfig.isNotEmpty) {
                              print(
                                  "InnerSalesScreenConfig is ${state.isscConfig}");
                              button_text = state.isscConfig.first.buttontitle;
                            }
                          }
                          return WideRoundedButton(
                            enable: true,
                            fontSizw: 18 ~/ byWithScale(context),
                            enableColor: Color(0xffE24F4F),
                            textColor: Colors.white,
                            text: button_text,
                            disableColor: Color(0xffE24F4F).withOpacity(0.25),
                            callback: () => subscribe(),
                          );
                        })),
                    Spacer(
                      flex: 1,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30 * byWithScale(context)),
                      child: WideRoundedButton(
                        enable: true,
                        fontSizw: 18 ~/ byWithScale(context),
                        enableColor: Color(0xffE24F4F),
                        textColor: Colors.white,
                        text: 'RESTORE PURCHASES ',
                        disableColor: Color(0xffE24F4F).withOpacity(0.25),
                        callback: () => restoreSub(),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    GestureDetector(
                        onTap: () {
                          BlocProvider.of<SubscribeBloc>(context)
                              .add(DebugRestore());
                        },
                        child: Text('Debug restore')),
                    Spacer(
                      flex: 2,
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 40 / pRatio(context),
          ),
          WideRoundedButton(
              enable: true,
              fontSizw: 18 ~/ byWithScale(context),
              enableColor: Colors.transparent,
              textColor: Color(0xffE24F4F),
              text: 'NO,THANKS',
              disableColor: Color(0xffE24F4F).withOpacity(0.25),
              callback: () =>  noThx()),
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
                  ),
                ),
              ),
              SizedBox(
                width: 8 * byWithScale(context),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 11 * byWithScale(context),
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    IntrinsicWidth(
                      child: Text(
                        subtitle,
                        maxLines: 5,
                        overflow: TextOverflow.fade,
                        softWrap: true,
                        style: TextStyle(
                            fontSize: 11 * byWithScale(context),
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
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
          child: Stack(
            children: [
              Container(
                  height: 70,
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            onYes();
                          },
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                        ),
                      ),
                    ],
                  )),
              Column(
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
            ],
          ),
        ),
      ));
}
