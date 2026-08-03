import 'package:dun/app/providers/auth_state_provider.dart';
import 'package:dun/app/providers/global_providers.dart';
import 'package:dun/app/router/router_paths.dart';
import 'package:dun/features/auth/presentation/screens/login_screen.dart';
import 'package:dun/features/auth/presentation/screens/pin_login_screen.dart';
import 'package:dun/features/auth/presentation/screens/pin_setup_screen.dart';
import 'package:dun/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:dun/features/history/presentation/screens/history_screen.dart';
import 'package:dun/features/scheduler/presentation/screens/execution_screen.dart';
import 'package:dun/features/settings/presentation/screens/settings_screen.dart';
import 'package:dun/features/splash/presentation/screens/splash_screen.dart';
import 'package:dun/features/tasks/presentation/screens/task_form_screen.dart';
import 'package:dun/features/tasks/presentation/screens/task_screen.dart';
import 'package:dun/features/tasks/presentation/screens/tasks_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final pinService = ref.watch(pinServiceProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouterPaths.splash,
    redirect: (context, state) async {
      final isSplash = state.matchedLocation == RouterPaths.splash;
      final isAuthRoute = state.matchedLocation == RouterPaths.auth;
      final isPinSetup = state.matchedLocation == RouterPaths.pinSetup;
      final isPinLogin = state.matchedLocation == RouterPaths.pinLogin;

      return authState.when(
        data: (user) async {
          final isAuthenticated = user != null;

          if (!isAuthenticated) {
            if (isSplash || isAuthRoute) return null;
            return RouterPaths.auth;
          }

          final hasPin = await pinService.hasPin;

          if (!hasPin) {
            if (isPinSetup) return null;
            return RouterPaths.pinSetup;
          }

          if (isSplash || isAuthRoute || isPinSetup) {
            if (isPinLogin) return null;
            return RouterPaths.pinLogin;
          }

          if (isPinLogin) return RouterPaths.dashboard;
          return null;
        },
        loading: () => isSplash ? null : RouterPaths.splash,
        error: (error, stackTrace) => RouterPaths.auth,
      );
    },
    routes: [
      GoRoute(
        path: RouterPaths.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouterPaths.auth,
        name: 'auth',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouterPaths.pinSetup,
        name: 'pinSetup',
        builder: (context, state) => const PinSetupScreen(),
      ),
      GoRoute(
        path: RouterPaths.pinLogin,
        name: 'pinLogin',
        builder: (context, state) => const PinLoginScreen(),
      ),
      GoRoute(
        path: RouterPaths.dashboard,
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: RouterPaths.tasks,
        name: 'tasks',
        builder: (context, state) => const TasksScreen(),
      ),
      GoRoute(
        path: RouterPaths.task,
        name: 'task',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return TaskScreen(id: id);
        },
      ),
      GoRoute(
        path: RouterPaths.createTask,
        name: 'createTask',
        builder: (context, state) => const TaskFormScreen(),
      ),
      GoRoute(
        path: RouterPaths.editTask,
        name: 'editTask',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return TaskFormScreen(taskId: id);
        },
      ),
      GoRoute(
        path: RouterPaths.execution,
        name: 'execution',
        builder: (context, state) => const ExecutionScreen(),
      ),
      GoRoute(
        path: RouterPaths.history,
        name: 'history',
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: RouterPaths.settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});
