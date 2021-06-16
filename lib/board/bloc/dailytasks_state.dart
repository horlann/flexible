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

  DailytasksCommon(
      {this.askForSuperInsert = false,
      this.message = '',
      required this.tasks,
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
        askForSuperInsert: askForSuperInsert ?? this.askForSuperInsert,
        showDay: showDay ?? this.showDay,
        message: message ?? this.message);
  }
}

class DailytasksFailure extends DailytasksState {
  DailytasksFailure({required showDay}) : super(showDay: showDay);
}
