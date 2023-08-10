import 'package:flutter/widgets.dart';
import 'package:hookshot_ui/hookshot_ui.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: HoverableBuilder(
        builder: (context, isHovered) => Container(
          decoration: ShapeDecoration(
            shape: const StadiumBorder(),
            color: isHovered ? Colors.gray800 : Colors.black,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.large,
            vertical: Spacing.small,
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: FontSize.medium,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
