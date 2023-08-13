import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hookshot_app/pages/app_shell/page.dart';
import 'package:hookshot_app/pages/create_project/page.dart';
import 'package:hookshot_app/pages/feedback/page.dart';
import 'package:hookshot_app/pages/projects/page.dart';
import 'package:hookshot_app/pages/promoter_score/page.dart';
import 'package:hookshot_app/pages/sign_in/page.dart';
import 'package:hookshot_app/pages/sign_up/page.dart';
import 'package:hookshot_app/repositories/account_repository.dart';
import 'package:wiredash/wiredash.dart';

enum Routes {
  home,
  signUp,
  signIn,
  projects,
  createProject,
  project,
  feedback,
  promoterScore,
}

final router = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) => Banner(
        message: 'ALPHA',
        location: BannerLocation.topEnd,
        child: child,
      ),
      routes: [
        GoRoute(
          name: Routes.home.name,
          path: '/',
          redirect: (context, state) =>
              state.namedLocation(Routes.projects.name),
        ),
        GoRoute(
          name: Routes.signUp.name,
          path: '/account/signup',
          builder: (context, state) => const SignUpPage(),
        ),
        GoRoute(
          name: Routes.signIn.name,
          path: '/account/signin',
          builder: (context, state) => const SignInPage(),
        ),
        ShellRoute(
          builder: (context, state, child) => AppShellPage(
            projectId: state.pathParameters['projectId'],
            child: child,
          ),
          routes: [
            GoRoute(
              name: Routes.projects.name,
              path: '/projects',
              builder: (context, state) => const ProjectsPage(),
              routes: [
                GoRoute(
                  name: Routes.createProject.name,
                  path: 'create',
                  builder: (context, state) => const CreateProjectPage(),
                ),
              ],
            ),
            GoRoute(
              name: Routes.project.name,
              path: '/projects/:projectId',
              redirect: (context, state) => state.namedLocation(
                Routes.feedback.name,
                pathParameters: {
                  'projectId': state.pathParameters['projectId']!,
                },
              ),
            ),
            GoRoute(
              name: Routes.feedback.name,
              path: '/projects/:projectId/feedback',
              builder: (context, state) => FeedbackPage(
                projectId: state.pathParameters['projectId']!,
              ),
            ),
            GoRoute(
              name: Routes.promoterScore.name,
              path: '/projects/:projectId/promoterscore',
              builder: (context, state) => PromoterScorePage(
                projectId: state.pathParameters['projectId']!,
              ),
            ),
          ],
        ),
      ],
    ),
  ],
  redirect: (context, state) {
    Future.delayed(Duration.zero, Wiredash.of(context).showPromoterSurvey);
    final isAuthenticated = context.read<AccountRepository>().isAuthenticated;
    final isGuestRoute = [Routes.signUp, Routes.signIn]
        .map((e) => e.name)
        .map(state.namedLocation)
        .contains(state.uri.path);
    if (isGuestRoute && isAuthenticated) {
      return state.namedLocation(Routes.home.name);
    } else if (!isGuestRoute && !isAuthenticated) {
      return state.namedLocation(Routes.signUp.name);
    }
    return null;
  },
);
