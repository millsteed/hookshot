import 'package:shelf/shelf.dart';

extension RequestSessionId on Request {
  String? get sessionId => headers['Authorization']?.replaceAll('Bearer ', '');
}
