import 'package:flexible/authentification/bloc/auth_bloc.dart';
import 'package:flexible/authentification/code_verification_page.dart';
import 'package:flexible/authentification/services/firebase_auth.dart';
import 'package:flexible/authentification/registration_page.dart';
import 'package:flexible/authentification/services/users_data_repository.dart';
import 'package:flexible/authentification/sign_in_page.dart';
import 'package:flexible/authentification/user_data_update_page.dart';
import 'package:flexible/board/board_page.dart';
import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flexible/board/repository/combined_repository/combined_tasks_repo.dart';
import 'package:flexible/board/repository/firebaseRepository/fire_days_options.dart';
import 'package:flexible/board/repository/firebaseRepository/fire_tasks.dart';
import 'package:flexible/board/repository/image_repo_mock.dart';
import 'package:flexible/board/repository/sqFliteRepository/sqflire_tasks.dart';
import 'package:flexible/board/repository/sqFliteRepository/sqflite_day_options.dart';
import 'package:flexible/helper/helper_wrapper.dart';
import 'package:flexible/utils/main_backgroung_gradient.dart';
import 'package:flexible/weather/bloc/weather_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

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
        RepositoryProvider(
          create: (context) => CombinedTasksRepository(),
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
                  RepositoryProvider.of<SqfliteDayOptionsRepo>(context),
              tasksRepo:
                  RepositoryProvider.of<CombinedTasksRepository>(context)),
          child: BlocProvider(
            create: (context) => WeatherBloc()..add(WeatherUpdate()),
            child: MaterialApp(
              theme: ThemeData(fontFamily: 'Mikado'),
              home: WillPopScope(
                onWillPop: () async {
                  MoveToBackground.moveTaskToBack();
                  return false;
                },
                child: HelperWrapper(
                  child: AuthBlocWrapper(),
                ),
              ),
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

        // if (state is CodeSended) {
        //   return CodeVerificationPage(
        //     afterError: false,
        //   );
        // }

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
