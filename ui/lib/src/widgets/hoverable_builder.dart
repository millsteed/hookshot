import 'package:flutter/widgets.dart';

class HoverableBuilder extends StatefulWidget {
  const HoverableBuilder({super.key, required this.builder});

  // ignore: avoid_positional_boolean_parameters
  final Widget Function(BuildContext context, bool isHovered) builder;

  @override
  State<HoverableBuilder> createState() => _HoverableBuilderState();
}

class _HoverableBuilderState extends State<HoverableBuilder> {
  var _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (event) => setState(() => _isHovered = true),
      onExit: (event) => setState(() => _isHovered = false),
      child: widget.builder(context, _isHovered),
    );
  }
}
