import 'package:hookshot_client/hookshot_client.dart';

class PromoterScoreRepository {
  PromoterScoreRepository(this.hookshotClient);

  final HookshotClient hookshotClient;

  Future<GetPromoterScoresResponse> getPromoterScores({
    required String projectId,
  }) =>
      hookshotClient.getPromoterScores(projectId: projectId);
}
