import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/auth_page.dart';
import '../../features/daily_summary/presentation/pages/daily_summary_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/focus_mode/presentation/pages/focus_mode_page.dart';
import '../../features/planner/presentation/pages/planner_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/statistics/presentation/pages/statistics_page.dart';
import '../../features/today/presentation/pages/today_page.dart';
import '../shell/main_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    // ── Full-screen routes (outside the shell) ──────────────────────────
    GoRoute(
      path: '/',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/auth',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AuthPage(),
    ),
    GoRoute(
      path: '/today',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const TodayPage(),
    ),
    GoRoute(
      path: '/focus-mode',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>?;
        final missionId = extras?['missionId'] as String? ?? '';
        return FocusModePage(missionId: missionId);
      },
    ),
    GoRoute(
      path: '/daily-summary',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const DailySummaryPage(),
    ),

    // ── Shell routes (bottom navigation) ───────────────────────────────
    StatefulShellRoute.indexedStack(
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state, navigationShell) =>
          MainShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorKey,
          routes: [
            GoRoute(
              path: '/focus',
              builder: (context, state) => const DashboardPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/planner',
              builder: (context, state) => const PlannerPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/stats',
              builder: (context, state) => const StatisticsPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
