import 'dart:convert';

import 'package:hookshot_protocol/hookshot_protocol.dart';
import 'package:hookshot_server/repositories/project_repository.dart';
import 'package:hookshot_server/repositories/promoter_score_repository.dart';
import 'package:hookshot_server/repositories/user_repository.dart';
import 'package:hookshot_server/utils/session.dart';
import 'package:shelf/shelf.dart';

class PromoterScoreController {
  PromoterScoreController(
    this.userRepository,
    this.projectRepository,
    this.promoterScoreRepository,
  );

  final UserRepository userRepository;
  final ProjectRepository projectRepository;
  final PromoterScoreRepository promoterScoreRepository;

  Future<Response> handleGetPromoterScores(
    Request request,
    String projectId,
  ) async {
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
    final promoterScores = await promoterScoreRepository.getPromoterScores(
      projectId: projectId,
    );
    final response = GetPromoterScoresResponse(promoterScores: promoterScores);
    return Response.ok(jsonEncode(response));
  }
}
