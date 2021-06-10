import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flexible/flexible.dart';
import 'package:flexible/helper/bloc/helper_bloc.dart';
import 'package:flexible/helper/helper_page.dart';

// This wrapper check if app starts first time
// If yes show user helper page, for show functionality of an app
// After helper is seen mark it in local storage and dont show anymore
class HelperWrapper extends StatelessWidget {
  final Widget child;
  HelperWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);
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
          return child;
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
