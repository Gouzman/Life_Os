import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:life_os/features/dashboard/presentation/pages/dashboard_page.dart';

Widget _wrapWithProviders(Widget child) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, __) => child),
      GoRoute(path: '/today', builder: (_, __) => const Scaffold()),
    ],
  );
  return ProviderScope(child: MaterialApp.router(routerConfig: router));
}

void main() {
  group('DashboardPage', () {
    testWidgets('shows loading indicator while plan is generating', (
      tester,
    ) async {
      await tester.pumpWidget(_wrapWithProviders(const DashboardPage()));

      // First frame: AsyncLoading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders mission card after plan is loaded', (tester) async {
      await tester.pumpWidget(_wrapWithProviders(const DashboardPage()));

      // Wait for async plan generation
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Either a HeroMissionCard or the day-complete section should be present
      final hasCard = find.text('Voir la mission').evaluate().isNotEmpty;
      final hasDone = find
          .text('Toutes les missions sont terminees !')
          .evaluate()
          .isNotEmpty;
      expect(hasCard || hasDone, isTrue);
    });

    testWidgets('shows Life Score card after plan loads', (tester) async {
      await tester.pumpWidget(_wrapWithProviders(const DashboardPage()));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.text('Life Score'), findsOneWidget);
    });
  });
}
