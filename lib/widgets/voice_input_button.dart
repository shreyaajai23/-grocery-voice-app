import 'package:flutter/material.dart';
import '../services/speech_service.dart';
import '../theme.dart';

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

class _VoiceInputButtonState extends State<VoiceInputButton>
    with SingleTickerProviderStateMixin {
  final SpeechService _speechService = SpeechService();
  bool _listening = false;
  String _transcript = '';

  late final AnimationController _pulseController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

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
          child: SizedBox(
            width: 96,
            height: 96,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (_listening)
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      final scale = 1 + (_pulseController.value * 0.5);
                      final opacity = (1 - _pulseController.value).clamp(
                        0.0,
                        1.0,
                      );
                      return Transform.scale(
                        scale: scale,
                        child: Opacity(
                          opacity: opacity,
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: PantryTalkTheme.terracotta,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: _listening
                          ? [
                              const Color(0xFFB3261E),
                              const Color(0xFF8A3B21),
                            ]
                          : [
                              PantryTalkTheme.terracotta,
                              PantryTalkTheme.terracottaDark,
                            ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: PantryTalkTheme.terracotta.withValues(
                          alpha: 0.35,
                        ),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(
                    _listening ? Icons.mic : Icons.mic_none,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          _listening
              ? (_transcript.isEmpty ? 'Listening…' : _transcript)
              : widget.idleHint,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: PantryTalkTheme.ink.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
