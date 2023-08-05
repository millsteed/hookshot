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
            color: isHovered ? Colors.gray800 : Colors.black,
          ),
          padding: const EdgeInsets.all(Spacing.medium),
          child: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}
