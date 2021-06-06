part of 'helper_bloc.dart';

abstract class HelperEvent extends Equatable {
  const HelperEvent();

  @override
  List<Object> get props => [];
}

class HelperAppStart extends HelperEvent {}

class HelperSeened extends HelperEvent {}
