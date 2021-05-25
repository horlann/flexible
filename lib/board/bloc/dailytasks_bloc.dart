import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flexible/board/models/task.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'dailytasks_event.dart';
part 'dailytasks_state.dart';

class DailytasksBloc extends Bloc<DailytasksEvent, DailytasksState> {
  DailytasksBloc() : super(DailytasksInitial()) {
    add(DailytasksUpdate());
  }

  @override
  Stream<DailytasksState> mapEventToState(
    DailytasksEvent event,
  ) async* {
    if (event is DailytasksUpdate) {
      // Load from storage
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List tasks = prefs.getStringList('tasks') ?? [];

      // Add first task if empty
      if (tasks.isEmpty) {
        prefs.setStringList('tasks', [
          Task(
                  isDone: false,
                  title: 'This u first task',
                  subtitle: 'Very nice day, youre welcome',
                  timeStart: DateTime.now(),
                  timeEnd: DateTime.now())
              .toJson()
        ]);
        tasks = prefs.getStringList('tasks') ?? [];
      }

      // Parse
      List<Task> taskParsed = tasks.map((e) => Task.fromJson(e)).toList();
      print(tasks);
      yield DailytasksCommon(tasks: taskParsed);
    }

    if (event is DailytasksAddTask) {
      // Add task to storage
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List tasks = prefs.getStringList('tasks') ?? [];
      prefs.setStringList('tasks', [...tasks, event.task.toJson()]);

      // Update
      this.add(DailytasksUpdate());
    }

    if (event is DailytasksUpdateTaskData) {
      print(event.task.toMap());
      // Add task to storage
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> tasks = prefs.getStringList('tasks') ?? [];

      tasks[tasks.indexWhere(
              (element) => json.decode(element)['uuid'] == event.task.uuid)] =
          event.task.toJson();

      prefs.setStringList('tasks', tasks);

      // Update
      this.add(DailytasksUpdate());
    }
  }
}
