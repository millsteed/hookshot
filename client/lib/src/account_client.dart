import 'dart:convert';

import 'package:hookshot_client/hookshot_client.dart';
import 'package:http/http.dart';

class AccountClient {
  AccountClient(this.apiUrl, this.client);

  final String apiUrl;
  final Client client;

  Future<SignUpResponse> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final request = SignUpRequest(name: name, email: email, password: password);
    final response = await client.post(
      Uri.parse('$apiUrl/signup'),
      body: jsonEncode(request),
    );
    if (response.statusCode != 200) {
      throw HookshotClientException(response.body);
    }
    return SignUpResponse.fromJson(response.body.toJson());
  }

  Future<SignInResponse> signIn({
    required String email,
    required String password,
  }) async {
    final request = SignInRequest(email: email, password: password);
    final response = await client.post(
      Uri.parse('$apiUrl/signin'),
      body: jsonEncode(request),
    );
    if (response.statusCode != 200) {
      throw HookshotClientException(response.body);
    }
    return SignInResponse.fromJson(response.body.toJson());
  }
}
