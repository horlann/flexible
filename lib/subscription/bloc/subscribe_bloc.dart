import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flexible/subscription/remoteconf_repository.dart';
import 'package:flexible/subscription/subscribe_service_qon.dart';

part 'subscribe_event.dart';
part 'subscribe_state.dart';

class SubscribeBloc extends Bloc<SubscribeEvent, SubscribeState> {
  SubscribeBloc() : super(SubscribeInitial()) {
    add(Update());
    // print(subscribeService.getOfferings());
  }

  RemoteConfigRepository remoteConfigRepository = RemoteConfigRepository();
  SubscribeServiceQon subscribeService = SubscribeServiceQon();

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
      subscribeService.makeSubMonth();
    }

    if (event is Restore) {
      print('restore');
    }
  }
}
