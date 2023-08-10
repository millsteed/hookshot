import 'package:hookshot_client/hookshot_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountRepository {
  AccountRepository(this.hookshotClient, this.preferences) {
    hookshotClient.token = preferences.getString(_sessionTokenKey);
  }

  static const _sessionTokenKey = 'hookshot.session.token';

  final HookshotClient hookshotClient;
  final SharedPreferences preferences;

  bool get isAuthenticated => hookshotClient.token != null;

  Future<SignUpResponse> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await hookshotClient.account.signUp(
      name: name,
      email: email,
      password: password,
    );
    hookshotClient.token = response.sessionToken;
    await preferences.setString(_sessionTokenKey, response.sessionToken);
    return response;
  }

  Future<SignInResponse> signIn({
    required String email,
    required String password,
  }) async {
    final response = await hookshotClient.account.signIn(
      email: email,
      password: password,
    );
    hookshotClient.token = response.sessionToken;
    await preferences.setString(_sessionTokenKey, response.sessionToken);
    return response;
  }
}
