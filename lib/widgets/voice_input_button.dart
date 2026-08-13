import 'package:flutter/material.dart';
import '../services/speech_service.dart';

/// Tap-to-talk mic button. Shows a live transcript preview while listening
/// and calls [onFinalResult] once with the recognized text when the user
/// stops speaking or taps again to stop.
class VoiceInputButton extends StatefulWidget {
  final void Function(String text) onFinalResult;
  final String idleHint;

  const VoiceInputButton({
    super.key,
    required this.onFinalResult,
    this.idleHint = 'Tap to speak',
  });

  @override
  State<VoiceInputButton> createState() => _VoiceInputButtonState();
}

class _VoiceInputButtonState extends State<VoiceInputButton> {
  final SpeechService _speechService = SpeechService();
  bool _listening = false;
  String _transcript = '';

  Future<void> _toggleListening() async {
    if (_listening) {
      await _speechService.stopListening();
      setState(() => _listening = false);
      return;
    }

    final available = await _speechService.initialize();
    if (!available) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Speech recognition unavailable. Check microphone permission.',
            ),
          ),
        );
      }
      return;
    }

    setState(() {
      _listening = true;
      _transcript = '';
    });

    await _speechService.startListening(
      onResult: (text, isFinal) {
        setState(() => _transcript = text);
        if (isFinal && text.trim().isNotEmpty) {
          widget.onFinalResult(text.trim());
          setState(() {
            _listening = false;
            _transcript = '';
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _toggleListening,
          child: CircleAvatar(
            radius: 32,
            backgroundColor: _listening
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.primary,
            child: Icon(
              _listening ? Icons.mic : Icons.mic_none,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _listening
              ? (_transcript.isEmpty ? 'Listening…' : _transcript)
              : widget.idleHint,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
