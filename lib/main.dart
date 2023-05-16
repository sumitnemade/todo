import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:todo/screens/home.dart';
import 'package:todo/screens/auth.dart';
import 'package:todo/services/error_reporter.dart';
import 'package:todo/services/navigation_service.dart';
import 'package:todo/state/global_state.dart';
import 'package:todo/state/user_state.dart';
import 'package:todo/themes/themes.dart';
import 'package:todo/widgets/animated_widget_switcher.dart';
import 'package:todo/widgets/toast/overlay_state_finder.dart';

import 'constants/app_colors.dart';
import 'constants/enums.dart';
import 'constants/strings.dart';
import 'screens/splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  ErrorReporter.init();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: AppColors.white,
    statusBarColor: AppColors.primary,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  runZonedGuarded(() {
    runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => GlobalState()),
      ChangeNotifierProvider(create: (context) => UserState()),
    ], child: const MyApp()));
  },
      (error, stack) =>
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        title: Strings.appName,
        theme: Themes.tealGray(),
        navigatorKey: NavigationService.navigatorKey,
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserState>(context);
    return StreamBuilder<Status>(
      stream: authProvider.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        } else {
          if (snapshot.data == Status.authenticated &&
              authProvider.appUser != null) {
            return const AnimatedWidgetSwitcher(child: Home());
          } else if (((snapshot.data == Status.unauthenticated) &&
                  authProvider.appUser == null) ||
              (snapshot.data == Status.userInactive)) {
            if (snapshot.data == Status.userInactive) {
              authProvider.signOut();
            }
            return const AnimatedWidgetSwitcher(child: Auth());
          } else {
            return const AnimatedWidgetSwitcher(child: Splash());
          }
        }
      },
    );
  }
}
