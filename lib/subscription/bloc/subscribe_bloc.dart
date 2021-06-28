import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flexible/subscription/remoteconf_repository.dart';
import 'package:flexible/subscription/subscribe_service.dart';

part 'subscribe_event.dart';
part 'subscribe_state.dart';

class SubscribeBloc extends Bloc<SubscribeEvent, SubscribeState> {
  SubscribeBloc() : super(SubscribeInitial()) {
    add(Update());
    // print(subscribeService.getOfferings());
  }

  RemoteConfigRepository remoteConfigRepository = RemoteConfigRepository();
  SubscribeService subscribeService = SubscribeService();

  @override
  Stream<SubscribeState> mapEventToState(
    SubscribeEvent event,
  ) async* {
    if (event is Update) {
      // Show sub page if oto enabled
      await remoteConfigRepository.syncRemote();
      bool hideOTO = remoteConfigRepository.hideOTO;
      if (hideOTO) {
        yield SubscribtionDeactivated();
      } else {
        yield AskForSubscribe(
            showInfoPopup: remoteConfigRepository.showInfoPopup,
            showAreYouSurePopup: remoteConfigRepository.showAreYouSurePopup,
            noThanksBtnOFF: remoteConfigRepository.noThanksBtnOFF);
      }
    }

    if (event is Decline) {
      yield UnSubscribed();
    }

    if (event is Subscribe) {
      subscribeService.makeSubscribe();
    }

    if (event is Restore) {
      print('restore');
    }
  }
}
