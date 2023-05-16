library overlay_support;

export 'notification.dart';
export 'overlay_notification.dart';
export 'overlay.dart';
export 'overlay_keys.dart' hide KeyedOverlay;
export 'theme.dart';
export 'toast.dart';
export 'overlay_state_finder.dart' hide findOverlayState, OverlaySupportState;

/// The length of time the notification is fully displayed.
Duration kNotificationDuration = const Duration(milliseconds: 2000);

/// Notification display or hidden animation duration.
Duration kNotificationSlideDuration = const Duration(milliseconds: 300);