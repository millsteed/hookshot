import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hookshot_app/pages/feedback/event.dart';
import 'package:hookshot_app/pages/feedback/state.dart';
import 'package:hookshot_app/repositories/feedback_repository.dart';
import 'package:hookshot_client/hookshot_client.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  FeedbackBloc(this.feedbackRepository, this.projectId)
      : super(FeedbackInitial()) {
    on<FeedbackEvent>(
      (event, emit) => switch (event) {
        FeedbackStarted() => _handleStarted(event, emit),
      },
    );
  }

  final FeedbackRepository feedbackRepository;
  final String projectId;

  Future<void> _handleStarted(
    FeedbackStarted event,
    Emitter<FeedbackState> emit,
  ) async {
    emit(FeedbackLoading());
    try {
      final response = await feedbackRepository.getFeedback(
        projectId: projectId,
      );
      final feedback = response.feedback;
      final attachmentUrls = Map.fromEntries(
        feedback
            .map((feedback) => feedback.attachments)
            .whereType<List<Attachment>>()
            .expand((attachment) => attachment)
            .map(
              (attachment) => MapEntry(
                attachment,
                feedbackRepository.getAttachmentUrl(attachment),
              ),
            ),
      );
      if (feedback.isNotEmpty) {
        emit(FeedbackSuccess(feedback, attachmentUrls));
      } else {
        emit(FeedbackFailure('No feedback yet. Check back soon.'));
      }
    } on HookshotClientException catch (e) {
      emit(FeedbackFailure(e.message));
    } on Exception {
      emit(FeedbackFailure('Something unexpected happened.'));
    }
  }
}
