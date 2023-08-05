import 'dart:convert';

import 'package:hookshot_server/repositories/feedback_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class FeedbackController {
  FeedbackController(this.feedbackRepository);

  final FeedbackRepository feedbackRepository;

  Router get router => Router()
    ..get('/', _handleGetAllFeedback)
    ..mount('/', (request) => Response.notFound(null));

  Future<Response> _handleGetAllFeedback(Request request) async {
    final feedback = await feedbackRepository.getFeedback();
    return Response.ok(jsonEncode(feedback));
  }
}
