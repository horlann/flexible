import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flexible/board/models/day_options.dart';
import 'package:flexible/board/models/task.dart';
import 'package:flexible/board/repository/day_options_interface.dart';
import 'package:flexible/board/repository/tasts_repo_interface.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'dailytasks_event.dart';
part 'dailytasks_state.dart';

class DailytasksBloc extends Bloc<DailytasksEvent, DailytasksState> {
  DailytasksBloc({required this.tasksRepo, required this.dayOptionsRepo})
      : super(DailytasksInitial(showDay: DateTime.now())) {
    add(DailytasksUpdate());
  }
  // db
  late ITasksRepo tasksRepo;
  late IDayOptionsRepo dayOptionsRepo;

  // determine what the day to show
  DateTime showDay = DateTime.now();

  // Round date funcs
  // uses for select period
  DateTime startOfaDay(DateTime date) => DateUtils.dateOnly(date);
  DateTime endOfaDay(DateTime date) =>
      DateUtils.dateOnly(date).add(Duration(days: 1));

  @override
  Stream<DailytasksState> mapEventToState(
    DailytasksEvent event,
  ) async* {
    if (event is DailytasksUpdate) {
      // Load day options
      DayOptions dayOptions = await dayOptionsRepo.getDayOptionsByDate(showDay);
      // Load from sqlite

      // List<Task> sqTasks = await tasksRepo.allTasks();

      List<Task> sqTasks = await tasksRepo.tasksByPeriod(
          from: startOfaDay(showDay), to: endOfaDay(showDay));

      yield DailytasksCommon(
          tasks: sqTasks, dayOptions: dayOptions, showDay: showDay);
    }

    if (event is DailytasksAddTask) {
      // add to db
      tasksRepo.addTask(event.task);

      // Update
      this.add(DailytasksUpdate());
    }

    if (event is DailytasksUpdateTask) {
      // update in db
      tasksRepo.updateTask(event.task);

      // Update
      this.add(DailytasksUpdate());
    }

    if (event is DailytasksDeleteTask) {
      // update in db
      tasksRepo.deleteTask(event.task);

      // Update
      this.add(DailytasksUpdate());
    }

    if (event is DailytasksSetDay) {
      // Set day
      showDay = event.day;
      // Update
      this.add(DailytasksUpdate());
    }
  }
}
