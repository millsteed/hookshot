import 'package:hookshot_protocol/hookshot_protocol.dart';
import 'package:hookshot_server/models/sdk_promoter_score.dart';
import 'package:hookshot_server/utils/uuid.dart';
import 'package:postgres/postgres.dart';

class PromoterScoreRepository {
  PromoterScoreRepository(this.database);

  final PostgreSQLConnection database;

  Future<List<PromoterScore>> getPromoterScores({
    String? projectId,
    DateTime? createdAfter,
    String? deviceId,
  }) async {
    final filter = [
      if (projectId != null) 'project_id = @project_id',
      if (createdAfter != null) 'created_at > @created_after',
      if (deviceId != null) "data ->> 'deviceId' = @device_id",
      'deleted_at IS NULL',
    ].join(' AND ');
    final results = await database.mappedResultsQuery(
      'SELECT id, data, project_id '
      'FROM promoter_scores '
      'WHERE $filter '
      'ORDER BY created_at DESC',
      substitutionValues: {
        'project_id': projectId,
        'created_after': createdAfter,
        'device_id': deviceId,
      },
    );
    return results.map((e) => e['promoter_scores']!).map(
      (e) {
        final id = e['id'] as String;
        final projectId = e['project_id'] as String;
        final data = e['data'] as Json;
        final promoterScore = SdkPromoterScore.fromJson(data);
        return PromoterScore(
          id: id,
          projectId: projectId,
          email: promoterScore.userEmail,
          question: promoterScore.question,
          message: promoterScore.message,
          score: promoterScore.score,
        );
      },
    ).toList();
  }

  Future<String> createPromoterScore(
    String projectId,
    SdkPromoterScore promoterScore,
  ) async {
    final id = uuid.v4();
    await _executeCreatePromoterScore(database, id, projectId, promoterScore);
    return id;
  }

  Future<void> _executeCreatePromoterScore(
    PostgreSQLExecutionContext database,
    String id,
    String projectId,
    SdkPromoterScore promoterScore,
  ) async {
    final now = DateTime.now();
    await database.execute(
      'INSERT INTO promoter_scores (id, created_at, updated_at, project_id, '
      'data) '
      'VALUES (@id, @created_at, @updated_at, @project_id, @data)',
      substitutionValues: {
        'id': id,
        'created_at': now,
        'updated_at': now,
        'project_id': projectId,
        'data': promoterScore.toJson(),
      },
    );
  }

  Future<void> updatePromoterScoreData(
    String id,
    SdkPromoterScore promoterScore,
  ) async {
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
