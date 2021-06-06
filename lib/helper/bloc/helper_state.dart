part of 'helper_bloc.dart';

abstract class HelperState extends Equatable {
  const HelperState();

  @override
  List<Object> get props => [];
}

class HelperInitState extends HelperState {}

class ShowHelper extends HelperState {}

class HelperShowed extends HelperState {}
