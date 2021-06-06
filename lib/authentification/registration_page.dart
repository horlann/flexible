import 'dart:async';

import 'package:flexible/authentification/bloc/auth_bloc.dart';
import 'package:flexible/board/widgets/glassmorph_layer.dart';
import 'package:flexible/utils/main_backgroung_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool isUserAgree = false;
  String fullName = '';
  String phoneNumber = '';
  String email = '';
  bool isSignButtonTimeout = false;

  bool get submitActive =>
      phoneNumber.isNotEmpty &&
      isUserAgree &&
      fullName.isNotEmpty &&
      email.isNotEmpty &&
      !isSignButtonTimeout;

  onRegistration() {
    // Prevent multiple click to submit button before captcha is show
    setState(() {
      isSignButtonTimeout = true;
    });
    Timer(Duration(seconds: 10), () {
      setState(() {
        isSignButtonTimeout = false;
      });
    });
    // Submit registration
    BlocProvider.of<AuthBloc>(context)
        .add(CreateAccount(name: fullName, email: email, phone: phoneNumber));
  }

  onSignInTap() {
    BlocProvider.of<AuthBloc>(context).add(GoToSignIn());
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
                        Column(
                          children: [
                            SizedBox(
                              width: double.maxFinite,
                            ),
                            SizedBox(
                              height: 32,
                            ),
                            Text(
                              'Create an Acount',
                              style: TextStyle(
                                  color: Color(0xffE24F4F),
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              height: 32,
                            ),
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(40)),
                              child: Center(
                                child: Icon(
                                  Icons.person,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 32,
                            ),
                            buildFullNameInput(),
                            SizedBox(
                              height: 32,
                            ),
                            buildPhoneInput(),
                            SizedBox(
                              height: 32,
                            ),
                            buildEmailInput(),
                            SizedBox(
                              height: 32,
                            ),
                            buildAgreement(),
                            SizedBox(
                              height: 32,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () => submitActive ? onRegistration() : {},
                        child: Container(
                          height: 40,
                          width: double.maxFinite,
                          margin: EdgeInsets.symmetric(horizontal: 40),
                          decoration: BoxDecoration(
                              color: submitActive
                                  ? Color(0xffE24F4F)
                                  : Color(0xffE24F4F).withOpacity(0.25),
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
                      ),
                      GestureDetector(
                        onTap: () => onSignInTap(),
                        child: Container(
                          height: 40,
                          width: double.maxFinite,
                          margin: EdgeInsets.symmetric(horizontal: 40),
                          child: Center(
                            child: Text(
                              'Sign in',
                              style: TextStyle(
                                  color: Color(0xffE24F4F),
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

  Widget buildAgreement() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          Checkbox(
              checkColor: Color(0xffE24F4F),
              activeColor: Colors.transparent,
              value: isUserAgree,
              onChanged: (v) {
                setState(() {
                  isUserAgree = v!;
                });
              }),
          Expanded(
            child: Wrap(
              children: [
                Text(
                  'By creating an account you agree to our ',
                  softWrap: true,
                ),
                Text(
                  'Terms of Service ',
                  softWrap: true,
                  style: TextStyle(color: Color(0xffE24F4F)),
                ),
                Text(
                  'and Privacy Policy',
                  softWrap: true,
                  style: TextStyle(color: Color(0xffE24F4F)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFullNameInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: TextField(
        decoration: InputDecoration(
            hintText: 'Full name',
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
            fullName = value;
          });
        },
      ),
    );
  }

  Widget buildPhoneInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: TextField(
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
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
            phoneNumber = value;
          });
        },
      ),
    );
  }

  Widget buildEmailInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: TextField(
        decoration: InputDecoration(
            hintText: 'Email',
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
            email = value;
          });
        },
      ),
    );
  }
}
