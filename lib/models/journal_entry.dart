// lib/models/journal_entry.dart

class JournalEntry {
  final String id;
  final DateTime date;
  final String mood;
  final String content;
  final String source; // 'static' or 'prompt'

  JournalEntry({
    required this.id,
    required this.date,
    required this.mood,
    required this.content,
    required this.source,
  });

  // Factory constructor to create a JournalEntry from a JSON map
  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      mood: json['mood'] as String,
      content: json['content'] as String,
      source: json['source'] as String,
    );
  }

  // Method to convert a JournalEntry instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'mood': mood,
      'content': content,
      'source': source,
    };
  }

  /// Creates a copy of this JournalEntry but with the given fields replaced with the new values.
  /// This is useful for updating entries without modifying the original instance directly.
  JournalEntry copyWith({
    String? id,
    DateTime? date,
    String? mood,
    String? content,
    String? source,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      mood: mood ?? this.mood,
      content: content ?? this.content,
      source: source ?? this.source,
    );
  }
}
