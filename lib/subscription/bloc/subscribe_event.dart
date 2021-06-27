part of 'subscribe_bloc.dart';

abstract class SubscribeEvent extends Equatable {
  const SubscribeEvent();

  @override
  List<Object> get props => [];
}

class Update extends SubscribeEvent {}

class Decline extends SubscribeEvent {}

class Subscribe extends SubscribeEvent {}

class Restore extends SubscribeEvent {}
