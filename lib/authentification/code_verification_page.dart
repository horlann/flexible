import 'package:flexible/authentification/bloc/auth_bloc.dart';
import 'package:flexible/board/widgets/glassmorph_layer.dart';
import 'package:flexible/utils/main_backgroung_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CodeVerificationPage extends StatefulWidget {
  CodeVerificationPage({Key? key}) : super(key: key);

  @override
  _CodeVerificationPageState createState() => _CodeVerificationPageState();
}

class _CodeVerificationPageState extends State<CodeVerificationPage> {
  final TextEditingController pincodeController = TextEditingController();
  String pincode = '';

  bool get pinValid {
    if (pincode.length == 6) {
      return true;
    }
    return false;
  }

  submitCode() {
    BlocProvider.of<AuthBloc>(context).add(VerifyCode(smsCode: pincode));
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
                                      Duration(milliseconds: 300),
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
                      GestureDetector(
                        onTap: () => pinValid ? submitCode() : {},
                        child: Container(
                          height: 40,
                          width: double.maxFinite,
                          margin: EdgeInsets.symmetric(horizontal: 40),
                          decoration: BoxDecoration(
                              color: pinValid
                                  ? Color(0xffE24F4F)
                                  : Color(0xffE24F4F).withOpacity(0.40),
                              borderRadius: BorderRadius.circular(30)),
                          child: Center(
                            child: Text(
                              'Continue',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      )
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
