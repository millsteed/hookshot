import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hookshot_app/pages/feedback/bloc.dart';
import 'package:hookshot_app/pages/feedback/event.dart';
import 'package:hookshot_app/pages/feedback/state.dart';
import 'package:hookshot_client/hookshot_client.dart';
import 'package:hookshot_ui/hookshot_ui.dart';
import 'package:url_launcher/url_launcher_string.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    final hookshotClient = context.read<HookshotClient>();
    return BlocProvider(
      create: (context) => FeedbackBloc(hookshotClient)..add(FeedbackStarted()),
      child: const FeedbackView(),
    );
  }
}

class FeedbackView extends StatelessWidget {
  const FeedbackView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedbackBloc, FeedbackState>(
      builder: (context, state) => switch (state) {
        FeedbackInitial() => _buildInitial(context, state),
        FeedbackLoading() => _buildLoading(context, state),
        FeedbackSuccess() => _buildSuccess(context, state),
        FeedbackFailure() => _buildFailure(context, state),
      },
    );
  }

  Widget _buildInitial(BuildContext context, FeedbackInitial state) {
    return const SizedBox();
  }

  Widget _buildLoading(BuildContext context, FeedbackLoading state) {
    return const Center(child: Text('Loading'));
  }

  Widget _buildSuccess(BuildContext context, FeedbackSuccess state) {
    final feedback = state.feedback;
    final attachmentUrls = state.attachmentUrls;
    return ListView.separated(
      itemBuilder: (context, index) => _buildFeedback(
        context,
        feedback[index],
        attachmentUrls,
      ),
      separatorBuilder: (context, index) => Container(
        height: 1,
        color: Colors.gray50,
      ),
      itemCount: feedback.length,
    );
  }

  Widget _buildFeedback(
    BuildContext context,
    Feedback feedback,
    Map<Attachment, String> attachmentUrls,
  ) {
    final email = feedback.email;
    final message = feedback.message;
    final attachments = feedback.attachments;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1024),
        child: IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.all(Spacing.medium),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildEmailAndMessage(context, email, message)),
                if (attachments != null) ...[
                  _buildAttachments(context, attachments, attachmentUrls),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailAndMessage(
    BuildContext context,
    String? email,
    String message,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          email ?? 'Anonymous',
          style: TextStyle(
            color: Colors.gray500,
            fontStyle: email == null ? FontStyle.italic : null,
          ),
        ),
        const SizedBox(height: Spacing.small),
        Text(message),
      ],
    );
  }

  Widget _buildAttachments(
    BuildContext context,
    List<Attachment> attachments,
    Map<Attachment, String> attachmentUrls,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            for (final attachment in attachments) ...[
              const SizedBox(width: Spacing.medium),
              _buildAttachment(context, attachmentUrls[attachment]!),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildAttachment(BuildContext context, String url) {
    return GestureDetector(
      onTap: () => launchUrlString(url),
      child: HoverableBuilder(
        builder: (context, isHovered) => Stack(
          alignment: Alignment.center,
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 96, maxHeight: 80),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isHovered ? Colors.black : Colors.gray50,
                ),
              ),
              child: Image.network(url),
            ),
            if (isHovered) ...[
              const Icon(
                Icons.download,
                color: Colors.white,
                shadows: [BoxShadow(blurRadius: Radius.medium)],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFailure(BuildContext context, FeedbackFailure state) {
    return Center(child: Text(state.error));
  }
}
