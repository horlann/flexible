import 'package:flexible/authentification/bloc/auth_bloc.dart';
import 'package:flexible/authentification/code_verification_page.dart';
import 'package:flexible/authentification/services/firebase_auth.dart';
import 'package:flexible/authentification/registration_page.dart';
import 'package:flexible/authentification/services/users_data_repository.dart';
import 'package:flexible/authentification/sign_in_page.dart';
import 'package:flexible/authentification/user_data_update_page.dart';
import 'package:flexible/board/board_page.dart';
import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flexible/board/repository/firebaseRepository/fire_days_options.dart';
import 'package:flexible/board/repository/firebaseRepository/fire_tasks.dart';
import 'package:flexible/board/repository/image_repo_mock.dart';
import 'package:flexible/board/repository/sqFliteRepository/sqflire_tasks.dart';
import 'package:flexible/board/repository/sqFliteRepository/sqflite_day_options.dart';
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
        ),
        RepositoryProvider(
          create: (context) => FireAuthService(),
        ),
        RepositoryProvider(
          create: (context) => UsersDataRepo(),
        ),
        RepositoryProvider(
          create: (context) => FireBaseTasksRepo(),
        ),
        RepositoryProvider(
          create: (context) => FireBaseDaysOptionsRepo(),
        ),
      ],
      child: BlocProvider(
        create: (context) => AuthBloc(
            fireAuthService: RepositoryProvider.of<FireAuthService>(context),
            usersDataRepo: RepositoryProvider.of<UsersDataRepo>(context))
          ..add(AppStart()),
        child: BlocProvider(
          create: (context) => DailytasksBloc(
              dayOptionsRepo:
                  RepositoryProvider.of<FireBaseDaysOptionsRepo>(context),
              tasksRepo: RepositoryProvider.of<FireBaseTasksRepo>(context)),
          child: MaterialApp(
            theme: ThemeData(fontFamily: 'Mikado'),
            home: HelperWrapper(
              child: AuthBlocWrapper(),
            ),
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
          return CodeVerificationPage(
            afterError: false,
          );
        }

        if (state is VerificationCodeInvalid) {
          return CodeVerificationPage(
            afterError: true,
          );
        }

        if (state is Authentificated) {
          // RepositoryProvider.of<UsersDataRepo>(context)
          //     .existsByPhone('+380508210440')
          //     .then((value) => print(value));
          // RepositoryProvider.of<FireAuthService>(context).signOut();

          return BoardPage();
        }

        return Scaffold(
          body: SizedBox.expand(
            child: Image.asset(
              'src/splash.jpg',
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }
}
