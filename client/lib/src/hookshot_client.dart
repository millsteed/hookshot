import 'dart:convert';

import 'package:hookshot_client/hookshot_client.dart';
import 'package:http/http.dart';

class HookshotClient {
  HookshotClient(this.apiUrl, this.storageUrl);

  final String apiUrl;
  final String storageUrl;

  final _client = HookshotHttpClient();

  String? get token => _client.token;

  set token(String? token) => _client.token = token;

  Future<SignUpResponse> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final request = SignUpRequest(name: name, email: email, password: password);
    final response = await _client.post(
      Uri.parse('$apiUrl/account/signup'),
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
    final response = await _client.post(
      Uri.parse('$apiUrl/account/signin'),
      body: jsonEncode(request),
    );
    if (response.statusCode != 200) {
      throw HookshotClientException(response.body);
    }
    return SignInResponse.fromJson(response.body.toJson());
  }

  Future<GetProjectsResponse> getProjects() async {
    final response = await _client.get(
      Uri.parse('$apiUrl/projects'),
    );
    if (response.statusCode != 200) {
      throw HookshotClientException(response.body);
    }
    return GetProjectsResponse.fromJson(response.body.toJson());
  }

  Future<CreateProjectResponse> createProject({required String name}) async {
    final request = CreateProjectRequest(name: name);
    final response = await _client.post(
      Uri.parse('$apiUrl/projects'),
      body: jsonEncode(request),
    );
    if (response.statusCode != 200) {
      throw HookshotClientException(response.body);
    }
    return CreateProjectResponse.fromJson(response.body.toJson());
  }

  Future<GetFeedbackResponse> getFeedback({required String projectId}) async {
    final response = await _client.get(
      Uri.parse('$apiUrl/projects/$projectId/feedback'),
    );
    if (response.statusCode != 200) {
      throw HookshotClientException(response.body);
    }
    return GetFeedbackResponse.fromJson(response.body.toJson());
  }

  Future<GetPromoterScoresResponse> getPromoterScores({
    required String projectId,
  }) async {
    final response = await _client.get(
      Uri.parse('$apiUrl/projects/$projectId/promoterscores'),
    );
    if (response.statusCode != 200) {
      throw HookshotClientException(response.body);
    }
    return GetPromoterScoresResponse.fromJson(response.body.toJson());
  }

  String getAttachmentUrl(Attachment attachment) {
    return '$storageUrl/${attachment.id}/${attachment.name}';
  }
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
