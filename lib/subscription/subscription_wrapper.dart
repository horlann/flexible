import 'package:flexible/authentification/auth_pusher.dart';
import 'package:flexible/board/board_page.dart';
import 'package:flexible/subscription/bloc/subscribe_bloc.dart';
import 'package:flexible/subscription/subscribe_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
