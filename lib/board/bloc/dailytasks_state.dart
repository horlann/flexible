part of 'dailytasks_bloc.dart';

@immutable
abstract class DailytasksState {
  final DateTime showDay;
  DailytasksState({required this.showDay});
}

class DailytasksInitial extends DailytasksState {
  DailytasksInitial({required showDay}) : super(showDay: showDay);
}

class DailytasksLoading extends DailytasksState {
  DailytasksLoading({required showDay}) : super(showDay: showDay);
}

class DailytasksCommon extends DailytasksState {
  final List<Task> tasks;
  DailytasksCommon({required this.tasks, required showDay})
      : super(showDay: showDay);
}

class DailytasksFailure extends DailytasksState {
  DailytasksFailure({required showDay}) : super(showDay: showDay);
}
