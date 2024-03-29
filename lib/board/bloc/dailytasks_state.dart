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
  final bool askForSuperInsert;
  final String message;
  final DayOptions dayOptions;
  final List<Task> tasks;
  final List<SuperTask> superTasks;

  DailytasksCommon(
      {this.askForSuperInsert = false,
      this.message = '',
      required this.tasks,
      required this.superTasks,
      required this.dayOptions,
      required showDay})
      : super(showDay: showDay);

  DailytasksCommon copyWith({
    DayOptions? dayOptions,
    List<Task>? tasks,
    DateTime? showDay,
    bool? askForSuperInsert,
    String? message,
  }) {
    return DailytasksCommon(
        dayOptions: dayOptions ?? this.dayOptions,
        tasks: tasks ?? this.tasks,
        superTasks: superTasks ?? this.superTasks,
        askForSuperInsert: askForSuperInsert ?? this.askForSuperInsert,
        showDay: showDay ?? this.showDay,
        message: message ?? this.message);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DailytasksCommon &&
        other.askForSuperInsert == askForSuperInsert &&
        other.message == message &&
        other.dayOptions == dayOptions &&
        listEquals(other.tasks, tasks) &&
        listEquals(other.superTasks, superTasks);
  }

  @override
  int get hashCode {
    return askForSuperInsert.hashCode ^
        message.hashCode ^
        dayOptions.hashCode ^
        tasks.hashCode ^
        superTasks.hashCode;
  }
}

class DailytasksFailure extends DailytasksState {
  DailytasksFailure({required showDay}) : super(showDay: showDay);
}
