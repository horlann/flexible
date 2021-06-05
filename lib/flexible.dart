import 'package:flexible/authentification/bloc/auth_bloc.dart';
import 'package:flexible/authentification/code_verification_page.dart';
import 'package:flexible/authentification/firebase_auth.dart';
import 'package:flexible/authentification/registration_page.dart';
import 'package:flexible/board/bloc/dailytasks_bloc.dart';
import 'package:flexible/board/board_page.dart';
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
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is NotAuthentificated) {
              return MaterialApp(
                home: RegistrationPage(),
              );
            }

            if (state is CodeSended) {
              return MaterialApp(
                home: CodeVerificationPage(),
              );
            }

            if (state is Authentificated) {
              BlocProvider.of<AuthBloc>(context).fireAuthService.signOut();
            }
            print(state);
            return MaterialApp(
              home: BoardPage(),
            );
          },
        ),
      ),
    );
  }
}
