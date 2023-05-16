import 'package:flutter/material.dart';

class AnimatedWidgetSwitcher extends StatelessWidget {
  const AnimatedWidgetSwitcher({Key? key, required this.child})
      : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        switchInCurve: Curves.ease,
        switchOutCurve: Curves.ease,
        duration: const Duration(milliseconds: 100),
        transitionBuilder: (child, animation) {
          return ScaleTransition(
            scale: animation,
            child: child,
          );
        },
        child: child);
  }
}
