import 'dart:convert';

import 'package:hookshot_protocol/hookshot_protocol.dart';
import 'package:hookshot_server/models/multipart.dart';
import 'package:hookshot_server/models/sdk_feedback.dart';
import 'package:hookshot_server/models/sdk_headers.dart';
import 'package:hookshot_server/models/sdk_promoter_score.dart';
import 'package:hookshot_server/repositories/feedback_repository.dart';
import 'package:hookshot_server/repositories/project_repository.dart';
import 'package:hookshot_server/repositories/promoter_score_repository.dart';
import 'package:hookshot_server/repositories/sdk_logs_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_multipart/form_data.dart';

class SdkController {
  SdkController(
    this.projectRepository,
    this.sdkLogsRepository,
    this.feedbackRepository,
    this.promoterScoreRepository,
  );

  final ProjectRepository projectRepository;
  final SdkLogsRepository sdkLogsRepository;
  final FeedbackRepository feedbackRepository;
  final PromoterScoreRepository promoterScoreRepository;

  Future<Response> handlePing(Request request) async {
    final headers = await _parseAndVerifyHeaders(request, 'ping');
    if (headers == null) {
      return Response.unauthorized(null);
    }
    return Response.ok(null);
  }

  Future<Response> handleUploadAttachment(Request request) async {
    final headers = await _parseAndVerifyHeaders(request, 'uploadAttachment');
    if (headers == null) {
      return Response.unauthorized(null);
    }
    if (!request.isMultipartForm) {
      return Response.badRequest();
    }
    final form = await request.toMultipartForm();
    final type = form.fields['type'];
    final files = form.files;
    if (type == null || type != 'screenshot' || files.length != 1) {
      return Response.badRequest();
    }
    final id = await feedbackRepository.createAttachment(type, files.first);
    return Response.ok(jsonEncode({'id': id}));
  }

  Future<Response> handleSendFeedback(Request request) async {
    final headers = await _parseAndVerifyHeaders(request, 'sendFeedback');
    if (headers == null) {
      return Response.unauthorized(null);
    }
    final body = await request.readAsString();
    final SdkFeedback feedback;
    try {
      feedback = SdkFeedback.fromJson(body.toJson());
    } on Exception {
      return Response.badRequest();
    }
    await feedbackRepository.createFeedback(headers.project, feedback);
    return Response.ok(null);
  }

  Future<Response> handleSendPromoterScore(Request request) async {
    final headers = await _parseAndVerifyHeaders(request, 'sendPromoterScore');
    if (headers == null) {
      return Response.unauthorized(null);
    }
    final body = await request.readAsString();
    final SdkPromoterScore promoterScore;
    try {
      promoterScore = SdkPromoterScore.fromJson(body.toJson());
    } on Exception {
      return Response.badRequest();
    }
    final lastWeek = DateTime.now().subtract(const Duration(days: 7));
    final promoterScores = await promoterScoreRepository.getPromoterScores(
      createdAfter: lastWeek,
      deviceId: promoterScore.deviceId,
    );
    if (promoterScores.isEmpty) {
      await promoterScoreRepository.createPromoterScore(
        headers.project,
        promoterScore,
      );
    } else {
      await promoterScoreRepository.updatePromoterScoreData(
        promoterScores.first.id,
        promoterScore,
      );
    }
    return Response.ok(null);
  }

  Future<SdkHeaders?> _parseAndVerifyHeaders(
    Request request,
    String type,
  ) async {
    final SdkHeaders headers;
    try {
      headers = SdkHeaders.fromJson(request.headers);
    } on Exception {
      return null;
    }
    final project = await projectRepository.getProject(id: headers.project);
    if (project == null || headers.secret != project.secret) {
      return null;
    }
    await sdkLogsRepository.createSdkLog(headers.project, headers.device, type);
    return headers;
  }
}
