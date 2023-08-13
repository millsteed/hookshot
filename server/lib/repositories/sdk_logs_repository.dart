import 'package:hookshot_server/utils/uuid.dart';
import 'package:postgres/postgres.dart';

class SdkLogsRepository {
  SdkLogsRepository(this.database);

  final PostgreSQLConnection database;

  Future<String> createSdkLog(
    String projectId,
    String deviceId,
    String type,
  ) async {
    final id = uuid.v4();
    await _executeCreateSdkLog(database, id, projectId, deviceId, type);
    return id;
  }

  Future<void> _executeCreateSdkLog(
    PostgreSQLExecutionContext database,
    String id,
    String projectId,
    String deviceId,
    String type,
  ) async {
    final now = DateTime.now();
    await database.execute(
      'INSERT INTO sdk_logs (id, created_at, updated_at, project_id, '
      'device_id, type) '
      'VALUES (@id, @created_at, @updated_at, @project_id, @device_id, @type)',
      substitutionValues: {
        'id': id,
        'created_at': now,
        'updated_at': now,
        'project_id': projectId,
        'device_id': deviceId,
        'type': type,
      },
    );
  }
}
