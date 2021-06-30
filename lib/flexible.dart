import 'package:flexible/authentification/auth_pusher.dart';
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
import 'package:flexible/subscription/bloc/subscribe_bloc.dart';
import 'package:flexible/subscription/subscribe_page.dart';
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
          BlocProvider(
            create: (context) => SubscribeBloc(
                fireAuthService:
                    RepositoryProvider.of<FireAuthService>(context)),
          ),
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
              child: SubAndAuthChooser(),
            ),
          ),
        ),
      ),
    );
  }
}

class SubAndAuthChooser extends StatelessWidget {
  const SubAndAuthChooser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubscribeBloc, SubscribeState>(
      listener: (context, state) {
        if (state is RegisterAndProcess) {
          // Push pre registration
          // continue process if user authed by state bools
          // or abort if user out from auth
          Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => AuthBlocPusher(),
              )).then((value) {
            print(value);
            // AuthBlocPusher return true if outh complete
            if (value != null && value == true) {
              // Continue what you need
              if (state.continueSubscribe) {
                BlocProvider.of<SubscribeBloc>(context).add(Restore());
              }
              if (state.continueRestore) {
                BlocProvider.of<SubscribeBloc>(context).add(Subscribe());
              }
            } else {
              // Just return and update
              BlocProvider.of<SubscribeBloc>(context).add(Update());
            }
          });
        }
      },
      builder: (context, state) {
        print(state);
        if (state is UnSubscribed) {
          // BlocProvider.of<AuthBloc>(context).add(SignOut());
          return BoardPage();
        }

        if (state is Subscribed) {
          return BoardPage();
        }

        if (state is SubscribtionDeactivated) {
          return BoardPage();
        }

        if (state is AskForSubscribe) {
          return SubscribePage();
        }

        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class PaymentPage extends StatelessWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        gradient: mainBackgroundGradient,
      ),
      child: SafeArea(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: true,
              child: buildBody(context),
            ),
          ],
        ),
      ),
    ));
  }

  Widget buildBody(BuildContext context) {
    return Center(
      child: Text('payment'),
    );
  }
}
