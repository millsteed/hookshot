import 'package:hookshot_protocol/hookshot_protocol.dart';
import 'package:hookshot_server/models/sdk_promoter_score.dart';
import 'package:hookshot_server/utils/uuid.dart';
import 'package:postgres/postgres.dart';

class PromoterScoreRepository {
  PromoterScoreRepository(this.database);

  final PostgreSQLConnection database;

  Future<List<PromoterScore>> getPromoterScores({
    DateTime? createdAfter,
    String? deviceId,
  }) async {
    print('PromoterScoreRepository.getPromoterScores()');
    final filter = [
      if (createdAfter != null) 'created_at > @created_after',
      if (deviceId != null) "data ->> 'deviceId' = @device_id",
      'deleted_at IS NULL',
    ].join(' AND ');
    final results = await database.mappedResultsQuery(
      'SELECT id, data '
      'FROM promoter_scores '
      'WHERE $filter '
      'ORDER BY created_at DESC',
      substitutionValues: {
        'created_after': createdAfter,
        'device_id': deviceId,
      },
    );
    return results.map((e) => e['promoter_scores']!).map(
      (e) {
        final id = e['id'] as String;
        final data = e['data'] as Json;
        final promoterScore = SdkPromoterScore.fromJson(data);
        return PromoterScore(
          id: id,
          email: promoterScore.userEmail,
          question: promoterScore.question,
          message: promoterScore.message,
          score: promoterScore.score,
        );
      },
    ).toList();
  }

  Future<String> createPromoterScore(SdkPromoterScore promoterScore) async {
    print('PromoterScoreRepository.createPromoterScore()');
    final id = uuid.v4();
    await _executeCreatePromoterScore(database, id, promoterScore);
    return id;
  }

  Future<void> _executeCreatePromoterScore(
    PostgreSQLExecutionContext database,
    String id,
    SdkPromoterScore promoterScore,
  ) async {
    final now = DateTime.now();
    await database.execute(
      'INSERT INTO promoter_scores (id, created_at, updated_at, data) '
      'VALUES (@id, @created_at, @updated_at, @data)',
      substitutionValues: {
        'id': id,
        'created_at': now,
        'updated_at': now,
        'data': promoterScore.toJson(),
      },
    );
  }

  Future<void> updatePromoterScoreData(
    String id,
    SdkPromoterScore promoterScore,
  ) async {
    print('PromoterScoreRepository.updatePromoterScoreData()');
    await _executeUpdatePromoterScoreData(database, id, promoterScore);
  }

  Future<void> _executeUpdatePromoterScoreData(
    PostgreSQLExecutionContext database,
    String id,
    SdkPromoterScore promoterScore,
  ) async {
    final now = DateTime.now();
    await database.execute(
      'UPDATE promoter_scores '
      'SET updated_at = @updated_at, data = @data '
      'WHERE id = @id',
      substitutionValues: {
        'updated_at': now,
        'data': promoterScore.toJson(),
        'id': id,
      },
    );
  }
}
