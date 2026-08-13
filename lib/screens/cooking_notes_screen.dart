import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../models/cooking_note.dart';
import '../widgets/voice_input_button.dart';
import '../theme.dart';

class CookingNotesScreen extends StatefulWidget {
  const CookingNotesScreen({super.key});

  @override
  State<CookingNotesScreen> createState() => _CookingNotesScreenState();
}

class _CookingNotesScreenState extends State<CookingNotesScreen> {
  final List<CookingNote> _notes = [];
  final DateFormat _timeFormat = DateFormat('h:mm a');
  final TextEditingController _textController = TextEditingController();

  void _addNote(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _notes.insert(
        0,
        CookingNote(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          text: text.trim(),
          createdAt: DateTime.now(),
        ),
      );
      _textController.clear();
    });
  }

  void _removeNote(CookingNote note) {
    setState(() => _notes.removeWhere((n) => n.id == note.id));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (kIsWeb) ...[
            // The custom mic button relies on the Web Speech API, which
            // Safari/WebKit doesn't support. On web, rely on iOS/Android's
            // own keyboard dictation button instead — it works in any text
            // field regardless of what the page implements.
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.mic, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'To talk: tap the box below to bring up your '
                      'keyboard, then tap the microphone icon on the '
                      'keyboard itself to speak.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Type or dictate a measurement…',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: _addNote,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _addNote(_textController.text),
                ),
              ],
            ),
          ] else
            VoiceInputButton(
              idleHint:
                  'Tap and read out a measurement, e.g. "200 grams flour"',
              onFinalResult: _addNote,
            ),
          const SizedBox(height: 16),
          Expanded(
            child: _notes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.soup_kitchen_outlined,
                          size: 40,
                          color: PantryTalkTheme.terracotta.withValues(
                            alpha: 0.35,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No cooking notes yet.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: PantryTalkTheme.ink.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: _notes.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final note = _notes[index];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: PantryTalkTheme.sagePale,
                            foregroundColor: const Color(0xFF25381F),
                            child: const Icon(Icons.restaurant, size: 18),
                          ),
                          title: Text(note.text),
                          subtitle: Text(_timeFormat.format(note.createdAt)),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => _removeNote(note),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
