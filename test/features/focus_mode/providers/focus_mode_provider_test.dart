import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_os/features/focus_mode/presentation/providers/focus_mode_provider.dart';

void main() {
  group('FocusModeNotifier', () {
    ProviderContainer _makeContainer() => ProviderContainer();

    test('initial state is idle', () {
      final container = _makeContainer();
      addTearDown(container.dispose);

      final state = container.read(focusModeProvider);

      expect(state.missionId, isNull);
      expect(state.elapsed, Duration.zero);
      expect(state.isRunning, isFalse);
    });

    test('start sets missionId and isRunning', () {
      final container = _makeContainer();
      addTearDown(container.dispose);

      container.read(focusModeProvider.notifier).start('m1');

      final state = container.read(focusModeProvider);
      expect(state.missionId, 'm1');
      expect(state.isRunning, isTrue);
    });

    test('pause stops isRunning without clearing missionId', () {
      final container = _makeContainer();
      addTearDown(container.dispose);

      container.read(focusModeProvider.notifier).start('m1');
      container.read(focusModeProvider.notifier).pause();

      final state = container.read(focusModeProvider);
      expect(state.missionId, 'm1');
      expect(state.isRunning, isFalse);
    });

    test('resume restarts timer', () {
      final container = _makeContainer();
      addTearDown(container.dispose);

      container.read(focusModeProvider.notifier).start('m1');
      container.read(focusModeProvider.notifier).pause();
      container.read(focusModeProvider.notifier).resume();

      final state = container.read(focusModeProvider);
      expect(state.isRunning, isTrue);
    });

    test('reset clears all state', () {
      final container = _makeContainer();
      addTearDown(container.dispose);

      container.read(focusModeProvider.notifier).start('m1');
      container.read(focusModeProvider.notifier).reset();

      final state = container.read(focusModeProvider);
      expect(state.missionId, isNull);
      expect(state.elapsed, Duration.zero);
      expect(state.isRunning, isFalse);
    });

    test('tick increments elapsed by one second', () {
      final initial = const FocusModeState(
        missionId: 'm1',
        elapsed: Duration(seconds: 10),
        isRunning: true,
      );
      final ticked = initial.tick();

      expect(ticked.elapsed, const Duration(seconds: 11));
      expect(ticked.missionId, 'm1');
      expect(ticked.isRunning, isTrue);
    });

    test('resume does nothing when no missionId is set', () {
      final container = _makeContainer();
      addTearDown(container.dispose);

      // Should not throw
      container.read(focusModeProvider.notifier).resume();

      final state = container.read(focusModeProvider);
      expect(state.isRunning, isFalse);
    });
  });
}
