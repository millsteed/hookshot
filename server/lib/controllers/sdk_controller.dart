import 'dart:convert';

import 'package:hookshot_protocol/hookshot_protocol.dart';
import 'package:hookshot_server/models/multipart.dart';
import 'package:hookshot_server/models/sdk_feedback.dart';
import 'package:hookshot_server/models/sdk_headers.dart';
import 'package:hookshot_server/models/sdk_promoter_score.dart';
import 'package:hookshot_server/repositories/feedback_repository.dart';
import 'package:hookshot_server/repositories/promoter_score_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_multipart/form_data.dart';
import 'package:shelf_router/shelf_router.dart';

class SdkController {
  SdkController(this.feedbackRepository, this.promoterScoreRepository);

  final FeedbackRepository feedbackRepository;
  final PromoterScoreRepository promoterScoreRepository;

  Router get router => Router()
    ..post('/ping', _handlePing)
    ..post('/uploadAttachment', _handleUploadAttachment)
    ..post('/sendFeedback', _handleSendFeedback)
    ..post('/sendPromoterScore', _handleSendPromoterScore)
    ..mount('/', (request) => Response.notFound(null));

  Future<Response> _handlePing(Request request) async {
    final SdkHeaders headers;
    try {
      headers = SdkHeaders.fromJson(request.headers);
    } on Exception {
      return Response.badRequest();
    }
    print(headers);
    return Response.ok(null);
  }

  Future<Response> _handleUploadAttachment(Request request) async {
    final SdkHeaders headers;
    try {
      headers = SdkHeaders.fromJson(request.headers);
    } on Exception {
      return Response.badRequest();
    }
    print(headers);
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

  Future<Response> _handleSendFeedback(Request request) async {
    final SdkHeaders headers;
    try {
      headers = SdkHeaders.fromJson(request.headers);
    } on Exception {
      return Response.badRequest();
    }
    print(headers);
    final body = await request.readAsString();
    final json = body.toJson();
    final SdkFeedback feedback;
    try {
      feedback = SdkFeedback.fromJson(json);
    } on Exception {
      return Response.badRequest();
    }
    print(feedback);
    await feedbackRepository.createFeedback(feedback);
    return Response.ok(null);
  }

  Future<Response> _handleSendPromoterScore(Request request) async {
    final SdkHeaders headers;
    try {
      headers = SdkHeaders.fromJson(request.headers);
    } on Exception {
      return Response.badRequest();
    }
    print(headers);
    final body = await request.readAsString();
    final json = body.toJson();
    final SdkPromoterScore promoterScore;
    try {
      promoterScore = SdkPromoterScore.fromJson(json);
    } on Exception {
      return Response.badRequest();
    }
    print(promoterScore);
    final lastWeek = DateTime.now().subtract(const Duration(days: 7));
    final promoterScores = await promoterScoreRepository.getPromoterScores(
      createdAfter: lastWeek,
      deviceId: promoterScore.deviceId,
    );
    if (promoterScores.isEmpty) {
      await promoterScoreRepository.createPromoterScore(promoterScore);
    } else {
      await promoterScoreRepository.updatePromoterScoreData(
        promoterScores.first.id,
        promoterScore,
      );
    }
    return Response.ok(null);
  }
}
