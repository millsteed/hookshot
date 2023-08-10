import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hookshot_app/pages/app_shell/page.dart';
import 'package:hookshot_app/pages/feedback/page.dart';
import 'package:hookshot_app/pages/promoter_score/page.dart';
import 'package:hookshot_app/pages/sign_in/page.dart';
import 'package:hookshot_app/pages/sign_up/page.dart';
import 'package:hookshot_app/repositories/account_repository.dart';
import 'package:wiredash/wiredash.dart';

enum Routes {
  home,
  signUp,
  signIn,
  feedback,
  promoterScore,
}

final router = GoRouter(
  routes: [
    GoRoute(
      name: Routes.signUp.name,
      path: '/signup',
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      name: Routes.signIn.name,
      path: '/signin',
      builder: (context, state) => const SignInPage(),
    ),
    ShellRoute(
      builder: (context, state, child) => AppShellPage(child: child),
      routes: [
        GoRoute(
          name: Routes.home.name,
          path: '/',
          redirect: (context, state) =>
              state.namedLocation(Routes.feedback.name),
        ),
        GoRoute(
          name: Routes.feedback.name,
          path: '/feedback',
          builder: (context, state) => const FeedbackPage(),
        ),
        GoRoute(
          name: Routes.promoterScore.name,
          path: '/promoterscore',
          builder: (context, state) => const PromoterScorePage(),
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
