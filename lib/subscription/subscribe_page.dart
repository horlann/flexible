import 'dart:ui';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flexible/board/task_editor/row_with_close_btn.dart';
import 'package:flexible/board/widgets/glassmorph_layer.dart';
import 'package:flexible/subscription/bloc/subscribe_bloc.dart';
import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flexible/utils/main_backgroung_gradient.dart';
import 'package:flexible/widgets/wide_rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubscribePage extends StatelessWidget {
  SubscribePage({Key? key}) : super(key: key);
  final RemoteConfig remoteConfig = RemoteConfig.instance;

  @override
  Widget build(BuildContext context) {
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
    return Padding(
      padding: EdgeInsets.all(64 / pRatio(context)),
      child: Stack(
        children: [
          Positioned.fill(child: GlassmorphLayer()),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 12 * byWithScale(context),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 12 * byWithScale(context)),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        BlocProvider.of<SubscribeBloc>(context).add(Decline());
                      },
                      child: Image.asset(
                        'src/icons/return.png',
                        width: 20 * byWithScale(context),
                      ),
                    )
                  ],
                ),
              ),
              Spacer(
                flex: 1,
              ),
              Text(
                'Thanks for using the app!',
                style: TextStyle(
                    fontSize: 20 * byWithScale(context),
                    fontWeight: FontWeight.w600,
                    color: Color(0xffE24F4F)),
              ),
              Spacer(
                flex: 1,
              ),
              Text(
                'Text',
                style: TextStyle(
                    fontSize: 18 * byWithScale(context),
                    fontWeight: FontWeight.w400,
                    color: Color(0xffE24F4F)),
              ),
              Spacer(
                flex: 1,
              ),
              buildTip(context,
                  title: 'Stay on track with reminders',
                  subtitle:
                      'Get notifications when a task starts and ends. You can even complete tasks without opening the app.'),
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
              Image.asset(
                'src/yoga.png',
                width: 60 * byWithScale(context),
              ),
              Spacer(
                flex: 1,
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 10 * byWithScale(context)),
                child: WideRoundedButton(
                  enable: true,
                  enableColor: Color(0xffE24F4F),
                  textColor: Colors.white,
                  text: 'Subscribe',
                  disableColor: Color(0xffE24F4F).withOpacity(0.25),
                  callback: () {
                    BlocProvider.of<SubscribeBloc>(context).add(Subscribe());
                  },
                ),
              ),
              SizedBox(
                height: 10 * byWithScale(context),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 10 * byWithScale(context)),
                child: WideRoundedButton(
                  enable: true,
                  enableColor: Colors.transparent,
                  borderColor: Color(0xffE24F4F),
                  textColor: Color(0xffE24F4F),
                  text: 'No thanks',
                  disableColor: Color(0xffE24F4F).withOpacity(0.25),
                  callback: () {
                    BlocProvider.of<SubscribeBloc>(context).add(Decline());
                  },
                ),
              ),
              Spacer(
                flex: 1,
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
          padding: EdgeInsets.symmetric(horizontal: 10 * byWithScale(context)),
          child: Row(
            children: [
              Image.asset(
                'src/icons/Message.png',
                width: 14 * byWithScale(context),
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                title,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 10 * byWithScale(context),
                    fontWeight: FontWeight.w600,
                    color: Color(0xff373535)),
              )
            ],
          ),
        ),
        SizedBox(
          height: 2 * byWithScale(context),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10 * byWithScale(context)),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              subtitle,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 8 * byWithScale(context),
                  fontWeight: FontWeight.w400,
                  color: Color(0xff373535)),
            ),
          ),
        )
      ],
    );
  }
}
