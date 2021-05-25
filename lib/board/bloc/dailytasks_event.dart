part of 'dailytasks_bloc.dart';

@immutable
abstract class DailytasksEvent {}

class DailytasksAddTask extends DailytasksEvent {
  final Task task;
  DailytasksAddTask({
    required this.task,
  });
}

class DailytasksUpdate extends DailytasksEvent {
  DailytasksUpdate();
}
