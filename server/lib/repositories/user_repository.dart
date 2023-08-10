import 'package:hookshot_protocol/hookshot_protocol.dart';
import 'package:hookshot_server/utils/password.dart';
import 'package:hookshot_server/utils/uuid.dart';
import 'package:postgres/postgres.dart';

class UserRepository {
  UserRepository(this.database);

  final PostgreSQLConnection database;

  Future<User?> getUserWithEmail({required String email}) async {
    print('UserRepository.getUserWithEmail()');
    final results = await database.mappedResultsQuery(
      'SELECT id, name FROM users WHERE email = @email AND deleted_at IS NULL',
      substitutionValues: {'email': email},
    );
    if (results.isEmpty) {
      return null;
    }
    final result = results.map((e) => e['users']!).single;
    final id = result['id'] as String;
    final name = result['name'] as String;
    return User(id: id, email: email, name: name);
  }

  Future<User> createUser({
    required String name,
    required String email,
    required String password,
  }) async {
    print('UserRepository.createUser()');
    final id = uuid.v4();
    final passwordHash = hashPassword(password);
    await _executeCreateUser(database, id, name, email, passwordHash);
    return User(id: id, name: name, email: email);
  }

  Future<void> _executeCreateUser(
    PostgreSQLExecutionContext database,
    String id,
    String name,
    String email,
    String passwordHash,
  ) async {
    final now = DateTime.now();
    await database.execute(
      'INSERT INTO users (id, created_at, updated_at, name, email, '
      'password_hash) '
      'VALUES (@id, @created_at, @updated_at, @name, @email, @password_hash)',
      substitutionValues: {
        'id': id,
        'created_at': now,
        'updated_at': now,
        'name': name,
        'email': email,
        'password_hash': passwordHash,
      },
    );
  }

  Future<bool> checkPassword({
    required String userId,
    required String password,
  }) async {
    print('UserRepository.checkPassword()');
    final results = await database.mappedResultsQuery(
      'SELECT password_hash FROM users WHERE id = @id AND deleted_at IS NULL',
      substitutionValues: {'id': userId},
    );
    if (results.isEmpty) {
      return false;
    }
    final result = results.map((e) => e['users']!).single;
    final hash = result['password_hash'] as String;
    return verifyPassword(password, hash);
  }

  Future<String> createSession({required String userId}) async {
    print('UserRepository.createSession()');
    final id = uuid.v4();
    await _executeCreateSession(database, id, userId);
    return id;
  }

  Future<void> _executeCreateSession(
    PostgreSQLExecutionContext database,
    String id,
    String userId,
  ) async {
    final now = DateTime.now();
    await database.execute(
      'INSERT INTO sessions (id, created_at, updated_at, user_id) '
      'VALUES (@id, @created_at, @updated_at, @user_id)',
      substitutionValues: {
        'id': id,
        'created_at': now,
        'updated_at': now,
        'user_id': userId,
      },
    );
  }
}
