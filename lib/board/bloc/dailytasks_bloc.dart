import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flexible/board/models/day_options.dart';
import 'package:flexible/board/models/tasks/supertask.dart';
import 'package:flexible/board/models/tasks/task.dart';
import 'package:flexible/board/repository/day_options_interface.dart';
import 'package:flexible/board/repository/tasts_repo_interface.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

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

    if (event is DailytasksSuperTaskIteration) {
      SuperTask task = event.task.copyWith(
          // globalDurationLeft: event.task.globalDurationLeft + event.task.period,
          isDonable: false,
          timeLock: true,
          isDone: true);

      await tasksRepo.setTask(task);

      // Update
      this.add(DailytasksUpdate());
    }
    if (event is DailytasksSuperTaskAdd) {
      await tasksRepo.setSuperTaskToQueue(event.task);

      this.add(DailytasksAskForInsert());
    }

    // Ask user for supertask insertion
    if (event is DailytasksAskForInsert) {
      DailytasksState cstate = this.state;

      if (cstate is DailytasksCommon) {
        yield cstate.copyWith(askForSuperInsert: true);
      }
    }

    // Insert supertask in selected day
    // Insert by priority from 1 to 3
    if (event is DailytasksSuperInsert) {
      DayOptions dayOptions = await dayOptionsRepo.getDayOptionsByDate(showDay);

      List<Task> currentTasks = await tasksRepo.tasksByPeriod(
          from: startOfaDay(showDay), to: endOfaDay(showDay));

      List<SuperTask> superTasks = await tasksRepo.superTaskQueue();

      // Insert super tasks in gaps by priority
      for (var i = 1; i <= 3; i++) {
        // Iterate by priority
        superTasks.forEach((superTask) {
          // print(i);
          if (superTask.priority == i) {
            // Search gap by duration
            bool finded = false;
            calcGaps(currentTasks: currentTasks, dayOptions: dayOptions)
                .forEach((gap) async {
              // Search only if not finded before
              if (!finded) {
                if (superTask.period < gap.last.difference(gap.first)) {
                  // Mark as finded
                  finded = true;
                  // insert task in the gap
                  currentTasks.add(superTask.copyWith(
                      uuid: Uuid().v1(),
                      timeStart: gap.first.add(Duration(seconds: 5)),
                      globalDurationLeft:
                          superTask.globalDurationLeft + superTask.period));
                  await tasksRepo.setTask(superTask.copyWith(
                      globalDurationLeft:
                          superTask.globalDurationLeft + superTask.period,
                      uuid: Uuid().v1(),
                      timeStart: gap.first.add(Duration(seconds: 5))));

                  // Check if supertask global complete
                  if (superTask.globalDurationLeft + superTask.period <
                      superTask.globalDuration) {
                    await tasksRepo.setSuperTaskToQueue(superTask.copyWith(
                        timeStart: gap.first.add(Duration(seconds: 5)),
                        globalDurationLeft:
                            superTask.globalDurationLeft + superTask.period));
                  } else {
                    await tasksRepo.deleteSuperTaskfromQueue(superTask);
                  }

                  return;
                }
              }
            });
          }
        });
      }

      // Notify user on complete

      DailytasksState cstate = this.state;

      if (cstate is DailytasksCommon) {
        if (superTasks.isEmpty) {
          yield cstate.copyWith(
              message: 'You have no Super Tasks', askForSuperInsert: false);
        } else {
          yield cstate.copyWith(message: 'Complete', askForSuperInsert: false);
        }
      }

      // Update
      this.add(DailytasksUpdate());
    }
  }
}

// Uses for supertask insertion
// Calc gaps weetween tasks and daytimes
// Return pairs of gap start and end
List<List<DateTime>> calcGaps(
    {required DayOptions dayOptions, required List<Task> currentTasks}) {
  List<List<DateTime>> freeTimeGaps = [];

  currentTasks.sort((a, b) => a.timeStart.compareTo(b.timeStart));

  // If no tasks add gap between day start and stop
  if (currentTasks.isEmpty) {
    freeTimeGaps.add([dayOptions.wakeUpTime, dayOptions.goToSleepTime]);
  }

  // Add gap between day start and first task
  if (currentTasks.isNotEmpty) {
    if (!currentTasks.first.timeStart
        .difference(dayOptions.wakeUpTime)
        .isNegative) {
      freeTimeGaps.add([dayOptions.wakeUpTime, currentTasks.first.timeStart]);
    }
  }

  // Add gaps between tasks
  for (var i = 0; i < currentTasks.length - 1; i++) {
    // get prev task
    Task t = currentTasks[i];

    // get next task
    Task nt = currentTasks[i + 1];

    DateTime timeendCurrent = t.timeStart.add(t.period);

    DateTime timeStartNext = nt.timeStart;

    // add gap
    freeTimeGaps.add([timeendCurrent, timeStartNext]);
  }

  // Add gap between last task and day end
  if (currentTasks.isNotEmpty) {
    DateTime timeEndLast =
        currentTasks.last.timeStart.add(currentTasks.last.period);

    if (!dayOptions.goToSleepTime.difference(timeEndLast).isNegative) {
      freeTimeGaps.add([timeEndLast, dayOptions.goToSleepTime]);
    }
  }

  return freeTimeGaps;
}
