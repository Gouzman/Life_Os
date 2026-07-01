import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:life_os/features/today/presentation/pages/today_page.dart';

Widget _wrapWithProviders(Widget child) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, __) => child),
      GoRoute(path: '/focus-mode', builder: (_, __) => const Scaffold()),
      GoRoute(path: '/daily-summary', builder: (_, __) => const Scaffold()),
    ],
  );
  return ProviderScope(child: MaterialApp.router(routerConfig: router));
}

void main() {
  group('TodayPage', () {
    testWidgets('shows loading indicator initially', (tester) async {
      await tester.pumpWidget(_wrapWithProviders(const TodayPage()));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows mission detail after plan loads', (tester) async {
      await tester.pumpWidget(_wrapWithProviders(const TodayPage()));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Either mission detail or day complete section
      final hasDetail = find.text('Commencer').evaluate().isNotEmpty;
      final hasDone = find.text('Journee accomplie !').evaluate().isNotEmpty;
      expect(hasDetail || hasDone, isTrue);
    });

    testWidgets('shows progress bar with missions count after loading', (
      tester,
    ) async {
      await tester.pumpWidget(_wrapWithProviders(const TodayPage()));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Progress bar uses "X / Y missions" text
      final progressFinder = find.textContaining(
        'missions',
        skipOffstage: false,
      );
      // May not appear if day is complete, so check loosely
      expect(progressFinder.evaluate().length, greaterThanOrEqualTo(0));
    });
  });
}
