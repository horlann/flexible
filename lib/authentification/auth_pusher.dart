import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flexible/authentification/bloc/auth_bloc.dart';
import 'package:flexible/authentification/code_verification_page.dart';
import 'package:flexible/authentification/registration_page.dart';
import 'package:flexible/authentification/sign_in_page.dart';
import 'package:flexible/utils/main_backgroung_gradient.dart';

// Push auth over current widget three
// On user authed pop back
class AuthBlocPusher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // Push code verification page
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
        // Push true if auth complete
        if (state is Authentificated) {
          Navigator.pop(context, true);
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
