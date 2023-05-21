import 'package:flutter/material.dart';

class FlexAppBarTitle extends StatefulWidget {
  final Widget child;
  final bool isTitle;

  const FlexAppBarTitle({
    Key? key,
    required this.child,
    this.isTitle = true,
  }) : super(key: key);

  @override
  FlexAppBarTitleState createState() {
    return FlexAppBarTitleState();
  }
}

class FlexAppBarTitleState extends State<FlexAppBarTitle> {
  ScrollPosition? _position;
  bool? _visible;

  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _removeListener();
    _addListener();
  }

  void _addListener() {
    _position = Scrollable.of(context).position;
    _position?.addListener(_positionListener);
    _positionListener();
  }

  void _removeListener() {
    _position?.removeListener(_positionListener);
  }

  void _positionListener() {
    final FlexibleSpaceBarSettings? settings =
        context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
    bool visible = settings!.currentExtent <= settings.minExtent;
    if (_visible != visible) {
      setState(() {
        _visible = visible;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: (widget.isTitle && _visible!) || (!widget.isTitle && !_visible!),
      child: widget.child,
    );
  }
}
