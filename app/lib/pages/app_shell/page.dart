import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:hookshot_app/router.dart';
import 'package:hookshot_ui/hookshot_ui.dart';
import 'package:wiredash/wiredash.dart';

class AppShellPage extends StatelessWidget {
  const AppShellPage({super.key, required this.projectId, required this.child});

  static const _links = {
    'Feedback': Routes.feedback,
    'Promoter Score': Routes.promoterScore,
  };

  final String? projectId;
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
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: Sizes.maxWidth),
        child: Row(
          children: [
            const HookshotLogo.small(color: Colors.white),
            if (projectId != null) ...[
              for (final link in _links.entries) ...[
                const SizedBox(width: Spacing.extraLarge),
                _buildLink(context, link.key, link.value.name),
              ],
              const Spacer(),
              GestureDetector(
                onTap: () => context.goNamed(Routes.projects.name),
                child: HoverableBuilder(
                  builder: (context, isHovered) => Text(
                    'My Projects',
                    style: TextStyle(
                      color: isHovered ? Colors.white : Colors.gray500,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLink(BuildContext context, String label, String routeName) {
    final router = GoRouterState.of(context);
    final projectId = this.projectId;
    final parameters = {if (projectId != null) 'projectId': projectId};
    final path = router.namedLocation(routeName, pathParameters: parameters);
    final selected = router.uri.path == path;
    return GestureDetector(
      onTap: () => context.goNamed(routeName, pathParameters: parameters),
      child: HoverableBuilder(
        builder: (context, isHovered) => Text(
          label,
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
      child: PrimaryIconButton(
        icon: Icons.waving_hand_outlined,
        onTap: Wiredash.of(context).show,
      ),
    );
  }
}
