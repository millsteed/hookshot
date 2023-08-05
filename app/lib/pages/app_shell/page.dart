import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:hookshot_ui/hookshot_ui.dart';
import 'package:wiredash/wiredash.dart';

class AppShellPage extends StatelessWidget {
  const AppShellPage({super.key, required this.child});

  static const _links = ['Feedback', 'Promoter Score'];

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Column(
          children: [
            _buildHeader(context),
            Expanded(child: child),
          ],
        ),
        _buildFeedbackButton(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(Spacing.medium),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            'Hookshot',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: FontSize.large,
              color: Colors.white,
            ),
          ),
          for (final link in _links) ...[
            const SizedBox(width: Spacing.extraLarge),
            _buildLink(context, link),
          ],
        ],
      ),
    );
  }

  Widget _buildLink(BuildContext context, String link) {
    final router = GoRouterState.of(context);
    final selected = router.uri.path == router.namedLocation(link);
    return GestureDetector(
      onTap: () => context.goNamed(link),
      child: HoverableBuilder(
        builder: (context, isHovered) => Text(
          link,
          style: TextStyle(
            color: selected || isHovered ? Colors.white : Colors.gray500,
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Spacing.medium),
      child: IconButton(
        icon: Icons.waving_hand_outlined,
        onTap: Wiredash.of(context).show,
      ),
    );
  }
}
