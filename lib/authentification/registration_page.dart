import 'dart:async';
import 'dart:typed_data';

import 'package:another_flushbar/flushbar.dart';
import 'package:flexible/authentification/bloc/auth_bloc.dart';
import 'package:flexible/authentification/country_code_picker.dart';
import 'package:flexible/authentification/terms_of_use.dart';
import 'package:flexible/board/widgets/glassmorph_layer.dart';
import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flexible/utils/validators.dart';
import 'package:flexible/widgets/wide_rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:image_picker/image_picker.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  MaskedTextController controller =
      MaskedTextController(mask: '000-00-00-00-00-00');
  FocusNode focusNode = FocusNode();
  Uint8List? _image;
  final picker = ImagePicker();

  Future getImage() async {
    try {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _image = await pickedFile.readAsBytes();
        setState(() {});
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error on load image');
    }
  }

  void showSnackBar(
      BuildContext buildContext, String text, bool isProgressive) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    Flushbar(
      message: text,
      barBlur: 20,
      mainButton: isProgressive
          ? Padding(
              padding: const EdgeInsets.only(right: 15.0, top: 10, bottom: 10),
              child: CircularProgressIndicator(
                strokeWidth: 5,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : SizedBox(),
      duration: Duration(seconds: 2),
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: BorderRadius.all(Radius.circular(16)),
      backgroundColor: Color(0xffE24F4F),
      margin: const EdgeInsets.symmetric(horizontal: 11),
      messageText: Center(
          child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      )),
    )..show(context);
  }

  final _formKey = GlobalKey<FormState>();
  bool isUserAgree = false;
  String fullName = '';
  String phoneNumber = '';
  String countryCode = '';
  String email = '';

  bool get submitActive =>
      phoneNumber.isNotEmpty &&
      isUserAgree &&
      fullName.isNotEmpty &&
      email.isNotEmpty;

  onRegistration() {
    // Validate all
    if (_formKey.currentState!.validate()) {
      print(countryCode + phoneNumber);
      // Submit registration
      BlocProvider.of<AuthBloc>(context).add(CreateAccount(
          name: fullName,
          email: email,
          phone: countryCode + phoneNumber,
          photo: _image));
    }
  }

  onSignInTap() {
    BlocProvider.of<AuthBloc>(context).add(GoToSignIn());
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
        print(state);
        if (state.isBusy) {
          //    ScaffoldMessenger.of(context).showSnackBar(circularSnakbar(
          //      text: 'Processing',
          //   ));
          showSnackBar(context, "Processing", true);
        }

        if (state.error.isNotEmpty) {
          //   ScaffoldMessenger.of(context).hideCurrentSnackBar();
          //   ScaffoldMessenger.of(context).showSnackBar(errorSnakbar(
          //     text: state.error,
          //   ));
          showSnackBar(context, state.error, false);
        }

        if (state.message.isNotEmpty) {
          //ScaffoldMessenger.of(context).hideCurrentSnackBar();
          //ScaffoldMessenger.of(context).showSnackBar(messageSnakbar(
          //  text: state.message,
          // ));
          showSnackBar(context, state.message, false);
        }
      },
      child: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 16 * byWithScale(context)),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(16 * byWithScale(context)),
            child: Stack(
              children: [
                Positioned.fill(child: GlassmorphLayer()),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Spacer(
                        flex: 1,
                      ),
                      Center(
                          child: Text(
                        "Flexible",
                        style: TextStyle(
                            fontSize: 35 * byWithScale(context),
                            fontWeight: FontWeight.w900,
                            color: Color(0xffE24F4F)),
                      )),
                      Center(
                          child: Text(
                        "Registration",
                        style: TextStyle(
                            fontSize: 16 * byWithScale(context),
                            fontWeight: FontWeight.w900,
                            color: Colors.white),
                      )),
                      Spacer(
                        flex: 1,
                      ),
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(30 * byWithScale(context)),
                        child: Material(
                          color: Colors.white,
                          child: InkWell(
                            onTap: () => getImage(),
                            child: Container(
                              height: 50 * byWithScale(context),
                              width: 50 * byWithScale(context),
                              child: _image != null
                                  ? Image.memory(
                                      _image!,
                                      fit: BoxFit.cover,
                                    )
                                  : Center(
                                      child: Padding(
                                      padding: const EdgeInsets.all(11.0),
                                      child: Image.asset(
                                          'src/icons/logo_for_picker_image.png',
                                          fit: BoxFit.scaleDown),
                                    )),
                            ),
                          ),
                        ),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      buildFullNameInput(),
                      Spacer(
                        flex: 1,
                      ),
                      buildPhoneInput(),
                      Spacer(
                        flex: 1,
                      ),
                      buildEmailInput(),
                      Spacer(
                        flex: 1,
                      ),
                      buildAgreement(),
                      Spacer(
                        flex: 1,
                      ),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 60 * byWithScale(context)),
                            child: WideRoundedButton(
                              text: 'CONTINUE',
                              // bloc submit button if processing or on all data passed
                              enable: !state.isBusy ? submitActive : false,
                              textColor: Colors.white,
                              enableColor: Color(0xffE24F4F),
                              disableColor: Color(0xffE24F4F).withOpacity(0.25),
                              callback: () => onRegistration(),
                            ),
                          );
                        },
                      ),
                      Spacer(
                        flex: 1,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 60 * byWithScale(context), vertical: 20),
            child: Wrap(
              children: [
                Text(
                  'Already Registered?',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 11 * byWithScale(context),
                      fontWeight: FontWeight.w600),
                ),
                GestureDetector(
                  child: Text(
                    'Login',
                    style: TextStyle(
                        color: Color(0xffE24F4F),
                        decoration: TextDecoration.underline,
                        fontSize: 11 * byWithScale(context)),
                  ),
                  onTap: () {
                    onSignInTap();
                  },
                ),
              ],
            ))
      ],
    );
  }

  Widget buildAgreement() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28 * byWithScale(context)),
      child: Container(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                width: 30,
                height: 30,
                child: GestureDetector(
                  onTap: () {
                    isUserAgree = !isUserAgree;
                    setState(() {});
                  },
                  child: Transform.scale(
                    scale: 0.75 * byWithScale(context),
                    child: isUserAgree
                        ? Container(
                            child: Image.asset("src/icons/ch_checked.png"),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Container(
                              child: Image.asset("src/icons/ch_unchecked.png"),
                            ),
                          ),
                  ),
                ),
              ),
            ),
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
                    Text('By creating an account you agree to our ',
                        softWrap: true,
                        style: TextStyle(
                            fontSize: 9 * byWithScale(context),
                            color: Colors.white)),
                    Text(
                      'Terms of Service ',
                      softWrap: true,
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Color(0xffE24F4F),
                          fontSize: 9 * byWithScale(context)),
                    ),
                    Text('and ',
                        softWrap: true,
                        style: TextStyle(
                            fontSize: 9 * byWithScale(context),
                            color: Colors.white)),
                    Text(
                      'and Privacy Policy',
                      softWrap: true,
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Color(0xffE24F4F),
                          fontSize: 9 * byWithScale(context)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFullNameInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: TextFormField(
        style: TextStyle(fontSize: 10 * byWithScale(context)),
        keyboardType: TextInputType.name,
        validator: (value) {
          print(value);
          return nameValidator(value!);
        },
        decoration: InputDecoration(
            hintText: 'Full name',
            hintStyle: TextStyle(color: Color(0xffE24F4F)),
            isDense: true,
            contentPadding: EdgeInsets.all(8 * byWithScale(context)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(35),
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
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              child: TextFormField(
                validator: (value) {
                  return phoneNumberValidator(
                      value!.replaceAll(RegExp('-'), ''));
                },
                focusNode: focusNode,
                controller: controller,
                keyboardType: TextInputType.phone,
                style: TextStyle(
                    fontSize: 10 * byWithScale(context),
                    color: Color(0xffE24F4F)),
                decoration: InputDecoration(
                    prefixIcon: Container(
                      margin: const EdgeInsets.only(left: 8, bottom: 2),
                      width: 70 * byWithScale(context),
                      alignment: Alignment.center,
                      child: CountryCodePickerWidegt(
                        onChange: (code) {
                          countryCode = code;
                          print(code);
                        },
                        focusNode: focusNode,
                      ),
                    ),
                    prefixIconConstraints: BoxConstraints(minHeight: 0),
                    hintText: 'Phone',
                    isCollapsed: true,
                    isDense: true,
                    hintStyle: TextStyle(color: Color(0xffE24F4F)),
                    contentPadding: EdgeInsets.only(
                        left: 8 * byWithScale(context),
                        top: 8 * byWithScale(context),
                        bottom: 8 * byWithScale(context),
                        right: 8 * byWithScale(context)),
                    border: InputBorder.none,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    fillColor: Colors.white,
                    filled: true),
                onChanged: (value) {
                  setState(() {
                    phoneNumber = value.replaceAll(RegExp('-'), '');
                  });
                },
              ),
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
        style: TextStyle(fontSize: 10 * byWithScale(context)),
        decoration: InputDecoration(
            hintText: 'Email',
            isDense: true,
            hintStyle: TextStyle(color: Color(0xffE24F4F)),
            contentPadding: EdgeInsets.all(8 * byWithScale(context)),
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
