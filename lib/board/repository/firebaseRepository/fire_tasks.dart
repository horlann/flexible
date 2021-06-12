import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexible/board/models/task.dart';
import 'package:flexible/board/repository/tasts_repo_interface.dart';

class FireBaseTasksRepo extends ITasksRepo {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth fireAuth = FirebaseAuth.instance;

  bool get authenticated => fireAuth.currentUser != null;

  // Return tasks collection by user id
  CollectionReference taskCollection() {
    return _firestore
        .collection('users')
        .doc(fireAuth.currentUser!.uid)
        .collection('tasks');
  }

  // Return stream tasks collection by user id
  Stream taskCollectionChanges() {
    return _firestore
        .collection('users')
        .doc(fireAuth.currentUser!.uid)
        .collection('tasks')
        .snapshots();
  }

  @override
  Future<List<Task>> allTasks() async {
    QuerySnapshot tasks = await taskCollection().get();

    List<Task> taskList = tasks.docs
        .map((e) => Task.fromMap(e.data() as Map<String, dynamic>))
        .toList();

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
  Future setTask(Task task) async {
    await taskCollection().doc(task.uuid).set(task.toMap());
  }

  @override
  Future deleteTask(Task task) async {
    await taskCollection().doc(task.uuid).delete();
  }

  @override
  Stream? onChanges;
}
