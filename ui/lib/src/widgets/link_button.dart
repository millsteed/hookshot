import 'package:flutter/widgets.dart';
import 'package:hookshot_ui/hookshot_ui.dart';

class LinkButton extends StatelessWidget {
  const LinkButton({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: HoverableBuilder(
        builder: (context, isHovered) => Container(
          padding: const EdgeInsets.all(8),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: FontSize.medium,
              color: Colors.black,
              decoration: isHovered ? TextDecoration.underline : null,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
