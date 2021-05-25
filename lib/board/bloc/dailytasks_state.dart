part of 'dailytasks_bloc.dart';

@immutable
abstract class DailytasksState extends Equatable {}

class DailytasksInitial extends DailytasksState {
  @override
  List<Object?> get props => [];
}

class DailytasksCommon extends DailytasksState {
  final DateTime showDay;
  final List<Task> tasks;
  DailytasksCommon({required this.tasks, required this.showDay});
  @override
  List<Object?> get props => [tasks.length, showDay.toString()];
}

class DailytasksFailure extends DailytasksState {
  @override
  List<Object?> get props => [];
}
