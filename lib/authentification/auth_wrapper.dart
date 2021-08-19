import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flexible/authentification/bloc/auth_bloc.dart';
import 'package:flexible/authentification/code_verification_page.dart';
import 'package:flexible/authentification/registration_page.dart';
import 'package:flexible/authentification/sign_in_page.dart';
import 'package:flexible/utils/main_backgroung_gradient.dart';

// Wrap widget three with auth
// When user authed return child else return auth
class AuthBlocWrapper extends StatelessWidget {
  final Widget child;
  const AuthBlocWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is CodeSended) {
          Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) =>
                        CodeVerificationPage(afterError: false),
                  ))
              .then((value) => BlocProvider.of<AuthBloc>(context)
                  .add(CloseCodeVerification()));
        }
      },
      listenWhen: (previous, current) {
        if (previous is CodeSended && current is CodeSended) {
          return false;
        }
        return true;
      },
      builder: (context, state) {
        print(state);
        if (state is ShowSignIn) {
          return SignInPage();
        }

        if (state is ShowRegistration) {
          return RegistrationPage();
        }

        if (state is Authentificated) {
          return child;
        }

        return SizedBox.expand(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('src/helper/backgroundimage.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
