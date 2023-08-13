import 'package:hookshot_protocol/hookshot_protocol.dart';
import 'package:hookshot_server/utils/uuid.dart';
import 'package:postgres/postgres.dart';

class ProjectRepository {
  ProjectRepository(this.database);

  final PostgreSQLConnection database;

  Future<List<Project>> getProjects({String? userId}) async {
    final filter = [
      'user_id = @user_id',
      'projects.deleted_at IS NULL',
    ].join(' AND ');
    final results = await database.mappedResultsQuery(
      'SELECT id, name, secret '
      'FROM projects '
      'LEFT JOIN members ON project_id = id '
      'WHERE $filter '
      'ORDER BY projects.created_at DESC',
      substitutionValues: {'user_id': userId},
    );
    return results.map((e) => e['projects']!).map(
      (e) {
        final id = e['id'] as String;
        final name = e['name'] as String;
        final secret = e['secret'] as String;
        return Project(id: id, name: name, secret: secret);
      },
    ).toList();
  }

  Future<Project?> getProject({required String id, String? userId}) async {
    final filter = [
      'id = @id',
      if (userId != null) 'user_id = @user_id',
      'projects.deleted_at IS NULL',
    ].join(' AND ');
    final results = await database.mappedResultsQuery(
      'SELECT name, secret '
      'FROM projects '
      'LEFT JOIN members ON project_id = id '
      'WHERE $filter ',
      substitutionValues: {'id': id, 'user_id': userId},
    );
    if (results.isEmpty) {
      return null;
    }
    final result = results.map((e) => e['projects']!).single;
    final name = result['name'] as String;
    final secret = result['secret'] as String;
    return Project(id: id, name: name, secret: secret);
  }

  Future<String> createProject({
    required String name,
    required String userId,
  }) async {
    final id = uuid.v4();
    final secret = uuid.v4().replaceAll('-', '');
    await database.transaction((database) async {
      await _executeCreateProject(database, id, name, secret);
      await _executeCreateMember(database, id, userId);
    });
    return id;
  }

  Future<void> _executeCreateProject(
    PostgreSQLExecutionContext database,
    String id,
    String name,
    String secret,
  ) async {
    final now = DateTime.now();
    await database.execute(
      'INSERT INTO projects (id, created_at, updated_at, name, secret) '
      'VALUES (@id, @created_at, @updated_at, @name, @secret)',
      substitutionValues: {
        'id': id,
        'created_at': now,
        'updated_at': now,
        'name': name,
        'secret': secret,
      },
    );
  }

  Future<void> _executeCreateMember(
    PostgreSQLExecutionContext database,
    String projectId,
    String userId,
  ) async {
    final now = DateTime.now();
    await database.execute(
      'INSERT INTO members (project_id, user_id, created_at, updated_at) '
      'VALUES (@project_id, @user_id, @created_at, @updated_at)',
      substitutionValues: {
        'project_id': projectId,
        'user_id': userId,
        'created_at': now,
        'updated_at': now,
      },
    );
  }
}
