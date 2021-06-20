import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flexible/authentification/bloc/auth_bloc.dart';
import 'package:flexible/authentification/code_verification_page.dart';
import 'package:flexible/authentification/registration_page.dart';
import 'package:flexible/authentification/sign_in_page.dart';
import 'package:flexible/board/board_page.dart';
import 'package:flexible/utils/main_backgroung_gradient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBlocWrapper extends StatelessWidget {
  const AuthBlocWrapper({
    Key? key,
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
          // RepositoryProvider.of<FireAuthService>(context).signOut();
          RemoteConfig remoteConfig = RemoteConfig.instance..fetchAndActivate();
          print(remoteConfig.getString('asdasd'));

          return BoardPage();
        }

        return SizedBox.expand(
          child: Container(
            decoration: BoxDecoration(
              gradient: mainBackgroundGradient,
            ),
          ),
        );
      },
    );
  }
}
