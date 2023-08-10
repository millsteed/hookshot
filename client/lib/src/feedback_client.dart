import 'package:hookshot_client/hookshot_client.dart';
import 'package:http/http.dart';

class FeedbackClient {
  FeedbackClient(this.apiUrl, this.storageUrl, this.client);

  final String apiUrl;
  final String storageUrl;
  final Client client;

  Future<GetFeedbackResponse> getFeedback() async {
    final response = await client.get(Uri.parse('$apiUrl/'));
    if (response.statusCode != 200) {
      throw HookshotClientException(response.body);
    }
    return GetFeedbackResponse.fromJson(response.body.toJson());
  }

  String getAttachmentUrl(Attachment attachment) {
    return '$storageUrl/${attachment.id}/${attachment.name}';
  }
}
