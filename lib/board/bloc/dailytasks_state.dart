part of 'dailytasks_bloc.dart';

@immutable
abstract class DailytasksState extends Equatable {}

class DailytasksInitial extends DailytasksState {
  @override
  List<Object?> get props => [];
}

class DailytasksCommon extends DailytasksState {
  final List<Task> tasks;
  DailytasksCommon({required this.tasks});
  @override
  List<Object?> get props => [tasks.length];
}

class DailytasksFailure extends DailytasksState {
  @override
  List<Object?> get props => [];
}
