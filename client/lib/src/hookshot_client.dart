import 'package:hookshot_client/src/account_client.dart';
import 'package:hookshot_client/src/feedback_client.dart';
import 'package:hookshot_client/src/promoter_score_client.dart';
import 'package:http/http.dart';

class HookshotClient {
  HookshotClient(this.hookshotApiUrl, this.hookshotStorageUrl);

  final String hookshotApiUrl;
  final String hookshotStorageUrl;

  final _client = HookshotHttpClient();

  late final AccountClient account = AccountClient(
    '$hookshotApiUrl/account',
    _client,
  );

  late final FeedbackClient feedback = FeedbackClient(
    '$hookshotApiUrl/feedback',
    hookshotStorageUrl,
    _client,
  );

  late final PromoterScoreClient promoterScore = PromoterScoreClient(
    '$hookshotApiUrl/promoterscores',
    _client,
  );

  String? get token => _client.token;

  set token(String? token) => _client.token = token;
}

class HookshotHttpClient extends BaseClient {
  String? token;

  final _client = Client();

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    return _client.send(request);
  }

  @override
  void close() => _client.close();
}

class HookshotClientException implements Exception {
  HookshotClientException(this.message);

  final String message;
}
