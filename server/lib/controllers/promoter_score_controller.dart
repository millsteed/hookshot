import 'dart:convert';

import 'package:hookshot_protocol/hookshot_protocol.dart';
import 'package:hookshot_server/repositories/promoter_score_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class PromoterScoreController {
  PromoterScoreController(this.promoterScoreRepository);

  final PromoterScoreRepository promoterScoreRepository;

  Router get router => Router()
    ..get('/', _handleGetPromoterScores)
    ..mount('/', (request) => Response.notFound(null));

  Future<Response> _handleGetPromoterScores(Request request) async {
    final promoterScores = await promoterScoreRepository.getPromoterScores();
    final response = GetPromoterScoresResponse(promoterScores: promoterScores);
    return Response.ok(jsonEncode(response));
  }
}
