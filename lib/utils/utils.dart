import 'package:flutter/material.dart';
import 'package:todo/constants/app_colors.dart';

import '../constants/enums.dart';
import '../constants/keys.dart';
import '../services/navigation_service.dart';
import '../widgets/toast/notification.dart';
import '../widgets/toast/overlay_notification.dart';

class Utils {
  static BuildContext context = NavigationService.navigatorKey.currentContext!;

  static void showToast(ToastType toastType, String? message,
      {NotificationPosition? position}) {
    showSimpleNotification(
        Text(
          message ?? "",
          style: const TextStyle(
            fontFamily: Keys.font,
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            letterSpacing: 0.3112128999999997,
          ),
        ),
        toastType: toastType,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        duration: const Duration(seconds: 4),
        position: position ?? NotificationPosition.top,
        background: toastType == ToastType.SUCCESS
            ? Colors.green
            : toastType == ToastType.ERROR
                ? Colors.red
                : Colors.orangeAccent);
  }

  static Future<DateTime?> showDateTimePicker(BuildContext context,
      {DateTime? initialDate}) async {
    initialDate ??= DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );
      if (selectedTime != null) {
        return DateTime(
          picked.year,
          picked.month,
          picked.day,
          selectedTime.hour,
          selectedTime.minute,
        );
      }
    }

    return null;
  }

  static void showConfirmationDialog({
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    required Function() onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(color: AppColors.primary, width: 2.0),
          ),
          elevation: 8.0,
          backgroundColor: Colors.white,
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: Text(
                cancelText ?? "No",
                style: const TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: onConfirm,
              child: Text(
                confirmText ?? "Yes",
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}
