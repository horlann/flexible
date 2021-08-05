import 'package:flexible/board/models/tasks/task.dart';

List<List<Task>> turboSortAlgorithm({required List<Task> tasks}) {
  List<List<Task>> taskGroups = [];

  List<Task> tasksCopy = List.from(tasks);

  // Sort time start
  tasksCopy.sort((a, b) => a.timeStart.compareTo(b.timeStart));

  // Sort to groups
  // Cros-timed task add to one group
  int endTime = 0;
  for (var i = 0; i < tasksCopy.length; i++) {
    Task cTask = tasksCopy[i];
    if (endTime == 0) {
      endTime = cTask.timeStart.add(cTask.period).millisecondsSinceEpoch;
      taskGroups.add([cTask]);
      // taskGroups
      //     .add([cTask.timeStart, cTask.timeStart.add(cTask.period)]);
    } else {
      if (cTask.timeStart.millisecondsSinceEpoch < endTime) {
        taskGroups.last.add(cTask);
        // taskGroups.last.add(cTask.timeStart);
        // taskGroups.last.add(cTask.timeStart.add(cTask.period));
        if (cTask.timeStart.add(cTask.period).millisecondsSinceEpoch >
            endTime) {
          endTime = cTask.timeStart.add(cTask.period).millisecondsSinceEpoch;
        }
      } else {
        taskGroups.add([cTask]);
        // taskGroups
        //     .add([cTask.timeStart, cTask.timeStart.add(cTask.period)]);
        endTime = cTask.timeStart.add(cTask.period).millisecondsSinceEpoch;
      }
    }
  }
  return taskGroups;
}

List<List<Task>> groupingSortByStartTime({required List<Task> tasks}) {
  List<List<Task>> taskGroups = [];

  List<Task> tasksCopy = List.from(tasks);

  // Sort time start
  tasksCopy.sort((a, b) => a.timeStart.compareTo(b.timeStart));

  // Sort to groups
  // Cros-timed task add to one group
  int startTime = 0;
  for (var i = 0; i < tasksCopy.length; i++) {
    Task cTask = tasksCopy[i];
    if (startTime == 0) {
      startTime = cTask.timeStart.millisecondsSinceEpoch;
      taskGroups.add([cTask]);
    } else {
      // print(
      // '${cTask.timeStart.millisecondsSinceEpoch.toStringAsPrecision(8)} ${startTime.toStringAsPrecision(8)}');
      if (cTask.timeStart.millisecondsSinceEpoch.toStringAsPrecision(8) ==
          startTime.toStringAsPrecision(8)) {
        taskGroups.last.add(cTask);
      } else {
        taskGroups.add([cTask]);
        startTime = cTask.timeStart.millisecondsSinceEpoch;
      }
    }
  }
  return taskGroups;
}
