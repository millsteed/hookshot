import 'dart:convert';

import 'package:hookshot_protocol/hookshot_protocol.dart';
import 'package:hookshot_server/repositories/project_repository.dart';
import 'package:hookshot_server/repositories/user_repository.dart';
import 'package:hookshot_server/utils/session.dart';
import 'package:shelf/shelf.dart';

class ProjectController {
  ProjectController(this.userRepository, this.projectRepository);

  final UserRepository userRepository;
  final ProjectRepository projectRepository;

  Future<Response> handleGetProjects(Request request) async {
    final sessionId = request.sessionId;
    if (sessionId == null) {
      return Response.unauthorized(null);
    }
    final userId = await userRepository.getSessionUserId(sessionId: sessionId);
    if (userId == null) {
      return Response.unauthorized(null);
    }
    final projects = await projectRepository.getProjects(userId: userId);
    final response = GetProjectsResponse(projects: projects);
    return Response.ok(jsonEncode(response));
  }

  Future<Response> handleCreateProject(Request request) async {
    final sessionId = request.sessionId;
    if (sessionId == null) {
      return Response.unauthorized(null);
    }
    final userId = await userRepository.getSessionUserId(sessionId: sessionId);
    if (userId == null) {
      return Response.unauthorized(null);
    }
    final body = await request.readAsString();
    final CreateProjectRequest data;
    try {
      data = CreateProjectRequest.fromJson(body.toJson());
    } on Exception {
      return Response.badRequest(body: 'Failed to parse request body.');
    }
    if (data.name.isEmpty) {
      return Response.badRequest(body: 'Name cannot be empty.');
    }
    final projectId = await projectRepository.createProject(
      name: data.name,
      userId: userId,
    );
    final response = CreateProjectResponse(projectId: projectId);
    return Response.ok(jsonEncode(response));
  }
}
