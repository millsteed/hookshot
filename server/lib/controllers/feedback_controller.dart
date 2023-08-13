import 'dart:convert';

import 'package:hookshot_protocol/hookshot_protocol.dart';
import 'package:hookshot_server/repositories/feedback_repository.dart';
import 'package:hookshot_server/repositories/project_repository.dart';
import 'package:hookshot_server/repositories/user_repository.dart';
import 'package:hookshot_server/utils/session.dart';
import 'package:shelf/shelf.dart';

class FeedbackController {
  FeedbackController(
    this.userRepository,
    this.projectRepository,
    this.feedbackRepository,
  );

  final UserRepository userRepository;
  final ProjectRepository projectRepository;
  final FeedbackRepository feedbackRepository;

  Future<Response> handleGetFeedback(Request request, String projectId) async {
    final sessionId = request.sessionId;
    if (sessionId == null) {
      return Response.unauthorized(null);
    }
    final userId = await userRepository.getSessionUserId(sessionId: sessionId);
    if (userId == null) {
      return Response.unauthorized(null);
    }
    final project = await projectRepository.getProject(
      id: projectId,
      userId: userId,
    );
    if (project == null) {
      return Response.notFound(null);
    }
    final feedback = await feedbackRepository.getFeedback(projectId: projectId);
    final response = GetFeedbackResponse(feedback: feedback);
    return Response.ok(jsonEncode(response));
  }
}
