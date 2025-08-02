import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/journal_entry.dart';

class JournalStorage {
  // Get the local file path for storing journal entries.
  static Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/journal_entries.json');
  }

  /// Loads all journal entries from the JSON file.
  static Future<List<JournalEntry>> loadEntries() async {
    try {
      final file = await _localFile;

      if (!await file.exists()) {
        return []; // Return empty list if the file doesn't exist.
      }

      final contents = await file.readAsString();
      if (contents.isEmpty) {
        return []; // Return empty list if the file is empty.
      }

      final List<dynamic> decodedJson = json.decode(contents);
      return decodedJson
          .map((jsonItem) => JournalEntry.fromJson(jsonItem))
          .toList();
    } catch (e) {
      print('Error loading entries: $e');
      return []; // Return empty list on error.
    }
  }

  /// Saves a list of journal entries, overwriting the entire file.
  static Future<void> saveEntries(List<JournalEntry> entries) async {
    try {
      final file = await _localFile;
      final jsonList = entries.map((entry) => entry.toJson()).toList();
      await file.writeAsString(json.encode(jsonList));
    } catch (e) {
      print('Error saving entries: $e');
    }
  }

  // --- THIS IS THE NEW STATIC METHOD INSIDE THE CLASS ---
  /// Adds a single new journal entry to the existing list.
  static Future<void> saveEntry(JournalEntry newEntry) async {
    try {
      // 1. Load the current list of entries.
      final List<JournalEntry> existingEntries = await loadEntries();

      // 2. Add the new entry to the list.
      existingEntries.add(newEntry);

      // 3. Save the entire updated list back to the file.
      await saveEntries(existingEntries);
    } catch (e) {
      print('Error saving single entry: $e');
    }
  }
}
