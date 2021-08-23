import 'package:another_flushbar/flushbar.dart';
import 'package:flexible/authentification/bloc/auth_bloc.dart';
import 'package:flexible/authentification/country_code_picker.dart';
import 'package:flexible/board/board_page.dart';
import 'package:flexible/board/widgets/close_button.dart';
import 'package:flexible/board/widgets/flexible_text.dart';
import 'package:flexible/board/widgets/glassmorph_layer.dart';
import 'package:flexible/utils/adaptive_utils.dart';
import 'package:flexible/utils/validators.dart';
import 'package:flexible/widgets/flush.dart';
import 'package:flexible/widgets/wide_rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  MaskedTextController controller =
      MaskedTextController(mask: '000-00-00-00-00-00');
  FocusNode focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  String phoneNumber = '';
  String countryCode = '';
  Flushbar? _flushbar;


  bool get submitActive => phoneNumber.isNotEmpty;

  onSignin() {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context)
          .add(SignInByPhone(phone: countryCode + phoneNumber));
    }
  }

  onSignUpTap() {
    BlocProvider.of<AuthBloc>(context).add(GoToRegistration());
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
          if (_flushbar != null) {
            _flushbar!.dismiss();
          }

          setState(() => _flushbar = _flushbar =
          showFlush(context, "Sign in", true)..show(context));
        }

        if (state.error.isNotEmpty) {
          if (_flushbar != null) {
            _flushbar!.dismiss();
          }

          setState(() => _flushbar = showFlush(context, state.error, false)
            ..show(context));
        }
      },
      child: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return Column(
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
                CloseButtonn(
                  callback: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) => BoardPage()));
                  },
                ),
                Column(
                  children: [
                    SizedBox(
                      width: double.maxFinite,
                    ),
                    SizedBox(
                      height: 16 * byWithScale(context),
                    ),
                    FlexibleText(),
                    Text(
                      'Login',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20 * byWithScale(context),
                          fontWeight: FontWeight.w700),
                    ),
                    // SizedBox(
                    //   height: 128 * byWithScale(context),
                    // ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Form(key: _formKey, child: buildPhoneInput()),
                          SizedBox(
                            height: 60 * byWithScale(context),
                          ),
                          Wrap(
                            children: [Container()],
                          )
                        ],
                      ),
                    ),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60),
                          child: WideRoundedButton(
                            text: 'CONTINUE',
                            // bloc submit button if processing or on all data passed
                            enable: !state.isBusy ? submitActive : false,
                            textColor: Colors.white,
                            enableColor: Color(0xffE24F4F),
                            disableColor: Color(0xffE24F4F).withOpacity(0.25),
                            callback: () => onSignin(),
                          ),
                        );
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
        Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 50 * byWithScale(context), vertical: 20),
            child: Wrap(
              children: [
                Text(
                  'Don`t have an account yet? ',
                  style: TextStyle(
                      color: Colors.white, fontSize: 11 * byWithScale(context)),
                ),
                GestureDetector(
                  child: Text(
                    'Registration',
                    style: TextStyle(
                        color: Color(0xffE24F4F),
                        decoration: TextDecoration.underline,
                        fontSize: 11 * byWithScale(context)),
                  ),
                  onTap: () => onSignUpTap(),
                ),
              ],
            ))
      ],
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
}