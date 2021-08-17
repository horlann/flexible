part of 'subscribe_bloc.dart';

abstract class SubscribeState extends Equatable {
  const SubscribeState();

  @override
  List<Object> get props => [];
}

class SubscribeInitial extends SubscribeState {}

class SubscribtionDeactivated extends SubscribeState {}

class AskForSubscribe extends SubscribeState {
  final bool showInfoPopup;
  final bool noThanksBtnOFF;
  final bool showAreYouSurePopup;
  final String message;
  final List<IsscConfig> isscConfig;
  final List<QProduct> products;
  AskForSubscribe({
    required this.showInfoPopup,
    required this.noThanksBtnOFF,
    required this.showAreYouSurePopup,
    required this.isscConfig,
    required this.products,
    this.message = '',
  });

  List<Object> get props => [
        showInfoPopup,
        noThanksBtnOFF,
        showAreYouSurePopup,
        isscConfig,
        products,
        message.isNotEmpty ? Random().nextDouble().toString() : ''
      ];
}

class RegisterAndProcess extends SubscribeState {
  final bool continueRestore;
  final bool continueSubscribe;
  RegisterAndProcess({
    this.continueRestore = false,
    this.continueSubscribe = false,
  });
}

class Subscribed extends SubscribeState {
  final bool allFeatures;
  final bool hideAds;
  Subscribed({
    this.allFeatures = false,
    this.hideAds = false,
  });
}

class UnSubscribed extends SubscribeState {}

