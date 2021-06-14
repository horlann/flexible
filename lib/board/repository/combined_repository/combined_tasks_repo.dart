import 'dart:async';
import 'package:flexible/board/models/tasks/task.dart';
import 'package:flexible/board/repository/firebaseRepository/fire_tasks.dart';
import 'package:flexible/board/repository/sqFliteRepository/sqflire_tasks.dart';
import 'package:flexible/board/repository/tasts_repo_interface.dart';

class CombinedTasksRepository extends ITasksRepo {
  SqfliteTasksRepo sqfliteTasksRepo = SqfliteTasksRepo();
  FireBaseTasksRepo fireBaseTasksRepo = FireBaseTasksRepo();
  // ignore: cancel_subscriptions
  StreamSubscription? fireListener;

  // Using to indicate data changes after sync or new data from firebase
  StreamController changesController = StreamController();
  Stream? onChanges;

  CombinedTasksRepository() {
    // If user autorize subscribe to changes
    fireBaseTasksRepo.fireAuth.authStateChanges().listen((event) {
      if (event == null) {
        fireListener!.cancel();
        fireListener = null;
      } else {
        subscribeToFire();
      }
    });

    // init changes stream
    onChanges = changesController.stream;
  }

  // Subscribe to firestore data and automatic synchronize anfer data changes
  subscribeToFire() {
    if (fireBaseTasksRepo.authenticated && fireListener == null) {
      fireListener = fireBaseTasksRepo.taskCollectionChanges().listen((event) {
        print('Something changes on firebase');
        syncDatabases();
      });
    }
  }

  dispose() {
    if (fireListener != null) {
      fireListener!.cancel();
    }
    changesController.close();
  }

  @override
  Future<List<Task>> allTasks() async {
    return await sqfliteTasksRepo.allTasks();
  }

  @override
  Future<List<Task>> tasksByPeriod(
      {required DateTime from, required DateTime to}) async {
    return await sqfliteTasksRepo.tasksByPeriod(from: from, to: to);
  }

  @override
  Future deleteTask(Task task) async {
    await sqfliteTasksRepo.deleteTask(task);

    // Only if authenticated
    if (fireBaseTasksRepo.authenticated) {
      fireBaseTasksRepo.deleteTask(task);
    }
  }

  @override
  Future setTask(Task task) async {
    await sqfliteTasksRepo.setTask(task);

    // Only if authenticated
    if (fireBaseTasksRepo.authenticated) {
      fireBaseTasksRepo.setTask(task);
    }
  }

  Future syncDatabases() async {
    if (fireBaseTasksRepo.authenticated) {
      // Get current records
      List<Task> fireRecords = await fireBaseTasksRepo.allTasks();
      List<Task> sqlRecords = await sqfliteTasksRepo.allTasks();

      // Update local records
      fireRecords.forEach((task) {
        sqfliteTasksRepo.setTask(task);
      });

      // update then
      sqlRecords = await sqfliteTasksRepo.allTasks();

      // Delete local records that been deleted on firestore
      sqlRecords.forEach((task) {
        if (!fireRecords.contains(task)) {
          sqfliteTasksRepo.deleteTask(task);
        }
      });

      // Notify subscriber
      changesController.add('changes');
    }
  }
}
