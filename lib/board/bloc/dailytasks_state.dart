part of 'dailytasks_bloc.dart';

@immutable
abstract class DailytasksState {}

class DailytasksInitial extends DailytasksState {}

class DailytasksCommon extends DailytasksState {
  final List<Task> tasks;
  DailytasksCommon({required this.tasks});
}

class DailytasksFailure extends DailytasksState {}
