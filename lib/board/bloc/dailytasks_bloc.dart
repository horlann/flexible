import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flexible/board/models/task.dart';
import 'package:flexible/board/repository/sqflire_tasks_repo.dart';
import 'package:meta/meta.dart';

part 'dailytasks_event.dart';
part 'dailytasks_state.dart';

class DailytasksBloc extends Bloc<DailytasksEvent, DailytasksState> {
  DailytasksBloc() : super(DailytasksInitial()) {
    add(DailytasksUpdate());
    sqfliteTasksRepo = SqfliteTasksRepo();
  }

  late SqfliteTasksRepo sqfliteTasksRepo;

  @override
  Stream<DailytasksState> mapEventToState(
    DailytasksEvent event,
  ) async* {
    if (event is DailytasksUpdate) {
      // Load from storage
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      List<Task> sqTasks = await sqfliteTasksRepo.tasks();

      // Add demo taks on first run
      if (sqTasks.isEmpty) {
        await sqfliteTasksRepo.addTask(Task(
            isDone: false,
            title: 'This you first task',
            subtitle: 'Very nice day, youre welcome',
            timeStart: DateTime.now(),
            timeEnd: DateTime.now()));

        sqTasks = await sqfliteTasksRepo.tasks();
      }

      yield DailytasksCommon(tasks: sqTasks);
    }

    if (event is DailytasksAddTask) {
      // add to db
      sqfliteTasksRepo.addTask(event.task);

      // Update
      this.add(DailytasksUpdate());
    }

    if (event is DailytasksUpdateTaskDone) {
      // update in db
      sqfliteTasksRepo.updateTaskDone(event.task);

      // Update
      this.add(DailytasksUpdate());
    }
  }
}
