import 'dart:async';

import 'package:go_router/go_router.dart';
import 'package:hookshot_app/pages/app_shell/page.dart';
import 'package:hookshot_app/pages/feedback/page.dart';
import 'package:hookshot_app/pages/promoter_score/page.dart';
import 'package:wiredash/wiredash.dart';

final router = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShellPage(child: child),
      routes: [
        GoRoute(
          name: 'Home',
          path: '/',
          redirect: (context, state) => state.namedLocation('Feedback'),
        ),
        GoRoute(
          name: 'Feedback',
          path: '/feedback',
          builder: (context, state) => const FeedbackPage(),
        ),
        GoRoute(
          name: 'Promoter Score',
          path: '/promoterscore',
          builder: (context, state) => const PromoterScorePage(),
        ),
      ],
    ),
  ],
  redirect: (context, state) {
    Future.delayed(Duration.zero, Wiredash.of(context).showPromoterSurvey);
    return null;
  },
);
