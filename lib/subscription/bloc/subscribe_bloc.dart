import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flexible/authentification/services/firebase_auth.dart';
import 'package:flexible/subscription/remoteconf_repository.dart';
import 'package:flexible/subscription/subscribe_service_qon.dart';

part 'subscribe_event.dart';
part 'subscribe_state.dart';

class SubscribeBloc extends Bloc<SubscribeEvent, SubscribeState> {
  SubscribeBloc({required this.fireAuthService}) : super(SubscribeInitial()) {
    add(Update());
  }

  RemoteConfigRepository remoteConfigRepository = RemoteConfigRepository();
  SubscribeServiceQon subscribeService = SubscribeServiceQon();
  late FireAuthService fireAuthService;

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
        bool isAuthed = fireAuthService.isAuthenticated;
        if (isAuthed) {
          await subscribeService.setUserId(fireAuthService.getUser()!.uid);
          yield* mapCheckForSub();
        } else {
          yield AskForSubscribe(
              showInfoPopup: remoteConfigRepository.showInfoPopup,
              showAreYouSurePopup: remoteConfigRepository.showAreYouSurePopup,
              noThanksBtnOFF: remoteConfigRepository.noThanksBtnOFF);
        }
      }
    }

    if (event is Decline) {
      yield UnSubscribed();
    }

    if (event is Subscribe) {
      bool isAuthed = fireAuthService.isAuthenticated;
      if (isAuthed) {
        await subscribeService.setUserId(fireAuthService.getUser()!.uid);
        bool isActive = await subscribeService.makeSubMonth();
        if (isActive) {
          yield Subscribed();
        }
      } else {
        // Start auth and continue then
        yield RegisterAndProcess(continueSubscribe: true);
      }
    }

    if (event is Restore) {
      bool isAuthed = fireAuthService.isAuthenticated;
      if (isAuthed) {
        await subscribeService.setUserId(fireAuthService.getUser()!.uid);
        yield* mapCheckForSub();
      } else {
        // Start auth and continue then
        yield RegisterAndProcess(continueRestore: true);
      }
    }
  }

  Stream<SubscribeState> mapCheckForSub() async* {
    bool isActive = await subscribeService.checkSubMonth();
    if (isActive) {
      yield Subscribed();
    } else {
      yield AskForSubscribe(
          showInfoPopup: remoteConfigRepository.showInfoPopup,
          showAreYouSurePopup: remoteConfigRepository.showAreYouSurePopup,
          noThanksBtnOFF: remoteConfigRepository.noThanksBtnOFF);
    }
  }
}
