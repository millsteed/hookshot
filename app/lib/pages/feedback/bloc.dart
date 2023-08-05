import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hookshot_app/pages/feedback/event.dart';
import 'package:hookshot_app/pages/feedback/state.dart';
import 'package:hookshot_client/hookshot_client.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  FeedbackBloc(this.hookshotClient) : super(FeedbackInitial()) {
    on<FeedbackEvent>(
      (event, emit) => switch (event) {
        FeedbackStarted() => _handleStarted(event, emit),
      },
    );
  }

  final HookshotClient hookshotClient;

  Future<void> _handleStarted(
    FeedbackStarted event,
    Emitter<FeedbackState> emit,
  ) async {
    emit(FeedbackLoading());
    try {
      final feedback = await hookshotClient.getAllFeedback();
      final attachmentUrls = Map.fromEntries(
        feedback
            .map((feedback) => feedback.attachments)
            .whereType<List<Attachment>>()
            .expand((attachment) => attachment)
            .map(
              (attachment) => MapEntry(
                attachment,
                hookshotClient.getAttachmentUrl(attachment),
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