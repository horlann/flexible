import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flexible/board/models/task.dart';
import 'package:flexible/board/repository/tasts_repo_interface.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'dailytasks_event.dart';
part 'dailytasks_state.dart';

class DailytasksBloc extends Bloc<DailytasksEvent, DailytasksState> {
  DailytasksBloc({required this.tasksRepo})
      : super(DailytasksInitial(showDay: DateTime.now())) {
    add(DailytasksUpdate());
  }
  // db
  late ITasksRepo tasksRepo;

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
      // Load from sqlite

      // List<Task> sqTasks = await tasksRepo.allTasks();

      List<Task> sqTasks = await tasksRepo.tasksByPeriod(
          from: startOfaDay(showDay), to: endOfaDay(showDay));

      // Add demo taks on first run
      if (sqTasks.length < 2) {
        // Add Good morning task
        await tasksRepo.addTask(Task(
          isDone: false,
          title: 'Good Morning',
          subtitle: 'Have a nice day',
          timeStart: startOfaDay(showDay).add(Duration(hours: 8)),
          period: Duration(),
          isDonable: true,
          color: Color(0xffEE7579),
        ));
        // Add undonable good night task
        await tasksRepo.addTask(Task(
          isDone: false,
          title: 'Good night',
          subtitle: 'Sleep well',
          timeStart: startOfaDay(showDay).add(Duration(hours: 23)),
          period: Duration(),
          isDonable: false,
          color: Color(0xffEE7579),
        ));
        // Reload
        sqTasks = await tasksRepo.tasksByPeriod(
            from: startOfaDay(showDay), to: endOfaDay(showDay));
      }

      yield DailytasksCommon(tasks: sqTasks, showDay: showDay);
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
