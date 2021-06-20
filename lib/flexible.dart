import 'package:flexible/authentification/auth_wrapper.dart';
import 'package:flexible/authentification/bloc/auth_bloc.dart';
import 'package:flexible/authentification/code_verification_page.dart';
import 'package:flexible/authentification/services/firebase_auth.dart';
import 'package:flexible/authentification/registration_page.dart';
import 'package:flexible/authentification/services/users_data_repository.dart';
import 'package:flexible/authentification/sign_in_page.dart';
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
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => AuthBloc(
                  fireAuthService:
                      RepositoryProvider.of<FireAuthService>(context),
                  usersDataRepo: RepositoryProvider.of<UsersDataRepo>(context))
                ..add(AppStart())),
          BlocProvider(
              create: (context) => DailytasksBloc(
                  dayOptionsRepo:
                      RepositoryProvider.of<SqfliteDayOptionsRepo>(context),
                  tasksRepo:
                      RepositoryProvider.of<CombinedTasksRepository>(context))),
          BlocProvider(create: (context) => WeatherBloc()..add(WeatherUpdate()))
        ],
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
    );
  }
}
