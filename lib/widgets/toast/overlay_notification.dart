import 'package:flutter/material.dart';


import '../../constants/enums.dart';
import '../../utils/sizes_helpers.dart';
import '../spacings.dart';
import 'notification.dart';
import 'overlay.dart';
import 'overlay_support.dart';

/// Popup a notification at the top of screen.
///
/// [duration] the notification display duration , overlay will auto dismiss after [duration].
/// if null , will be set to [kNotificationDuration].
/// if zero , will not auto dismiss in the future.
///
/// [position] the position of notification, default is [NotificationPosition.top],
/// can be [NotificationPosition.top] or [NotificationPosition.bottom].
///
OverlaySupportEntry showOverlayNotification(
  WidgetBuilder builder, {
  Duration? duration,
  Key? key,
  NotificationPosition position = NotificationPosition.top,
  BuildContext? context,
}) {
  duration ??= kNotificationDuration;
  return showOverlay(
    (context, t) {
      var alignment = MainAxisAlignment.start;
      if (position == NotificationPosition.bottom)
        alignment = MainAxisAlignment.end;
      else if (position == NotificationPosition.center)
        alignment = MainAxisAlignment.center;
      return Column(
        mainAxisAlignment: alignment,
        children: <Widget>[
          position == NotificationPosition.top
              ? TopSlideNotification(builder: builder, progress: t)
              : BottomSlideNotification(builder: builder, progress: t)
        ],
      );
    },
    duration: duration,
    key: key,
    context: context,
  );
}

///
/// Show a simple notification above the top of window.
///
OverlaySupportEntry showSimpleNotification(
  Widget content, {
  /**
   * See more [ListTile.leading].
   */
  Widget? leading,
  ToastType? toastType,

  /**
   * See more [ListTile.subtitle].
   */

  Widget? subtitle,
  /**
   * See more [ListTile.trailing].
   */
  Widget? trailing,
  /**
   * See more [ListTile.contentPadding].
   */
  EdgeInsetsGeometry? contentPadding,
  /**
   * The background color for notification, default to [ThemeData.accentColor].
   */
  Color? background,
  /**
   * See more [ListTileTheme.textColor],[ListTileTheme.iconColor].
   */
  Color? foreground,
  /**
   * The elevation of notification, see more [Material.elevation].
   */
  double elevation = 16,
  Duration? duration,
  Key? key,
  /**
   * True to auto hide after duration [kNotificationDuration].
   */
  bool autoDismiss = true,
  /**
   * Support left/right to dismiss notification.
   */
  @Deprecated('use slideDismissDirection instead') bool slideDismiss = false,
  /**
   * The position of notification, default is [NotificationPosition.top],
   */
  NotificationPosition position = NotificationPosition.top,
  BuildContext? context,
  /**
   * The direction in which the notification can be dismissed.
   */
  DismissDirection? slideDismissDirection,
}) {
  final dismissDirection = slideDismissDirection ??
      (slideDismiss ? DismissDirection.horizontal : DismissDirection.none);
  final entry = showOverlayNotification(
    (context) {
      return SlideDismissible(
        direction: dismissDirection,
        key: ValueKey(key),
        child: Material(
          color: Colors.transparent,
          elevation: 0,
          child: SafeArea(
              bottom: position == NotificationPosition.bottom,
              top: position == NotificationPosition.top,
              child: Container(
                  width: displayWidth(context),
                  decoration: BoxDecoration(
                      color: background ?? Theme.of(context).accentColor,
                      border: Border.all(
                        color: background ?? Theme.of(context).accentColor,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15))),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    children: [
                      Icon(
                        toastType == ToastType.SUCCESS
                            ? Icons.check_circle_rounded
                            : toastType == ToastType.ERROR
                                ? Icons.error
                                : Icons.info,
                        color: Colors.white,
                      ),
                      widthSpace(10),
                      Flexible(child: content),
                    ],
                  )
                  // ListTileTheme(
                  //     textColor: foreground ??
                  //         Theme.of(context).accentTextTheme.headline6?.color,
                  //     iconColor: foreground ??
                  //         Theme.of(context).accentTextTheme.headline6?.color,
                  //     child: Row(
                  //       children: [
                  //         content,
                  //       ],
                  //     )
                  // ListTile(
                  //   leading: leading,
                  //   title: content,
                  //   subtitle: subtitle,
                  //   trailing: trailing,
                  //   contentPadding: contentPadding,
                  // ),
                  // ),
                  )),
        ),
      );
    },
    duration: autoDismiss ? duration : Duration.zero,
    key: key,
    position: position,
    context: context,
  );
  return entry;
}

OverlaySupportEntry showProgressIndicator({
  double elevation = 16,
  Key? key,
  bool autoDismiss = false,
  @Deprecated('use slideDismissDirection instead') bool slideDismiss = true,
  BuildContext? context,
  DismissDirection? slideDismissDirection,
}) {
  final dismissDirection = slideDismissDirection ??
      (slideDismiss ? DismissDirection.horizontal : DismissDirection.none);
  final entry = showOverlayNotification(
    (context) {
      return Dismissible(
        direction: dismissDirection,
        key: ValueKey(key),
        child: const Material(
          color: Colors.transparent,
          elevation: 0,
          child: SafeArea(
              bottom: true, top: true, child: CircularProgressIndicator()),
        ),
      );
    },
    duration: Duration.zero,
    key: key,
    position: NotificationPosition.center,
    context: context,
  );
  return entry;
}

OverlaySupportEntry showFullScreenProgressIndicator({
  double elevation = 16,
  Key? key,
  bool autoDismiss = false,
  @Deprecated('use slideDismissDirection instead') bool slideDismiss = false,
  BuildContext? context,
  DismissDirection? slideDismissDirection,
}) {
  final dismissDirection = slideDismissDirection ??
      (slideDismiss ? DismissDirection.horizontal : DismissDirection.none);
  final entry = showOverlayNotification(
    (context) {
      return Dismissible(
        direction: dismissDirection,
        key: ValueKey(key),
        child: Material(
          color: Colors.transparent,
          elevation: 0,
          child: SafeArea(
              bottom: true,
              top: true,
              child: Container(
                  color: Colors.white,
                  width: displayWidth(context),
                  height: displayHeight(context) * 0.96,
                  child: const Center(child: CircularProgressIndicator()))),
        ),
      );
    },
    duration: Duration.zero,
    key: key,
    position: NotificationPosition.center,
    context: context,
  );
  return entry;
}
