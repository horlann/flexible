import 'package:flexible/board/models/task.dart';
import 'package:flexible/board/repository/tasts_repo_interface.dart';

class FireBaseTasksRepo extends ITasksRepo {
  final String userID;
  FireBaseTasksRepo({
    required this.userID,
  });

  @override
  Future addTask(Task task) {
    // TODO: implement addTask
    throw UnimplementedError();
  }

  @override
  Future<List<Task>> allTasks() {
    // TODO: implement allTasks
    throw UnimplementedError();
  }

  @override
  Future deleteTask(Task task) {
    // TODO: implement deleteTask
    throw UnimplementedError();
  }

  @override
  Future<List<Task>> tasksByPeriod(
      {required DateTime from, required DateTime to}) {
    // TODO: implement tasksByPeriod
    throw UnimplementedError();
  }

  @override
  Future updateTask(Task task) {
    // TODO: implement updateTask
    throw UnimplementedError();
  }
}
