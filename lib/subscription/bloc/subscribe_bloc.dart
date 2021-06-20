import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

part 'subscribe_event.dart';
part 'subscribe_state.dart';

class SubscribeBloc extends Bloc<SubscribeEvent, SubscribeState> {
  SubscribeBloc() : super(SubscribeInitial()) {
    add(Update());
  }

  RemoteConfig remoteConfig = RemoteConfig.instance;

  Future<bool> syncRemote() async {
    late bool updated;
    try {
      remoteConfig.setConfigSettings(RemoteConfigSettings(
          fetchTimeout: Duration(seconds: 10),
          minimumFetchInterval: Duration(seconds: 10)));
      updated = await remoteConfig.fetchAndActivate();
    } catch (e) {}

    return updated;
  }

  @override
  Stream<SubscribeState> mapEventToState(
    SubscribeEvent event,
  ) async* {
    if (event is Update) {
      await syncRemote();
      bool subEnabled = remoteConfig.getBool('subscribtion');

      if (!subEnabled) {
        yield SubscribtionDeactivated();
      } else {
        yield AskSubscribe();
      }
    }

    if (event is Decline) {
      yield UnSubscribed();
    }

    if (event is Subscribe) {
      yield Subscribed();
    }
  }
}
