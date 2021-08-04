import 'dart:async';

import 'package:flexible/authentification/bloc/auth_bloc.dart';
import 'package:flexible/board/widgets/flexible_text.dart';
import 'package:flexible/board/widgets/glassmorph_layer.dart';
import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flexible/widgets/circular_snakbar.dart';
import 'package:flexible/widgets/error_snakbar.dart';
import 'package:flexible/widgets/message_snakbar.dart';
import 'package:flexible/widgets/wide_rounded_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class CodeVerificationPage extends StatefulWidget {
  final bool afterError;

  CodeVerificationPage({Key? key, required this.afterError}) : super(key: key);

  @override
  _CodeVerificationPageState createState() => _CodeVerificationPageState();
}

class _CodeVerificationPageState extends State<CodeVerificationPage> {
  final TextEditingController pincodeController = TextEditingController();
  String pincode = '';
  String _textContent = "";
  String? appSignature;
  late Timer _timer;
  int _start = 60;
  bool _canSendAgain = false;
  bool _alwaysShowTimer = false;
  late OTPTextEditController controller;
  final scaffoldKey = GlobalKey();

  bool get pinValid {
    if (pincode.length == 6) {
      return true;
    }
    return false;
  }

  submitCode(String number) {
    BlocProvider.of<AuthBloc>(context)
        .add(VerifyCode(smsCode: pincode, number: number));
    pincodeController.clear();
  }

  onResend(String number) {
    BlocProvider.of<AuthBloc>(context).add(ResendCode(number: number));
  }

  String? otpCode;

  @override
  void initState() {
    super.initState();
    startTimer();
    OTPInteractor.getAppSignature()
    //ignore: avoid_print
        .then((value) => print('signature - $value'));
    controller = OTPTextEditController(
      codeLength: 6,

      //ignore: avoid_print
      onCodeReceive: (code) => print('Your Application receive code - $code'),
    )..startListenUserConsent(
          (code) {
        final exp = RegExp(r'(\d{6})');
        return exp.stringMatch(code ?? '') ?? '';
      },
    );
  }

  void startTimer() {
    _start = 10;
    _canSendAgain = false;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            _canSendAgain = true;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    //cancel();
    _timer.cancel();
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

  void _listenotp() async {
    await SmsAutoFill().listenForCode;
  }

  void _listenSignature() async {
    final signCode = await SmsAutoFill().getAppSignature;
    print(signCode);
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
                  child: buildBlocListenr(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBlocListenr(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authentificated) {
          Navigator.pop(context);
        }

        if (state.isBusy) {
          //    ScaffoldMessenger.of(context).showSnackBar(circularSnakbar(
          //     text: 'Processing',
          //    ));
          showTopSnackBar(
            context,
            CustomSnackBar.info(
                backgroundColor: Color(0xffE24F4F),
                icon: Icon(
                  Icons.announcement_outlined,
                  color: Colors.white,
                  size: 1,
                ),
                message:
                "Processing"
            ),
          );
        }

        if (state.error.isNotEmpty) {
          //   ScaffoldMessenger.of(context).hideCurrentSnackBar();
          //   ScaffoldMessenger.of(context).showSnackBar(errorSnakbar(
          //     text: state.error,
          //   ));
          showTopSnackBar(
            context,
            CustomSnackBar.info(
              backgroundColor: Color(0xffE24F4F),
              icon: Icon(
                Icons.announcement_outlined,
                color: Colors.white,
                size: 1,
              ),
              message:
              state.error,
            ),
          );
        }

        if (state.message.isNotEmpty) {
          //   ScaffoldMessenger.of(context).hideCurrentSnackBar();
          //  ScaffoldMessenger.of(context).showSnackBar(messageSnakbar(
          //    text: state.message,
          //   ));
          showTopSnackBar(
            context,
            CustomSnackBar.info(
              backgroundColor: Color(0xffE24F4F),
              icon: Icon(
                Icons.announcement_outlined,
                color: Colors.white,
                size: 1,
              ),
              message:
              state.message,
            ),
          );
        }
      },
      child: buildBody(context),
      // child: Stack(children: [

      //   Padding(
      //     padding: EdgeInsets.only(bottom: 10 * byWithScale(context)),
      //     child: Align(
      //       alignment: Alignment.bottomCenter,
      //       child: Wrap(
      //         children: [
      //           Text(
      //             'Dont get it?',
      //             style: TextStyle(
      //               fontSize: 11 * byWithScale(context),
      //             ),
      //           ),
      //           Text(
      //             'Send it again?',
      //             style: TextStyle(
      //               decoration: TextDecoration.underline,
      //               color: Color(0xffE24F4F),
      //               fontSize: 11 * byWithScale(context),
      //             ),
      //           ),
      //           BlocBuilder<AuthBloc, AuthState>(
      //             builder: (context, state) {
      //               if (state is CodeSended) {
      //                 return GestureDetector(
      //                   onTap: () =>
      //                       !state.isBusy ? onResend(state.number) : {},
      //                   child: Text(
      //                     'Send again',
      //                     style: TextStyle(
      //                         color: state.isBusy
      //                             ? Color(0xffE24F4F).withOpacity(0.25)
      //                             : Color(0xffE24F4F),
      //                         fontSize: 12 * byWithScale(context),
      //                         fontWeight: FontWeight.w400),
      //                   ),
      //                 );
      //               }
      //               return SizedBox();
      //             },
      //           )
      //         ],
      //       ),
      //     ),
      //   ),
      // ]),
    );
  }

