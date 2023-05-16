import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/services/error_reporter.dart';

import '../constants/enums.dart';
import '../models/UserModel.dart';
import '../services/auth_service.dart';
import '../services/firestore_helper.dart';
import '../services/navigation_service.dart';
import '../services/shared_pref.dart';
import 'global_state.dart';

class UserState extends ChangeNotifier {
  User? _firebaseUser;
  UserModel? _appUser;
  Status _status = Status.uninitialized;
  FirebaseHelper db = FirebaseHelper();
  final AuthService _authService = AuthService();
  final streamController = StreamController<Status>();
  static BuildContext context = NavigationService.navigatorKey.currentContext!;

  Future signOut() async {
    await _authService.signOut();
    _appUser = null;
    _firebaseUser = null;

    _status = Status.unauthenticated;
    SharedPref.clearData();
    Provider.of<GlobalState>(context, listen: false).clearData();
    notifyListeners();
    streamController.add(_status);
    return Future.delayed(Duration.zero);
  }

  Future<void> signIn(String email, String password) async {
    await _authService.signWithEmail(email, password);
  }

  UserState() {
    streamController.add(_status);

    Future.delayed(const Duration(seconds: 7), () {
      checkAuthStatus();
    });
  }

  User? get firebaseUser => _firebaseUser;

  Stream<Status> get authStateChanges => streamController.stream;

  UserModel? get appUser => _appUser;

  setAppUser(UserModel appUser) {
    _appUser = appUser;
  }

  setStatus(Status status) {
    _status = status;
    streamController.add(_status);
  }

  setFirebaseUser(User user) {
    _firebaseUser = user;
  }

  Future<void> signUP(String email, String name, String password) async {
    await _authService.signUp(email, password);
  }

  Future<UserCredential?> signInGoogle() async {
    try {
      var val = await _authService.signInWithGoogle();
      await SharedPref.saveString("email", val.user?.email ?? "");
      await SharedPref.saveString("name", val.user?.displayName ?? "");
      notifyListeners();
      return val;
    } catch (e, stackTrace) {
      ErrorReporter.recordError(e, stackTrace, reason: "signInGoogle");
      return null;
    }
  }

  Future<UserModel?> getAppUser(String userId) async {
    return await db.getUserDetails(userId);
  }

  Future<void> checkAuthStatus() async {
    _authService.authStateChanges.listen((User? user) async {
      streamController.add(Status.authenticating);
      _firebaseUser = user;
      if (user == null) {
        _status = Status.unauthenticated;
      } else {
        String email = await SharedPref.getSavedString("email");
        String name = await SharedPref.getSavedString("name");

        _appUser = await getAppUser(_firebaseUser!.uid);

        _status = Status.authenticated;
        if (_appUser != null && _appUser!.displayName != null) {
          if (_appUser?.status?.toLowerCase() != "active") {
            _status = Status.userInactive;
          }
        } else {
          _appUser = UserModel(
              createdAt: Timestamp.now(),
              email: email,
              displayName: name,
              status: "active");
          await FirebaseHelper().signUp(
            _firebaseUser!.uid,
            _appUser!,
          );
          _appUser?.id = _firebaseUser!.uid;
        }
        Provider.of<GlobalState>(context, listen: false).loadData();
      }
      streamController.add(_status);
      notifyListeners();
    });
  }
}
