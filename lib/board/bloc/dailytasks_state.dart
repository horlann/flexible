part of 'dailytasks_bloc.dart';

@immutable
abstract class DailytasksState extends Equatable {
  final DateTime showDay;
  DailytasksState({required this.showDay});
}

class DailytasksInitial extends DailytasksState {
  DailytasksInitial({required showDay}) : super(showDay: showDay);

  @override
  List<Object?> get props => [];
}

class DailytasksCommon extends DailytasksState {
  final List<Task> tasks;
  DailytasksCommon({required this.tasks, required showDay})
      : super(showDay: showDay);
  @override
  List<Object?> get props => [...tasks, showDay.toString()];
}

class DailytasksFailure extends DailytasksState {
  DailytasksFailure({required showDay}) : super(showDay: showDay);

  @override
  List<Object?> get props => [];
}
