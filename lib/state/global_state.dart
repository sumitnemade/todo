import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:todo/models/TaskModel.dart';
import 'package:todo/state/user_state.dart';

import '../models/UserModel.dart';
import '../services/firestore_helper.dart';
import '../services/navigation_service.dart';

class GlobalState extends ChangeNotifier {
  List<TaskModel> _tasks = [];
  bool _taskLoaded = false;
  final _db = FirebaseHelper();
  static BuildContext context = NavigationService.navigatorKey.currentContext!;
  late StreamSubscription<QuerySnapshot<Object?>> _streamSubscription;

  GlobalState();

  List<TaskModel> get tasks => _tasks;

  bool get taskLoaded => _taskLoaded;

  void clearData() {
    _taskLoaded = false;
    _streamSubscription.cancel();
    notifyListeners();
  }

  void loadData() {
    var appUser = Provider.of<UserState>(context, listen: false).appUser!;

    _streamSubscription = _db.listenTasks(appUser.id!).listen((querySnapshot) {
      _taskLoaded = true;
      _tasks = querySnapshot.docs.map((doc) {
        return TaskModel.fromFirestore(doc);
      }).toList();
      notifyListeners();
    });
  }
}
