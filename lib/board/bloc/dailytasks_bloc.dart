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
  DailytasksBloc({required this.tasksRepo}) : super(DailytasksInitial()) {
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
      // Load from storage
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      List<Task> sqTasks = await tasksRepo.tasksByPeriod(
          from: startOfaDay(showDay), to: endOfaDay(showDay));

      // Add demo taks on first run
      if (sqTasks.isEmpty) {
        await tasksRepo.addTask(Task(
            isDone: false,
            title: 'This you first task',
            subtitle: 'Very nice day, youre welcome',
            timeStart: DateTime.now(),
            timeEnd: DateTime.now()));

        sqTasks = await tasksRepo.allTasks();
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
  }
}
