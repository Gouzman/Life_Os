import 'package:audioplayers/audioplayers.dart';
import 'package:dun/features/sound/domain/services/sound_service.dart';

class AudioPlayerSoundService implements SoundService {
  late final AudioPlayer _player;

  @override
  Future<void> initialize() async {
    _player = AudioPlayer();
  }

  @override
  Future<void> playStart() async {
    await _playAsset('sounds/start.mp3');
  }

  @override
  Future<void> playPause() async {
    await _playAsset('sounds/pause.mp3');
  }

  @override
  Future<void> playResume() async {
    await _playAsset('sounds/resume.mp3');
  }

  @override
  Future<void> playComplete() async {
    await _playAsset('sounds/complete.mp3');
  }

  @override
  Future<void> playCancel() async {
    await _playAsset('sounds/cancel.mp3');
  }

  @override
  Future<void> stop() async {
    await _player.stop();
  }

  @override
  Future<void> dispose() async {
    await _player.dispose();
  }

  Future<void> _playAsset(String assetPath) async {
    await _player.stop();
    await _player.play(AssetSource(assetPath));
  }
}
