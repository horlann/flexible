import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flexible/authentification/models/user_data_model.dart';
import 'package:flexible/authentification/services/firebase_auth.dart';
import 'package:flexible/authentification/services/users_data_repository.dart';
import 'package:flexible/subscription/models/inner_sales_screen_config.dart';
import 'package:flexible/subscription/remoteconf_repository.dart';
import 'package:flexible/subscription/subscribe_service_qon.dart';

part 'subscribe_event.dart';
part 'subscribe_state.dart';

class SubscribeBloc extends Bloc<SubscribeEvent, SubscribeState> {
  SubscribeBloc({required this.fireAuthService, required this.usersDataRepo})
      : super(SubscribeInitial()) {
    // Launch Qonversion first
    initQonverion().then((value) => add(Update()));
  }

  RemoteConfigRepository remoteConfigRepository = RemoteConfigRepository();
  SubscribeServiceQon subscribeService = SubscribeServiceQon();
  late FireAuthService fireAuthService;
  late UsersDataRepo usersDataRepo;

  // Qonversion wont work if network connection is off
  bool qonLaunched = false;

  Future initQonverion() async {
    try {
      await subscribeService.launchQonverion;
      qonLaunched = true;
    } catch (e) {
      qonLaunched = false;
      print(e);
    }
  }

  @override
  Stream<SubscribeState> mapEventToState(
    SubscribeEvent event,
  ) async* {
    if (event is Update) {
      // If network issue use last saved data
      if (qonLaunched == false) {
        bool isAuthed = fireAuthService.isAuthenticated;
        if (isAuthed) {
          UserData? userData =
              await usersDataRepo.getUser(fireAuthService.getUser()!.uid);
          if (userData != null) {
            bool didSubscribedBefore = userData.subscribed;
            if (didSubscribedBefore) {
              yield Subscribed();
              return;
            } else {
              yield UnSubscribed();
              return;
            }
          } else {
            yield UnSubscribed();
            return;
          }
        } else {
          yield UnSubscribed();
          return;
        }
      }
      // Inner_Sales_Screen_Config
      yield InnerSalesScreenConfig(isscConfig: remoteConfigRepository.innerSalesScreenConfig);
      // Show sub page if oto enabled
      await remoteConfigRepository.syncRemote();
      bool hideInnerSalesScreen = remoteConfigRepository.hideInnerSalesScreen;
      print('Oto disabled > $hideInnerSalesScreen');
      if (hideInnerSalesScreen) {
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
        // Start purchase process
        bool isActive = await subscribeService
            .makeSubMonth()
            .onError((error, stackTrace) => false);
        print(isActive);
        // Show result
        if (isActive) {
          yield Subscribed();
        } else {
          yield AskForSubscribe(
              message: 'Billing process failled',
              showInfoPopup: remoteConfigRepository.showInfoPopup,
              showAreYouSurePopup: remoteConfigRepository.showAreYouSurePopup,
              noThanksBtnOFF: remoteConfigRepository.noThanksBtnOFF);
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

    if (event is DebugRestore) {
      bool isAuthed = fireAuthService.isAuthenticated;
      if (isAuthed) {
        yield Subscribed();
      } else {
        // Start auth and continue then
        yield RegisterAndProcess(continueRestore: true);
      }
    }
  }

  Stream<SubscribeState> mapCheckForSub() async* {
    bool isActive = await subscribeService
        .checkSubMonth()
        .onError((error, stackTrace) => false);

    // save last subscribe state to firebase
    try {
      UserData? userData =
          await usersDataRepo.getUser(fireAuthService.getUser()!.uid);
      usersDataRepo.setUser(userData!.copyWith(subscribed: isActive));
      print('Save last sub state succes > $isActive');
    } catch (e) {
      print('Save last sub state error >$e');
    }

    if (isActive) {
      yield Subscribed();
    } else {
      yield AskForSubscribe(
          message: 'You are not subscribed yet',
          showInfoPopup: remoteConfigRepository.showInfoPopup,
          showAreYouSurePopup: remoteConfigRepository.showAreYouSurePopup,
          noThanksBtnOFF: remoteConfigRepository.noThanksBtnOFF);
    }
  }
}
