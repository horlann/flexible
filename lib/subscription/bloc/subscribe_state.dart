part of 'subscribe_bloc.dart';

abstract class SubscribeState extends Equatable {
  const SubscribeState();

  @override
  List<Object> get props => [];
}

class SubscribeInitial extends SubscribeState {}

class SubscribtionDeactivated extends SubscribeState {}

class AskSubscribe extends SubscribeState {}

class Subscribed extends SubscribeState {}

class UnSubscribed extends SubscribeState {}
