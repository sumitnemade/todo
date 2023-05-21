import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../utils/sizes_helpers.dart';

class Background extends StatelessWidget {
  const Background({
    Key? key,
    this.children,
    this.padding,
    this.title,
    this.appBar,
    this.backgroundColor,
    this.floatingActionButtonOnTap,
    this.floatingActionButtonIcon,
    this.floatingActionButtonText,
    this.body,
    this.isStopScroll = false,
  }) : super(key: key);
  final List<Widget>? children;
  final EdgeInsetsGeometry? padding;
  final String? title;
  final PreferredSizeWidget? appBar;
  final Color? backgroundColor;
  final bool isStopScroll;
  final VoidCallback? floatingActionButtonOnTap;
  final IconData? floatingActionButtonIcon;
  final String? floatingActionButtonText;
  final Widget? body;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: Theme.of(context).platform == TargetPlatform.android,
      bottom: Theme.of(context).platform == TargetPlatform.android,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor ?? AppColors.background,
        appBar: appBar,
        body: body ??
            Builder(builder: (ctx) {
              return Padding(
                padding: padding ??
                    EdgeInsets.symmetric(
                        horizontal: displayWidth(context) * 0.1),
                child: ListView(
                  physics: isStopScroll
                      ? const NeverScrollableScrollPhysics()
                      : null,
                  children: children ?? [],
                ),
              );
            }),
        floatingActionButton: floatingActionButtonOnTap == null
            ? null
            : FloatingActionButton(
                onPressed: floatingActionButtonOnTap,
                clipBehavior: Clip.hardEdge,
                backgroundColor: AppColors.buttonBlue,
                hoverElevation: 8.0,
                focusElevation: 8.0,
                disabledElevation: 0.0,
                highlightElevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
                child: Icon(
                  floatingActionButtonIcon,
                ),
              ),
      ),
    );
  }
}
