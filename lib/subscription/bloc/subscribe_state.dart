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
  AskForSubscribe({
    required this.showInfoPopup,
    required this.noThanksBtnOFF,
    required this.showAreYouSurePopup,
  });

  List<Object> get props =>
      [showInfoPopup, noThanksBtnOFF, showAreYouSurePopup];
}

class RegisterAndPay extends SubscribeState {}

class Subscribed extends SubscribeState {}

class UnSubscribed extends SubscribeState {}
