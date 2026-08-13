import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../models/cooking_note.dart';
import '../widgets/voice_input_button.dart';

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
          if (kIsWeb)
            // The custom mic button relies on the Web Speech API, which
            // Safari/WebKit doesn't support. On web, rely on iOS/Android's
            // own keyboard dictation button instead — it works in any text
            // field regardless of what the page implements.
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText:
                          'Tap here, then use your keyboard\'s dictation '
                          'button to speak…',
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
            )
          else
            VoiceInputButton(
              idleHint:
                  'Tap and read out a measurement, e.g. "200 grams flour"',
              onFinalResult: _addNote,
            ),
          const SizedBox(height: 16),
          Expanded(
            child: _notes.isEmpty
                ? const Center(child: Text('No cooking notes yet.'))
                : ListView.builder(
                    itemCount: _notes.length,
                    itemBuilder: (context, index) {
                      final note = _notes[index];
                      return ListTile(
                        leading: const Icon(Icons.restaurant),
                        title: Text(note.text),
                        subtitle: Text(_timeFormat.format(note.createdAt)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _removeNote(note),
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
