import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo/services/shared_pref.dart';

import '../constants/enums.dart';
import '../utils/utils.dart';
import 'error_reporter.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<bool> signWithEmail(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return true;
    } catch (e, stacktrace) {
      Utils.showToast(ToastType.ERROR, e.toString());
      if (kDebugMode) {
        print(e.toString());
      }
      ErrorReporter.recordError(e, stacktrace,
          reason: "AuthService signWithEmail");
    }
    return false;
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    await SharedPref.saveString("email", googleUser?.email ?? "");
    await SharedPref.saveString("name", googleUser?.displayName ?? "");
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await _firebaseAuth.signInWithCredential(credential);
  }

  Future<bool> signUp(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return true;
    } catch (e, stacktrace) {
      Utils.showToast(ToastType.ERROR, e.toString());
      if (kDebugMode) {
        print(e.toString());
      }
      ErrorReporter.recordError(e, stacktrace,
          reason: "AuthService signWithEmail");
    }
    return false;
  }
}
