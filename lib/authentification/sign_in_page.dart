import 'package:flexible/authentification/bloc/auth_bloc.dart';
import 'package:flexible/board/widgets/glassmorph_layer.dart';
import 'package:flexible/utils/main_backgroung_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String phoneNumber = '';

  bool get submitActive => phoneNumber.isNotEmpty;

  onSignin() {
    BlocProvider.of<AuthBloc>(context).add(SignInByPhone(phone: phoneNumber));
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
                              buildPhoneInput(),
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
                      GestureDetector(
                        onTap: () => submitActive ? onSignin() : {},
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
                              'Sign up',
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
}
