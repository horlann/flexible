import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flexible/board/models/day_options.dart';
import 'package:flexible/board/models/tasks/regular_taks.dart';
import 'package:flexible/board/models/tasks/task.dart';
import 'package:flexible/board/repository/combined_repository/combined_tasks_repo.dart';
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

    // Listen to changes and update ui
    if (tasksRepo.onChanges != null) {
      tasksRepo.onChanges!.listen((event) {
        add(DailytasksUpdate());
      });
    }
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

      List<Task> sqTasks = await tasksRepo.tasksByPeriod(
          from: startOfaDay(showDay), to: endOfaDay(showDay));

      yield DailytasksCommon(
          tasks: sqTasks, dayOptions: dayOptions, showDay: showDay);
    }

    if (event is DailytasksAddTask) {
      // add to db
      await tasksRepo.setTask(event.task);

      // Update
      this.add(DailytasksUpdate());
    }

    if (event is DailytasksUpdateTask) {
      // update in db
      await tasksRepo.setTask(event.task);

      // Update
      this.add(DailytasksUpdate());
    }

    if (event is DailytasksUpdateTaskAndShiftOther) {
      var statee = state;
      if (statee is DailytasksCommon) {
        // Save old task version
        Task oldTask = statee.tasks
            .where((element) => element.uuid == event.task.uuid)
            .first;

        // // Calc time shifting beetwen old and new task version
        // Duration timeShift = event.task.timeStart.difference(oldTask.timeStart);

        // Calc time Shift by task teriod
        Duration timeShift = event.task.period - oldTask.period;

        // Select only infront tssks with unlocked shift
        List<Task> infrontUnlockedTasks = statee.tasks
            .where((e) =>
                !e.timeStart.difference(oldTask.timeStart).isNegative &
                !e.timeLock &
                (e.uuid != event.task.uuid))
            .toList();
        // Do all only if shift is positive
        if (!timeShift.isNegative) {
          // Add timeshift to all selected tasks
          var shiftedTasks = infrontUnlockedTasks
              .map((e) => e.copyWith(timeStart: e.timeStart.add(timeShift)));
          // Update it data
          shiftedTasks.forEach((element) async {
            await tasksRepo.setTask(element);
          });
        }
      }

      // update task data
      await tasksRepo.setTask(event.task);

      // Update ui
      this.add(DailytasksUpdate());
    }

    if (event is DailytasksDeleteTask) {
      // update in db
      await tasksRepo.deleteTask(event.task);

      // Update
      this.add(DailytasksUpdate());
    }

    if (event is DailytasksSetDay) {
      // Set day
      showDay = event.day;
      // Update
      this.add(DailytasksUpdate());
    }

    if (event is DailytasksUpdateDayOptions) {
      // update in db
      await dayOptionsRepo.updateDayOptions(event.dayOptions);

      // Update
      this.add(DailytasksUpdate());
    }
  }
}
