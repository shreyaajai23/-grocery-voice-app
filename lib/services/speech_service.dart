import 'package:speech_to_text/speech_to_text.dart' as stt;

/// Thin wrapper around the on-device speech_to_text plugin (iOS Speech
/// framework / Android SpeechRecognizer). Recognition runs locally on the
/// phone, in English.
class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _available = false;

  bool get isListening => _speech.isListening;

  Future<bool> initialize() async {
    _available = await _speech.initialize();
    return _available;
  }

  /// Starts listening. [onResult] is called with the current transcript and
  /// whether it's the final result each time recognition updates.
  Future<void> startListening({
    required void Function(String text, bool isFinal) onResult,
  }) async {
    if (!_available) {
      final ok = await initialize();
      if (!ok) return;
    }
    await _speech.listen(
      onResult: (result) {
        onResult(result.recognizedWords, result.finalResult);
      },
      listenOptions: stt.SpeechListenOptions(
        partialResults: true,
        cancelOnError: true,
        localeId: 'en_US',
      ),
    );
  }

  Future<void> stopListening() async {
    await _speech.stop();
  }
}
