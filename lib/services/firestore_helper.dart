import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/TaskModel.dart';
import '../models/UserModel.dart';
import 'firestore_service.dart';

class FirebaseHelper {
  static final FirebaseHelper _instance = FirebaseHelper.internal();

  factory FirebaseHelper() => _instance;

  FirebaseHelper.internal();

  final _users = FirestoreService<UserModel>('users');
  final _tasks = FirestoreService<TaskModel>('tasks');

  // =============================== USER =======================================//

  Future<UserModel?> getUserDetails(String userId) => _users.get(userId);

  Future<void> signUp(String userId, UserModel user) =>
      _users.setDocument(user, userId);

  // =============================== TASKS =======================================//

  Stream<QuerySnapshot<Object?>> listenTasks(String userId) =>
      _tasks.getWhereListen([
        ['createdBy', '==', userId]
      ], orderBy: "date");

  Future<void> deleteTask(String id) => _tasks.removeDocument(id);

  Future<void> updateTask(TaskModel task) =>
      _tasks.updateDocument(task, task.id!);

  Future<void> addTask(TaskModel task) => _tasks.addDocument(task);
}