  Column buildBody(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 16 * byWithScale(context),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(16 * byWithScale(context)),
            child: Stack(
              children: [
                Positioned.fill(child: GlassmorphLayer()),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 16 * byWithScale(context),
                    ),
                    FlexibleText(),
                    Text(
                      'SMS protection',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15 * byWithScale(context),
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
                                borderRadius:
                                BorderRadius.all(Radius.circular(20)),
                                fieldHeight: 33 * byWithScale(context),
                                fieldWidth: 29 * byWithScale(context),
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
                              controller: controller,
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
                          Visibility(
                            visible: _alwaysShowTimer,
                            child: Visibility(
                              child: Text(
                                  " You can resend code per $_start seconds"),
                              visible: !_canSendAgain,
                            ),
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
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16 * byWithScale(context),
                    ),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        if (state is CodeSended) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 60),
                            child: WideRoundedButton(
                              text: 'Continue',
                              enable: !state.isBusy ? pinValid : false,
                              textColor: Colors.white,
                              enableColor: Color(0xffE24F4F),
                              disableColor: Color(0xffE24F4F).withOpacity(0.25),
                              callback: () => submitCode(state.number),
                            ),
                          );
                        }
                        return SizedBox();
                      },
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
              padding: EdgeInsets.only(bottom: 10 * byWithScale(context)),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Wrap(
                  children: [
                    Text(
                      'Dont get it? ',
                      style: TextStyle(
                        fontSize: 11 * byWithScale(context),
                      ),
                    ),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        if (state is CodeSended) {
                          return GestureDetector(
                            onTap: () {
                              if (_canSendAgain) {
                                startTimer();
                                _alwaysShowTimer = true;
                                print(_canSendAgain);
                                setState(() {

                                });
                                !state.isBusy ? onResend(state.number) : {};
                              } else {
                                showTopSnackBar(
                                  context,
                                  CustomSnackBar.info(
                                    backgroundColor: Color(0xffE24F4F),
                                    icon: Icon(
                                      Icons.announcement_outlined,
                                      color: Colors.white,
                                      size: 1,
                                    ),
                                    message:
                                    "You can do it per $_start seconds",
                                  ),
                                );
                              }
                            },
                            child: Text(
                              'Send again',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: _canSendAgain
                                      ? Color(0xffE24F4F)
                                      : Colors.grey,
                                  fontSize: 12 * byWithScale(context),
                                  fontWeight: FontWeight.w400),
                            ),
                          );
                        }
                        return SizedBox();
                      },
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 8 * byWithScale(context),
            ),
          ],
        )
      ],
    );
  }
}
