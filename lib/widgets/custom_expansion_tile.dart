import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../utils/sizes_helpers.dart';

class CustomExpansionWidget extends StatefulWidget {
  final Widget title;
  final Widget content;
  final bool isExpand;
  final Function(bool) onExpand;

  const CustomExpansionWidget({
    Key? key,
    required this.title,
    required this.content,
    required this.isExpand,
    required this.onExpand,
  }) : super(key: key);

  @override
  CustomExpansionWidgetState createState() => CustomExpansionWidgetState();
}

class CustomExpansionWidgetState extends State<CustomExpansionWidget> {
  bool isExpanded = false;

  @override
  void initState() {
    isExpanded = widget.isExpand;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CustomExpansionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    isExpanded = widget.isExpand;

    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
            widget.onExpand(isExpanded);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    height: 50,
                    width: displayWidth(context) * 0.80,
                    child: widget.title),
                Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: AppColors.accent,
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 100),
          crossFadeState:
              isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          firstChild: const SizedBox.shrink(),
          secondChild: widget.content,
        ),
      ],
    );
  }
}
