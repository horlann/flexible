import 'dart:async';

import 'package:flexible/authentification/bloc/auth_bloc.dart';
import 'package:flexible/board/widgets/glassmorph_layer.dart';
import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flexible/utils/main_backgroung_gradient.dart';
import 'package:flexible/widgets/wide_rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CodeVerificationPage extends StatefulWidget {
  final bool afterError;
  CodeVerificationPage({Key? key, required this.afterError}) : super(key: key);

  @override
  _CodeVerificationPageState createState() => _CodeVerificationPageState();
}

class _CodeVerificationPageState extends State<CodeVerificationPage> {
  final TextEditingController pincodeController = TextEditingController();
  String pincode = '';
  bool resendOnTimeout = false;

  bool get pinValid {
    if (pincode.length == 6) {
      return true;
    }
    return false;
  }

  submitCode() {
    BlocProvider.of<AuthBloc>(context).add(VerifyCode(smsCode: pincode));
    pincodeController.clear();
  }

  onResend() {
    BlocProvider.of<AuthBloc>(context).add(ResendCode());
    startResendTimeout();
  }

  startResendTimeout() {
    setState(() {
      resendOnTimeout = true;
      print('timeout');
    });
    Timer(Duration(seconds: 20), () {
      if (this.mounted) {
        setState(() {
          resendOnTimeout = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startResendTimeout();
  }

  @override
  void didUpdateWidget(covariant CodeVerificationPage oldWidget) {
    print('asdasd');
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    print('asdasd');
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double safeTopPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      // backgroundColor: Color(0xffE9E9E9),
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            gradient: mainBackgroundGradient,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight:
                        MediaQuery.of(context).size.height - safeTopPadding),
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

  Column buildBody(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 16 * byWithScale(context),
        ),
        Text(
          'fleXible',
          style: TextStyle(
              color: Color(0xffE24F4F),
              fontSize: 24 * byWithScale(context),
              fontWeight: FontWeight.w700),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(16 * byWithScale(context)),
            child: Stack(
              children: [
                Positioned.fill(child: GlassmorphLayer()),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 16 * byWithScale(context),
                    ),
                    Text(
                      'SMS protection',
                      style: TextStyle(
                          color: Color(0xffE24F4F),
                          fontSize: 20 * byWithScale(context),
                          fontWeight: FontWeight.w700),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: PinCodeTextField(
                              keyboardType: TextInputType.number,
                              length: 6,
                              obscureText: false,
                              animationType: AnimationType.fade,
                              textStyle: TextStyle(
                                  fontSize: 14 * byWithScale(context)),
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(20),
                                fieldHeight: 32 * byWithScale(context),
                                fieldWidth: 32 * byWithScale(context),
                                inactiveColor: Colors.grey[300],
                                disabledColor: Colors.grey[200],
                                activeFillColor: Colors.white,
                                inactiveFillColor: Colors.white,
                                selectedFillColor: Colors.white,
                                activeColor: Colors.grey[200],
                                selectedColor: Color(0xffE24F4F),
                              ),
                              animationDuration: Duration(milliseconds: 100),
                              enableActiveFill: true,
                              controller: pincodeController,
                              onCompleted: (v) {
                                print("Completed");
                              },
                              onChanged: (value) {
                                print(value);
                                setState(() {
                                  pincode = value;
                                });
                              },
                              appContext: context,
                            ),
                          ),
                          SizedBox(
                            height: 8 * byWithScale(context),
                          ),
                          widget.afterError
                              ? Text(
                                  'Invalid code',
                                  style: TextStyle(
                                      color: Color(0xffE24F4F),
                                      fontSize: 12 * byWithScale(context),
                                      fontWeight: FontWeight.w400),
                                )
                              : SizedBox(),
                          SizedBox(
                            height: 8 * byWithScale(context),
                          ),
                          Wrap(
                            children: [
                              Text(
                                'Didnt receive sms? ',
                                style: TextStyle(
                                  fontSize: 12 * byWithScale(context),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => !resendOnTimeout ? onResend() : {},
                                child: Text(
                                  'Send again',
                                  style: TextStyle(
                                      color: resendOnTimeout
                                          ? Color(0xffE24F4F).withOpacity(0.25)
                                          : Color(0xffE24F4F),
                                      fontSize: 12 * byWithScale(context),
                                      fontWeight: FontWeight.w400),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16 * byWithScale(context),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: WideRoundedButton(
                text: 'Continue',
                enable: pinValid,
                textColor: Colors.white,
                enableColor: Color(0xffE24F4F),
                disableColor: Color(0xffE24F4F).withOpacity(0.25),
                callback: () => submitCode(),
              ),
            ),
            SizedBox(
              height: 8 * byWithScale(context),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 60),
            //   child: WideRoundedButton(
            //     text: 'Cancel',
            //     enable: true,
            //     textColor: Colors.white,
            //     enableColor: Color(0xffE24F4F),
            //     disableColor: Color(0xffE24F4F).withOpacity(0.25),
            //     callback: () {
            //       BlocProvider.of<AuthBloc>(context).add(GoToRegistration());
            //     },
            //   ),
            // ),
          ],
        )
      ],
    );
  }
}
