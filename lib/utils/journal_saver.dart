import 'package:uuid/uuid.dart'; // A robust library for generating unique IDs
import '../models/journal_entry.dart';
import 'journal_storage.dart';

/// A helper function to create and save a new journal entry.
///
/// This function encapsulates the creation of a JournalEntry object
/// with all required fields and saves it using the JournalStorage utility.
Future<void> saveJournalEntry({
  required String content,
  required String mood,
  String source =
      'static', // Default the source to 'static', can be overridden.
}) async {
  // 1. Create a complete JournalEntry object with all required fields.
  final entry = JournalEntry(
    id: const Uuid().v4(), // ✅ Provide a unique 'id'.
    date: DateTime.now(), // ✅ Provide the 'date'.
    mood: mood, // This was already provided.
    content: content, // This was already provided.
    source: source, // ✅ Provide the 'source'.
  );

  // 2. Use the correct static method from the JournalStorage class to save the entry.
  await JournalStorage.saveEntry(entry);
}
