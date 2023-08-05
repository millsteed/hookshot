import 'dart:convert';

import 'package:hookshot_server/repositories/promoter_score_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class PromoterScoresController {
  PromoterScoresController(this.promoterScoreRepository);

  final PromoterScoreRepository promoterScoreRepository;

  Router get router => Router()
    ..get('/', _handleGetAllPromoterScores)
    ..mount('/', (request) => Response.notFound(null));

  Future<Response> _handleGetAllPromoterScores(Request request) async {
    final promoterScores = await promoterScoreRepository.getPromoterScores();
    return Response.ok(jsonEncode(promoterScores));
  }
}
