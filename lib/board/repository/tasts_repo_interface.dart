import 'package:flexible/board/models/tasks/supertask.dart';
import 'package:flexible/board/models/tasks/task.dart';

abstract class ITasksRepo {
  Stream? onChanges;
  Future setTask(Task task);
  Future deleteTask(Task task);
  Future<List<Task>> allTasks();
  Future<List<Task>> tasksByPeriod(
      {required DateTime from, required DateTime to});
  Future setSuperTaskToQueue(SuperTask task);
  Future<List<SuperTask>> superTaskQueue();
  Future deleteSuperTaskfromQueue(SuperTask task);
}
