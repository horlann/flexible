import 'package:flexible/board/models/task.dart';

abstract class ITasksRepo {
  Stream? onChanges;
  Future setTask(Task task);
  Future deleteTask(Task task);
  Future<List<Task>> allTasks();
  Future<List<Task>> tasksByPeriod(
      {required DateTime from, required DateTime to});
}
