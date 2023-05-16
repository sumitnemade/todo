import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import 'navigation_service.dart';

class ErrorReporter {
  static final ErrorReporter _instance = ErrorReporter._internal();
  static BuildContext context = NavigationService.navigatorKey.currentContext!;

  factory ErrorReporter() {
    return _instance;
  }

  ErrorReporter._internal();

  static Future<void> init() async {
    await Firebase.initializeApp();
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  }

  static void recordError(dynamic error, dynamic stackTrace,
      {required String reason}) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace, reason: reason);
  }

  static void setUserId(String userId) {
    FirebaseCrashlytics.instance.setUserIdentifier(userId);
  }

  static void setCustomKey(String key, dynamic value) {
    FirebaseCrashlytics.instance.setCustomKey(key, value.toString());
  }

  static void log(String message) {
    FirebaseCrashlytics.instance.log(message);
  }

  static Future<bool> runSafely(
    Function() function,
    String widgetName, {
    bool showDialogOnFailure = false,
  }) async {
    try {
      await function();
      return true;
    } catch (error, stackTrace) {
      String className = widgetName.split(".").last;
      ErrorReporter.recordError(
        error,
        stackTrace,
        reason:
            'Error in $widgetName ($className, line ${stackTrace.toString().split("\n").elementAt(0).split(":").elementAt(1)})',
      );
      if (showDialogOnFailure) {
        bool retry = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('An error occurred'),
              content: const Text('Would you like to try again?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: const Text('Retry'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        );
        if (retry) {
          return runSafely(
            function,
            widgetName,
            showDialogOnFailure: false,
          );
        } else {
          return false;
        }
      } else {
        return false;
      }
    }
  }
}
