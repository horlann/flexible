import 'dart:async';

import 'package:flexible/authentification/bloc/auth_bloc.dart';
import 'package:flexible/authentification/country_code_picker.dart';
import 'package:flexible/board/widgets/glassmorph_layer.dart';
import 'package:flexible/utils/main_backgroung_gradient.dart';
import 'package:flexible/utils/validators.dart';
import 'package:flexible/widgets/wide_rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  MaskedTextController controller = MaskedTextController(mask: '00-000-00-00');
  FocusNode focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  String phoneNumber = '';
  String countryCode = '';
  bool isSignButtonTimeout = false;

  bool get submitActive => phoneNumber.isNotEmpty & !isSignButtonTimeout;

  onSignin() {
    if (_formKey.currentState!.validate()) {
      // Prevent multiple click to submit button before captcha is show
      setState(() {
        isSignButtonTimeout = true;
        print('timeout');
      });
      Timer(Duration(seconds: 10), () {
        if (this.mounted) {
          setState(() {
            isSignButtonTimeout = false;
          });
        }
      });
      BlocProvider.of<AuthBloc>(context)
          .add(SignInByPhone(phone: countryCode + phoneNumber));
    }
  }

  onSignUpTap() {
    BlocProvider.of<AuthBloc>(context).add(GoToRegistration());
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
                                'Sign In',
                                style: TextStyle(
                                    color: Color(0xffE24F4F),
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: 128,
                              ),
                              Form(key: _formKey, child: buildPhoneInput()),
                              SizedBox(
                                height: 32,
                              ),
                              Wrap(
                                children: [
                                  Text(
                                    'Don\'t have account yet? ',
                                    softWrap: true,
                                  ),
                                  GestureDetector(
                                    onTap: () => onSignUpTap(),
                                    child: Text(
                                      'Sign Up',
                                      softWrap: true,
                                      style:
                                          TextStyle(color: Color(0xffE24F4F)),
                                    ),
                                  )
                                ],
                              )
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
                          text: 'Sign in',
                          enable: submitActive,
                          textColor: Colors.white,
                          enableColor: Color(0xffE24F4F),
                          disableColor: Color(0xffE24F4F).withOpacity(0.25),
                          callback: () => onSignin(),
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

  Widget buildPhoneInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              validator: (value) {
                return phoneNumberValidator(value!.replaceAll(RegExp('-'), ''));
              },
              focusNode: focusNode,
              controller: controller,
              keyboardType: TextInputType.phone,
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration(
                  prefixIcon: Container(
                    margin: const EdgeInsets.only(left: 8, bottom: 2),
                    width: 50,
                    alignment: Alignment.center,
                    child: CountryCodePickerWidegt(
                      onChange: (code) {
                        countryCode = code;
                        print(code);
                      },
                      focusNode: focusNode,
                    ),
                  ),
                  hintText: 'Phone',
                  isDense: true,
                  contentPadding: EdgeInsets.all(12),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Color(0xffFA6400))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Color(0xffC9C9C9))),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Color(0xffC9C9C9))),
                  fillColor: Colors.white,
                  filled: true),
              onChanged: (value) {
                setState(() {
                  phoneNumber = value.replaceAll(RegExp('-'), '');
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
