import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexible/board/models/task.dart';
import 'package:flexible/board/repository/tasts_repo_interface.dart';

class FireBaseTasksRepo extends ITasksRepo {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth fireAuth = FirebaseAuth.instance;

  CollectionReference taskCollection() {
    if (fireAuth.currentUser != null) {
      return firestore
          .collection('users')
          .doc(fireAuth.currentUser!.uid)
          .collection('tasks');
    }
    throw Exception('Not authorized');
  }

  @override
  Future<List<Task>> allTasks() async {
    QuerySnapshot tasks = await taskCollection().get();

    List<Task> taskList =
        tasks.docs.map((e) => Task.fromMap(e as Map<String, dynamic>)).toList();

    return taskList;
  }

  @override
  Future<List<Task>> tasksByPeriod(
      {required DateTime from, required DateTime to}) async {
    QuerySnapshot tasks = await taskCollection()
        .where('timeStart', isGreaterThan: from.millisecondsSinceEpoch)
        .where('timeStart', isLessThan: to.millisecondsSinceEpoch)
        .get();

    List<Task> taskList = tasks.docs
        .map((e) => Task.fromMap(e.data() as Map<String, dynamic>))
        .toList();

    return taskList;
  }

  @override
  Future addTask(Task task) async {
    await taskCollection().doc(task.uuid).set(task.toMap());
  }

  @override
  Future deleteTask(Task task) async {
    await taskCollection().doc(task.uuid).delete();
  }

  @override
  Future updateTask(Task task) async {
    await taskCollection().doc(task.uuid).set(task.toMap());
  }
}
