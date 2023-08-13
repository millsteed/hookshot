import 'package:hookshot_client/hookshot_client.dart';

class FeedbackRepository {
  FeedbackRepository(this.hookshotClient);

  final HookshotClient hookshotClient;

  Future<GetFeedbackResponse> getFeedback({required String projectId}) =>
      hookshotClient.getFeedback(projectId: projectId);

  String getAttachmentUrl(Attachment attachment) =>
      hookshotClient.getAttachmentUrl(attachment);
}
