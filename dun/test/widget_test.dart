import 'package:dun/app/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('Life OS bootstrap smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: LifeOsApp()));

    await tester.pumpAndSettle();
    await tester.pump();
    await tester.pump();

    expect(find.text('Auth'), findsOneWidget);
  });
}
