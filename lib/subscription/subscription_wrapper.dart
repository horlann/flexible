import 'package:another_flushbar/flushbar.dart';
import 'package:flexible/authentification/auth_pusher.dart';
import 'package:flexible/authentification/bloc/auth_bloc.dart';
import 'package:flexible/board/board_page.dart';
import 'package:flexible/subscription/bloc/subscribe_bloc.dart';
import 'package:flexible/subscription/subscribe_page.dart';
import 'package:flexible/widgets/message_snakbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

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
          // ScaffoldMessenger.of(context).showSnackBar(
          //      messageSnakbar(text: 'You should auhorize before subscribe'));
          showSnackBar(context, 'You should auhorize before subscribe', false);

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
        // Message popup listener
        if (state is AskForSubscribe && state.message.isNotEmpty) {
          //ScaffoldMessenger.of(context)
          //    .showSnackBar(messageSnakbar(text: state.message));
          showSnackBar(context, state.message, false);
        }
      },
      builder: (context, state) {
        print(state);
        if (state is UnSubscribed) {
          BlocProvider.of<AuthBloc>(context).add(SignOut());
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
          //return Container();
        }

        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('src/helper/backgroundimage.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }

  void showSnackBar(
      BuildContext buildContext, String text, bool isProgressive) {
    ScaffoldMessenger.of(buildContext).hideCurrentSnackBar();
    Flushbar(
      message: text,
      barBlur: 20,
      mainButton: isProgressive
          ? Padding(
              padding: const EdgeInsets.only(right: 15.0, top: 10, bottom: 10),
              child: CircularProgressIndicator(
                strokeWidth: 5,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : SizedBox(),
      duration: Duration(seconds: 2),
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: BorderRadius.all(Radius.circular(16)),
      backgroundColor: Color(0xffE24F4F),
      margin: const EdgeInsets.symmetric(horizontal: 11),
      messageText: Center(
          child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      )),
    )..show(buildContext);
  }
}
