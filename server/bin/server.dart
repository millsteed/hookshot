import 'dart:io';

import 'package:hookshot_server/controllers/account_controller.dart';
import 'package:hookshot_server/controllers/feedback_controller.dart';
import 'package:hookshot_server/controllers/promoter_score_controller.dart';
import 'package:hookshot_server/controllers/sdk_controller.dart';
import 'package:hookshot_server/repositories/feedback_repository.dart';
import 'package:hookshot_server/repositories/promoter_score_repository.dart';
import 'package:hookshot_server/repositories/user_repository.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_hotreload/shelf_hotreload.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';

const _databaseHost = String.fromEnvironment(
  'DATABASE_HOST',
  defaultValue: 'localhost',
);
const _databasePort = int.fromEnvironment(
  'DATABASE_PORT',
  defaultValue: 5432,
);
const _databaseUser = String.fromEnvironment(
  'DATABASE_USER',
  defaultValue: 'postgres',
);
const _databasePass = String.fromEnvironment(
  'DATABASE_PASS',
  defaultValue: 'postgres',
);
const _databaseName = String.fromEnvironment(
  'DATABASE_NAME',
  defaultValue: 'postgres',
);

const _storagePath = String.fromEnvironment(
  'STORAGE_PATH',
  defaultValue: '../storage',
);
const _webPath = String.fromEnvironment(
  'WEB_PATH',
  defaultValue: '../app/build/web',
);

bool get _isDebugMode {
  var isDebugMode = false;
  assert(isDebugMode = true, 'Asserts are only evaluated in debug mode.');
  return isDebugMode;
}

Future<void> main() async {
  final database = PostgreSQLConnection(
    _databaseHost,
    _databasePort,
    _databaseName,
    username: _databaseUser,
    password: _databasePass,
  );
  await database.open();
  Directory(_storagePath).createSync();
  _isDebugMode
      ? withHotreload(() => _buildServer(database))
      : _buildServer(database);
}

Future<HttpServer> _buildServer(PostgreSQLConnection database) async {
  final pipeline = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsHeaders(headers: {ACCESS_CONTROL_ALLOW_HEADERS: '*'}));
  final userRepository = UserRepository(database);
  final feedbackRepository = FeedbackRepository(database, _storagePath);
  final promoterScoreRepository = PromoterScoreRepository(database);
  final sdkController = SdkController(
    feedbackRepository,
    promoterScoreRepository,
  );
  final accountController = AccountController(userRepository);
  final feedbackController = FeedbackController(feedbackRepository);
  final promoterScoreController = PromoterScoreController(
    promoterScoreRepository,
  );
  final apiRouter = Router()
    ..mount('/sdk', sdkController.router.call)
    ..mount('/account', accountController.router.call)
    ..mount('/feedback', feedbackController.router.call)
    ..mount('/promoterscores', promoterScoreController.router.call);
  final router = Router()
    ..mount('/api', apiRouter.call)
    ..mount('/storage', createStaticHandler(_storagePath))
    ..get(r'/<file|.*\..*>', createStaticHandler(_webPath))
    ..mount('/', _handleIndexRewrite);
  final handler = pipeline.addHandler(router.call);
  final server = await serve(handler, InternetAddress.anyIPv4, 8080);
  print('listening on port ${server.port}');
  return server;
}

Future<Response> _handleIndexRewrite(Request request) async =>
    createFileHandler('$_webPath/index.html', url: request.url.path)(request);
