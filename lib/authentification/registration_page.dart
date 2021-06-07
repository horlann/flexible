import 'dart:async';
import 'dart:typed_data';

import 'package:flexible/authentification/terms_of_use.dart';
import 'package:flexible/widgets/wide_rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flexible/authentification/bloc/auth_bloc.dart';
import 'package:flexible/authentification/country_code_picker.dart';
import 'package:flexible/board/widgets/glassmorph_layer.dart';
import 'package:flexible/utils/main_backgroung_gradient.dart';
import 'package:flexible/utils/validators.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  MaskedTextController controller = MaskedTextController(mask: '00-000-00-00');
  FocusNode focusNode = FocusNode();
  Uint8List? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = await pickedFile.readAsBytes();
      setState(() {});
    } else {
      print('No image selected.');
    }
  }

  final _formKey = GlobalKey<FormState>();
  bool isUserAgree = false;
  String fullName = '';
  String phoneNumber = '';
  String countryCode = '';
  String email = '';
  bool isSignButtonTimeout = false;

  bool get submitActive =>
      phoneNumber.isNotEmpty &&
      isUserAgree &&
      fullName.isNotEmpty &&
      email.isNotEmpty &&
      !isSignButtonTimeout;

  onRegistration() {
    // Validate all
    if (_formKey.currentState!.validate()) {
      // Prevent multiple click to submit button before captcha is show
      setState(() {
        isSignButtonTimeout = true;
      });
      Timer(Duration(seconds: 30), () {
        if (this.mounted) {
          setState(() {
            isSignButtonTimeout = false;
          });
        }
      });

      print(countryCode + phoneNumber);
      // Submit registration
      BlocProvider.of<AuthBloc>(context).add(CreateAccount(
          name: fullName, email: email, phone: countryCode + phoneNumber));
    }
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
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Material(
                                color: Colors.grey[300],
                                child: InkWell(
                                  onTap: () => getImage(),
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    child: _image != null
                                        ? Image.memory(
                                            _image!,
                                            fit: BoxFit.cover,
                                          )
                                        : Center(
                                            child: Icon(
                                              Icons.person,
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 32,
                            ),
                            Form(
                                key: _formKey,
                                child: Column(
                                  children: [
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
                                  ],
                                )),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 60),
                        child: WideRoundedButton(
                          text: 'Continue',
                          enable: submitActive,
                          textColor: Colors.white,
                          enableColor: Color(0xffE24F4F),
                          disableColor: Color(0xffE24F4F).withOpacity(0.25),
                          callback: () => onRegistration(),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 60),
                        child: WideRoundedButton(
                          text: 'Sign in',
                          enable: true,
                          textColor: Color(0xffE24F4F),
                          enableColor: Colors.transparent,
                          disableColor: Color(0xffE24F4F).withOpacity(0.25),
                          callback: () => onSignInTap(),
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
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => TermsPage(),
                    ));
              },
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
          ),
        ],
      ),
    );
  }

  Widget buildFullNameInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: TextFormField(
        keyboardType: TextInputType.name,
        validator: (value) {
          print(value);
          return nameValidator(value!);
        },
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

  Widget buildEmailInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          return emailValidator(value!);
        },
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
