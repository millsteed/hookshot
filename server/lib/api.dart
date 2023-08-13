import 'package:hookshot_server/controllers/account_controller.dart';
import 'package:hookshot_server/controllers/feedback_controller.dart';
import 'package:hookshot_server/controllers/project_controller.dart';
import 'package:hookshot_server/controllers/promoter_score_controller.dart';
import 'package:hookshot_server/controllers/sdk_controller.dart';
import 'package:hookshot_server/repositories/feedback_repository.dart';
import 'package:hookshot_server/repositories/project_repository.dart';
import 'package:hookshot_server/repositories/promoter_score_repository.dart';
import 'package:hookshot_server/repositories/sdk_logs_repository.dart';
import 'package:hookshot_server/repositories/user_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class Api {
  Api(
    UserRepository userRepository,
    ProjectRepository projectRepository,
    SdkLogsRepository sdkLogsRepository,
    FeedbackRepository feedbackRepository,
    PromoterScoreRepository promoterScoreRepository,
  )   : _accountController = AccountController(userRepository),
        _projectController = ProjectController(
          userRepository,
          projectRepository,
        ),
        _feedbackController = FeedbackController(
          userRepository,
          projectRepository,
          feedbackRepository,
        ),
        _promoterScoreController = PromoterScoreController(
          userRepository,
          projectRepository,
          promoterScoreRepository,
        ),
        _sdkController = SdkController(
          projectRepository,
          sdkLogsRepository,
          feedbackRepository,
          promoterScoreRepository,
        );

  final AccountController _accountController;
  final ProjectController _projectController;
  final FeedbackController _feedbackController;
  final PromoterScoreController _promoterScoreController;
  final SdkController _sdkController;

  Router get router => Router()
    ..post('/account/signup', _accountController.handleSignUp)
    ..post('/account/signin', _accountController.handleSignIn)
    ..get('/projects', _projectController.handleGetProjects)
    ..post('/projects', _projectController.handleCreateProject)
    ..get(
      '/projects/<projectId>/feedback',
      _feedbackController.handleGetFeedback,
    )
    ..get(
      '/projects/<projectId>/promoterscores',
      _promoterScoreController.handleGetPromoterScores,
    )
    ..post('/sdk/ping', _sdkController.handlePing)
    ..post('/sdk/uploadAttachment', _sdkController.handleUploadAttachment)
    ..post('/sdk/sendFeedback', _sdkController.handleSendFeedback)
    ..post('/sdk/sendPromoterScore', _sdkController.handleSendPromoterScore)
    ..mount('/', (request) => Response.notFound(null));
}
