import 'package:flexible/subscription/bloc/subscribe_bloc.dart';
import 'package:flexible/subscription/subscribe_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubscriptionWrapper extends StatelessWidget {
  final Widget child;
  const SubscriptionWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscribeBloc, SubscribeState>(
      builder: (context, state) {
        print(state);
        if (state is UnSubscribed) {
          return child;
        }

        if (state is Subscribed) {
          return child;
        }

        if (state is SubscribtionDeactivated) {
          return child;
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
