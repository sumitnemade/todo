import 'package:flutter/material.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic>? navigateTo(String routeName) {
    return navigatorKey.currentState?.pushReplacementNamed(routeName);
  }
}
