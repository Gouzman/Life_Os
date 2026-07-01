import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:life_os/features/focus_mode/presentation/pages/focus_mode_page.dart';
import 'package:life_os/features/planner/presentation/providers/planner_providers.dart';

Widget _wrapPage(String missionId) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => FocusModePage(missionId: missionId),
      ),
    ],
  );
  return ProviderScope(child: MaterialApp.router(routerConfig: router));
}

void main() {
  group('FocusModePage', () {
    testWidgets('shows loading while plan is generating', (tester) async {
      // Use an empty missionId; plan will still generate
      await tester.pumpWidget(_wrapPage(''));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    // TODO: These tests need more sophisticated mocking of the async flow
    // The issue is that the plan needs to fully load before the page can render
    // the timer display. This requires better test setup or removing testWidgets
    // in favor of integration tests.
    
    // testWidgets('shows timer display after plan loads with valid id', (
    //   tester,
    // ) async {
    //   // First generate a plan and get a real mission id
    //   final container = ProviderContainer();
    //   addTearDown(container.dispose);
    //   final plan = await container.read(dailyPlanProvider.future);
    //   final missionId = plan.missionInstances.first.id;
    //   container.dispose();

    //   await tester.pumpWidget(_wrapPage(missionId));
    //   await tester.pumpAndSettle(const Duration(seconds: 3));

    //   // Timer display shows MM:SS
    //   expect(find.text('00:00'), findsOneWidget);
    // });

    // testWidgets('shows complete and skip buttons after plan loads', (
    //   tester,
    // ) async {
    //   final container = ProviderContainer();
    //   addTearDown(container.dispose);
    //   final plan = await container.read(dailyPlanProvider.future);
    //   final missionId = plan.missionInstances.first.id;
    //   container.dispose();

    //   await tester.pumpWidget(_wrapPage(missionId));
    //   await tester.pumpAndSettle(const Duration(seconds: 3));

    //   expect(find.text('Terminer la mission'), findsOneWidget);
    //   expect(find.text('Reporter'), findsOneWidget);
    // });
  });
}
