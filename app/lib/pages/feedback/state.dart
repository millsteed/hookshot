import 'package:hookshot_client/hookshot_client.dart';

sealed class FeedbackState {}

class FeedbackInitial extends FeedbackState {}

class FeedbackLoading extends FeedbackState {}

class FeedbackSuccess extends FeedbackState {
  FeedbackSuccess(this.feedback, this.attachmentUrls);

  final List<Feedback> feedback;
  final Map<Attachment, String> attachmentUrls;
}

class FeedbackFailure extends FeedbackState {
  FeedbackFailure(this.error);

  final String error;
}
