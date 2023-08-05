import 'package:hookshot_protocol/hookshot_protocol.dart';
import 'package:http/http.dart';

class HookshotClient {
  HookshotClient(this.hookshotApiUrl, this.hookshotStorageUrl);

  final String hookshotApiUrl;
  final String hookshotStorageUrl;

  Future<List<Feedback>> getAllFeedback() async {
    final response = await get(Uri.parse('$hookshotApiUrl/feedback'));
    if (response.statusCode != 200) {
      throw HookshotClientException('Invalid response from server.');
    }
    return response.body.toJsonList().map(Feedback.fromJson).toList();
  }

  Future<List<PromoterScore>> getAllPromoterScores() async {
    final response = await get(Uri.parse('$hookshotApiUrl/promoterscores'));
    if (response.statusCode != 200) {
      throw HookshotClientException('Invalid response from server.');
    }
    return response.body.toJsonList().map(PromoterScore.fromJson).toList();
  }

  String getAttachmentUrl(Attachment attachment) {
    return '$hookshotStorageUrl/${attachment.id}/${attachment.name}';
  }
}

class HookshotClientException implements Exception {
  HookshotClientException(this.message);

  final String message;
}
