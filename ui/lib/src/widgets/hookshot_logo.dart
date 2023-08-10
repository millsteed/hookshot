import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';
import 'package:hookshot_ui/hookshot_ui.dart';

class HookshotLogo extends StatelessWidget {
  const HookshotLogo.small({super.key, this.color = Colors.black})
      : size = IconSize.small;
  const HookshotLogo.medium({super.key, this.color = Colors.black})
      : size = IconSize.medium;

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.switch_access_shortcut,
          size: size,
          color: color,
        ),
        Text(
          'Hookshot',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: size,
            color: color,
          ),
        ),
      ],
    );
  }
}
