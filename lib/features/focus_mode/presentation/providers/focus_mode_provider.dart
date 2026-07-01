import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Represents the runtime state of the Focus Mode screen.
class FocusModeState {
  /// Identifier of the mission being focused on.
  final String? missionId;

  /// Time elapsed since the focus session started.
  final Duration elapsed;

  /// Whether the timer is currently ticking.
  final bool isRunning;

  const FocusModeState({
    this.missionId,
    this.elapsed = Duration.zero,
    this.isRunning = false,
  });

  /// Initial idle state – no active mission.
  const FocusModeState.idle()
    : missionId = null,
      elapsed = Duration.zero,
      isRunning = false;

  FocusModeState copyWith({
    String? missionId,
    Duration? elapsed,
    bool? isRunning,
  }) {
    return FocusModeState(
      missionId: missionId ?? this.missionId,
      elapsed: elapsed ?? this.elapsed,
      isRunning: isRunning ?? this.isRunning,
    );
  }

  /// Returns a new state with one second added to [elapsed].
  FocusModeState tick() =>
      copyWith(elapsed: elapsed + const Duration(seconds: 1));
}

/// Manages the Focus Mode timer and mission lifecycle.
class FocusModeNotifier extends Notifier<FocusModeState> {
  Timer? _timer;

  @override
  FocusModeState build() {
    ref.onDispose(_cancelTimer);
    return const FocusModeState.idle();
  }

  /// Starts a focus session for [missionId].
  void start(String missionId) {
    _cancelTimer();
    state = FocusModeState(missionId: missionId, isRunning: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.tick();
    });
  }

  /// Pauses the running timer without resetting elapsed time.
  void pause() {
    _cancelTimer();
    state = state.copyWith(isRunning: false);
  }

  /// Resumes the timer after a pause.
  void resume() {
    if (state.missionId == null) return;
    _cancelTimer();
    state = state.copyWith(isRunning: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.tick();
    });
  }

  /// Resets the state to idle without completing the mission.
  void reset() {
    _cancelTimer();
    state = const FocusModeState.idle();
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }
}

/// Provider for [FocusModeNotifier].
final focusModeProvider = NotifierProvider<FocusModeNotifier, FocusModeState>(
  FocusModeNotifier.new,
);
