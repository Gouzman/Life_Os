abstract class SoundService {
  Future<void> initialize();
  Future<void> playStart();
  Future<void> playPause();
  Future<void> playResume();
  Future<void> playComplete();
  Future<void> playCancel();
  Future<void> stop();
  Future<void> dispose();
}
