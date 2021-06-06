import 'package:flexible/authentification/bloc/auth_bloc.dart';
import 'package:flexible/authentification/code_verification_page.dart';
import 'package:flexible/authentification/firebase_auth.dart';
import 'package:flexible/authentification/registration_page.dart';
import 'package:flexible/helper/bloc/helper_bloc.dart';
import 'package:flexible/helper/first_time_servise.dart';
import 'package:flexible/helper/helper_page.dart';
import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flexible/board/repository/image_repo_mock.dart';
import 'package:flexible/board/repository/sqflire_tasks_repo.dart';
import 'package:flexible/board/repository/sqflite_day_options_repo.dart';
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
      child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  AuthBloc(fireAuthService: FireAuthService())..add(AppStart()),
            ),
            BlocProvider(
              create: (context) => DailytasksBloc(
                  dayOptionsRepo:
                      RepositoryProvider.of<SqfliteDayOptionsRepo>(context),
                  tasksRepo: RepositoryProvider.of<SqfliteTasksRepo>(context)),
            ),
          ],
          child: MaterialApp(
            home: HelperWrapper(),
          )),
    );
  }
}

class HelperWrapper extends StatelessWidget {
  final HelperBloc bloc = HelperBloc()..add(HelperAppStart());

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HelperBloc, HelperState>(
      bloc: bloc,
      builder: (context, state) {
        // Show helper page if app is run first
        if (state is ShowHelper) {
          return HelperPage(
            callback: () {
              bloc.add(HelperSeened());
            },
          );
        }

        if (state is HelperShowed) {
          return AuthBlocWrapper();
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

class AuthBlocWrapper extends StatelessWidget {
  const AuthBlocWrapper({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is NotAuthentificated) {
          return RegistrationPage();
        }

        if (state is CodeSended) {
          return CodeVerificationPage();
        }

        if (state is Authentificated) {
          BlocProvider.of<AuthBloc>(context).fireAuthService.signOut();
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
