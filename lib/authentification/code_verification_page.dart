import 'dart:async';

import 'package:flexible/authentification/bloc/auth_bloc.dart';
import 'package:flexible/board/widgets/glassmorph_layer.dart';
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
                        SizedBox(
                          height: 500,
                          child: Column(
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
                                height: 128,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: PinCodeTextField(
                                  keyboardType: TextInputType.number,
                                  length: 6,
                                  obscureText: false,
                                  animationType: AnimationType.fade,
                                  pinTheme: PinTheme(
                                    shape: PinCodeFieldShape.box,
                                    borderRadius: BorderRadius.circular(20),
                                    fieldHeight: 40,
                                    fieldWidth: 40,
                                    inactiveColor: Colors.grey[300],
                                    disabledColor: Colors.grey[200],
                                    activeFillColor: Colors.white,
                                    inactiveFillColor: Colors.white,
                                    selectedFillColor: Colors.white,
                                    activeColor: Colors.grey[200],
                                    selectedColor: Color(0xffE24F4F),
                                  ),
                                  animationDuration:
                                      Duration(milliseconds: 100),
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
                                height: 16,
                              ),
                              widget.afterError
                                  ? Text(
                                      'Invalid code',
                                      style: TextStyle(
                                          color: Color(0xffE24F4F),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    )
                                  : SizedBox(),
                              SizedBox(
                                height: 16,
                              ),
                              Wrap(
                                children: [
                                  Text(
                                    'Didnt receive sms? ',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () =>
                                        !resendOnTimeout ? onResend() : {},
                                    child: Text(
                                      'Send again',
                                      style: TextStyle(
                                          color: resendOnTimeout
                                              ? Color(0xffE24F4F)
                                                  .withOpacity(0.25)
                                              : Color(0xffE24F4F),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 32,
                              ),
                            ],
                          ),
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
                          enable: pinValid,
                          textColor: Colors.white,
                          enableColor: Color(0xffE24F4F),
                          disableColor: Color(0xffE24F4F).withOpacity(0.25),
                          callback: () => submitCode(),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 60),
                        child: WideRoundedButton(
                          text: 'Cancel',
                          enable: true,
                          textColor: Colors.white,
                          enableColor: Color(0xffE24F4F),
                          disableColor: Color(0xffE24F4F).withOpacity(0.25),
                          callback: () {
                            BlocProvider.of<AuthBloc>(context)
                                .add(GoToRegistration());
                          },
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
