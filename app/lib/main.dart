import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:hookshot_app/app.dart';
import 'package:hookshot_app/repositories/account_repository.dart';
import 'package:hookshot_app/repositories/feedback_repository.dart';
import 'package:hookshot_app/repositories/promoter_score_repository.dart';
import 'package:hookshot_client/hookshot_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _hookshotApiUrl = String.fromEnvironment(
  'HOOKSHOT_API_URL',
  defaultValue: 'http://localhost:8080/api',
);
const _hookshotStorageUrl = String.fromEnvironment(
  'HOOKSHOT_STORAGE_URL',
  defaultValue: 'http://localhost:8080/storage',
);

const _wiredashApiUrl = String.fromEnvironment(
  'WIREDASH_API_URL',
  defaultValue: 'http://localhost:8080/api/sdk',
);
const _wiredashProject = String.fromEnvironment(
  'WIREDASH_PROJECT',
  defaultValue: 'WIREDASH_PROJECT',
);
const _wiredashSecret = String.fromEnvironment(
  'WIREDASH_SECRET',
  defaultValue: 'WIREDASH_SECRET',
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  final hookshotClient = HookshotClient(_hookshotApiUrl, _hookshotStorageUrl);
  final preferences = await SharedPreferences.getInstance();
  final accountRepository = AccountRepository(hookshotClient, preferences);
  final feedbackRepository = FeedbackRepository(hookshotClient);
  final promoterScoreRepository = PromoterScoreRepository(hookshotClient);
  runApp(
    App(
      accountRepository: accountRepository,
      feedbackRepository: feedbackRepository,
      promoterScoreRepository: promoterScoreRepository,
      wiredashApiUrl: _wiredashApiUrl,
      wiredashProject: _wiredashProject,
      wiredashSecret: _wiredashSecret,
    ),
  );
}
