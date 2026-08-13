class CookingNote {
  final String id;
  final String text;
  final DateTime createdAt;

  CookingNote({required this.id, required this.text, required this.createdAt});

  Map<String, dynamic> toMap() {
    return {'text': text, 'createdAt': createdAt.toIso8601String()};
  }

  factory CookingNote.fromMap(String id, Map<String, dynamic> map) {
    return CookingNote(
      id: id,
      text: map['text'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
