import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../utils/sizes_helpers.dart';

class Background extends StatelessWidget {
  const Background({
    Key? key,
    required this.children,
    this.padding,
    this.title,
    this.appBar,
    this.backgroundColor,
    this.floatingActionButtonOnTap,
    this.floatingActionButtonIcon,
    this.floatingActionButtonText,
    this.isStopScroll = false,
  }) : super(key: key);
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final String? title;
  final PreferredSizeWidget? appBar;
  final Color? backgroundColor;
  final bool isStopScroll;
  final VoidCallback? floatingActionButtonOnTap;
  final IconData? floatingActionButtonIcon;
  final String? floatingActionButtonText;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: Theme.of(context).platform == TargetPlatform.android,
      bottom: Theme.of(context).platform == TargetPlatform.android,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor ?? AppColors.white,
        appBar: appBar,
        body: Builder(builder: (ctx) {
          return Padding(
            padding: padding ??
                EdgeInsets.symmetric(horizontal: displayWidth(context) * 0.1),
            child: ListView(
              physics:
                  isStopScroll ? const NeverScrollableScrollPhysics() : null,
              children: children,
            ),
          );
        }),
        floatingActionButton: floatingActionButtonOnTap == null
            ? null
            : FloatingActionButton.extended(
                onPressed: floatingActionButtonOnTap,
                clipBehavior: Clip.hardEdge,
                label: Text(
                  floatingActionButtonText!,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w900),
                ),
                backgroundColor: AppColors.accent,
                elevation: 0.0,
                hoverElevation: 8.0,
                focusElevation: 8.0,
                disabledElevation: 0.0,
                highlightElevation: 8.0,
                extendedPadding: const EdgeInsets.symmetric(horizontal: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
      ),
    );
  }
}
