import 'package:hookshot_client/hookshot_client.dart';
import 'package:http/http.dart';

class PromoterScoreClient {
  PromoterScoreClient(this.apiUrl, this.client);

  final String apiUrl;
  final Client client;

  Future<GetPromoterScoresResponse> getPromoterScores() async {
    final response = await client.get(Uri.parse('$apiUrl/promoterscores'));
    if (response.statusCode != 200) {
      throw HookshotClientException(response.body);
    }
    return GetPromoterScoresResponse.fromJson(response.body.toJson());
  }
}
