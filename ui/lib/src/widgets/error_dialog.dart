import 'package:flutter/widgets.dart';
import 'package:hookshot_ui/hookshot_ui.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({super.key, required this.message});

  final String message;

  static void show(BuildContext context, String message) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss error dialog',
      pageBuilder: (context, animation, secondaryAnimation) => ErrorDialog(
        message: message,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.medium),
      alignment: Alignment.center,
      child: _buildCard(context),
    );
  }

  Widget _buildCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Radius.medium),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(Spacing.large),
      child: _buildDetails(context),
    );
  }

  Widget _buildDetails(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(context),
        const SizedBox(height: Spacing.medium),
        _buildMessage(context),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return const Text(
      'Error',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: FontSize.large,
        color: Colors.black,
      ),
    );
  }

  Widget _buildMessage(BuildContext context) {
    return Text(
      message,
      style: const TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: FontSize.medium,
        color: Colors.black,
      ),
    );
  }
}
