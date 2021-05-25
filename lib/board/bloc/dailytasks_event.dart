part of 'dailytasks_bloc.dart';

@immutable
abstract class DailytasksEvent extends Equatable {}

class DailytasksUpdate extends DailytasksEvent {
  DailytasksUpdate();
  @override
  List<Object?> get props => [];
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
