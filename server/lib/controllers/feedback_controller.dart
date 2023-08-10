import 'dart:convert';

import 'package:hookshot_protocol/hookshot_protocol.dart';
import 'package:hookshot_server/repositories/feedback_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class FeedbackController {
  FeedbackController(this.feedbackRepository);

  final FeedbackRepository feedbackRepository;

  Router get router => Router()
    ..get('/', _handleGetFeedback)
    ..mount('/', (request) => Response.notFound(null));

  Future<Response> _handleGetFeedback(Request request) async {
    final feedback = await feedbackRepository.getFeedback();
    final response = GetFeedbackResponse(feedback: feedback);
    return Response.ok(jsonEncode(response));
  }
}
