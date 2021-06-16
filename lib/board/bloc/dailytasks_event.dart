part of 'dailytasks_bloc.dart';

@immutable
abstract class DailytasksEvent extends Equatable {}

class DailytasksUpdate extends DailytasksEvent {
  DailytasksUpdate();
  @override
  List<Object?> get props => [];
}

class DailytasksSetDay extends DailytasksEvent {
  final DateTime day;
  DailytasksSetDay({
    required this.day,
  });

  @override
  List<Object?> get props => [this.day.millisecondsSinceEpoch];
}

class DailytasksAddTask extends DailytasksEvent {
  final Task task;
  DailytasksAddTask({
    required this.task,
  });

  @override
  List<Object?> get props => [task.toString()];
}

class DailytasksUpdateTask extends DailytasksEvent {
  final Task task;
  DailytasksUpdateTask({
    required this.task,
  });

  @override
  List<Object?> get props => [task.toString()];
}

class DailytasksUpdateTaskAndShiftOther extends DailytasksEvent {
  final Task task;
  DailytasksUpdateTaskAndShiftOther({
    required this.task,
  });

  @override
  List<Object?> get props => [task.toString()];
}

class DailytasksUpdateDayOptions extends DailytasksEvent {
  final DayOptions dayOptions;
  DailytasksUpdateDayOptions({
    required this.dayOptions,
  });

  @override
  List<Object?> get props => [dayOptions.toString()];
}

class DailytasksDeleteTask extends DailytasksEvent {
  final Task task;
  DailytasksDeleteTask({
    required this.task,
  });

  @override
  List<Object?> get props => [task.toString()];
}

class DailytasksSuperTaskIteration extends DailytasksEvent {
  final SuperTask task;
  DailytasksSuperTaskIteration({
    required this.task,
  });

  @override
  List<Object?> get props => [task.toString()];
}

class DailytasksSuperTaskAdd extends DailytasksEvent {
  final SuperTask task;
  DailytasksSuperTaskAdd({
    required this.task,
  });

  @override
  List<Object?> get props => [task.toString()];
}

class DailytasksSuperInsert extends DailytasksEvent {
  @override
  List<Object?> get props => [];
}

class DailytasksAskForInsert extends DailytasksEvent {
  @override
  List<Object?> get props => [];
}
