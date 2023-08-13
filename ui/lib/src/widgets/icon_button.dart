import 'package:flutter/widgets.dart';
import 'package:hookshot_ui/hookshot_ui.dart';

class IconButton extends StatelessWidget {
  const IconButton({super.key, required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: HoverableBuilder(
        builder: (context, isHovered) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isHovered ? Colors.gray100 : Colors.gray50,
          ),
          padding: const EdgeInsets.all(Spacing.extraSmall),
          child: Icon(icon, color: Colors.black),
        ),
      ),
    );
  }
}
