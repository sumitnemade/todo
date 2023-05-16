import 'package:flutter/material.dart';

import '../../constants/keys.dart';
import 'overlay.dart';
import 'theme.dart';

class Toast {
  Toast._private();

  /// Show the view or text notification for a short period of time.
  /// This time could be user-definable.
  static const LENGTH_SHORT = Duration(milliseconds: 2000);

  /// Show the view or text notification for a long period of time.
  /// This time could be user-definable.
  static const LENGTH_LONG = Duration(milliseconds: 3500);
}

/// Popup a message in front of screen.
///
/// [duration] : the duration to show a toast,
/// for most situation, you can use [Toast.LENGTH_SHORT] and [Toast.LENGTH_LONG]
///
void toast(String message,
    {Duration duration = Toast.LENGTH_SHORT,
    BuildContext? context,
    Color? backgroundColor,
    Color? textColor}) {
  if (duration <= Duration.zero) {
    //fast fail
    return;
  }

  showOverlay(
    (context, t) {
      return Opacity(
          opacity: t,
          child: _Toast(
            content: Text(
              message,
              style: TextStyle(
                fontFamily: Keys.font,
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
                letterSpacing: 0.3112128999999997,
              ),
            ),
            backgroundColor: backgroundColor,
          ));
    },
    curve: Curves.easeIn,
    key: const ValueKey('overlay_toast'),
    duration: duration,
    context: context,
  );
}

class _Toast extends StatelessWidget {
  final Widget? content;
  final Color? backgroundColor;

  const _Toast({Key? key, required this.content, this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final toastTheme = OverlaySupportTheme.toast(context);
    return SafeArea(
      maintainBottomViewPadding: true,
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: DefaultTextStyle(
          style: TextStyle(color: toastTheme?.textColor),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: toastTheme?.alignment ?? const Alignment(0, 0.618),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: backgroundColor ?? toastTheme?.background,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: content,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
