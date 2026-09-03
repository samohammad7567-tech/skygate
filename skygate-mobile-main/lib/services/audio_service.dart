import 'package:audioplayers/audioplayers.dart';

/// Short sound effects (scanner beeps, confirmations) and simple playback.
///
/// Holds one shared player for one-shot effects so screens no longer create and
/// leak an `AudioPlayer` each. Call [dispose] on app shutdown.
class AudioService {
  AudioService._();

  static final AudioService instance = AudioService._();

  /// Asset played after a successful passport scan.
  static const String beepAsset = 'sounds/beep.wav';

  final AudioPlayer _player = AudioPlayer();

  /// Plays an asset. [asset] is relative to the `assets/` folder, matching how
  /// `audioplayers` resolves `AssetSource`, e.g. `sounds/beep.wav`.
  Future<void> playAsset(String asset, {double? volume}) async {
    try {
      if (volume != null) await _player.setVolume(volume);
      await _player.play(AssetSource(asset));
    } catch (_) {
      // A missing asset or a busy audio session must never break the flow that
      // triggered the sound.
    }
  }

  /// Plays the scanner confirmation beep.
  Future<void> playBeep() => playAsset(beepAsset);

  /// Streams audio from a remote [url].
  Future<void> playUrl(String url, {double? volume}) async {
    try {
      if (volume != null) await _player.setVolume(volume);
      await _player.play(UrlSource(url));
    } catch (_) {
      // ignore playback failures
    }
  }

  Future<void> pause() => _player.pause();

  Future<void> resume() => _player.resume();

  Future<void> stop() => _player.stop();

  Future<void> setVolume(double volume) => _player.setVolume(volume);

  /// Player state changes, for screens that show a play/pause button.
  Stream<PlayerState> get onStateChanged => _player.onPlayerStateChanged;

  Stream<Duration> get onPositionChanged => _player.onPositionChanged;

  Future<void> dispose() => _player.dispose();
}
