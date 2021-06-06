import 'package:flexible/authentification/bloc/auth_bloc.dart';
import 'package:flexible/authentification/code_verification_page.dart';
import 'package:flexible/authentification/firebase_auth.dart';
import 'package:flexible/authentification/registration_page.dart';
import 'package:flexible/authentification/sign_in_page.dart';
import 'package:flexible/authentification/user_data_update_page.dart';
import 'package:flexible/board/board_page.dart';
import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flexible/board/repository/image_repo_mock.dart';
import 'package:flexible/board/repository/sqFliteTasksRepository/sqflire_tasks_repo.dart';
import 'package:flexible/board/repository/sqFliteTasksRepository/sqflite_day_options_repo.dart';
import 'package:flexible/helper/helper_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlexibleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => SqfliteTasksRepo(),
        ),
        RepositoryProvider(
          create: (context) => SqfliteDayOptionsRepo(),
        ),
        RepositoryProvider(
          create: (context) => ImageRepoMock(),
        )
      ],
      child: BlocProvider(
        create: (context) =>
            AuthBloc(fireAuthService: FireAuthService())..add(AppStart()),
        child: MaterialApp(
          home: HelperWrapper(
            child: AuthBlocWrapper(),
          ),
        ),
      ),
    );
  }
}

class AuthBlocWrapper extends StatelessWidget {
  const AuthBlocWrapper({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        print(state);
        if (state is ShowSignIn) {
          return SignInPage();
        }

        if (state is ShowRegistration) {
          return RegistrationPage();
        }

        if (state is ShowDataUpdate) {
          return UserDataUpdatePage();
        }

        if (state is CodeSended) {
          return CodeVerificationPage();
        }

        if (state is VerificationCodeInvalid) {
          return CodeVerificationPage();
          // TODO show error
        }

        if (state is Authentificated) {
          // BlocProvider.of<AuthBloc>(context).add(SignOut());
          return BlocProvider(
            create: (context) => DailytasksBloc(
                dayOptionsRepo:
                    RepositoryProvider.of<SqfliteDayOptionsRepo>(context),
                tasksRepo: RepositoryProvider.of<SqfliteTasksRepo>(context)),
            child: BoardPage(),
          );
          // print(BlocProvider.of<AuthBloc>(context).fireAuthService.getUser());
        }

        return Scaffold(
          body: Center(
            child: Text(
              'LOGO',
              style: TextStyle(
                  color: Color(0xffE24F4F),
                  fontSize: 32,
                  fontWeight: FontWeight.w700),
            ),
          ),
        );
      },
    );
  }
}
