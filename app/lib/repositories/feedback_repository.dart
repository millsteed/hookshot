import 'package:hookshot_client/hookshot_client.dart';

class FeedbackRepository {
  FeedbackRepository(this.hookshotClient);

  final HookshotClient hookshotClient;

  Future<GetFeedbackResponse> getFeedback() =>
      hookshotClient.feedback.getFeedback();

  String getAttachmentUrl(Attachment attachment) =>
      hookshotClient.feedback.getAttachmentUrl(attachment);
}
