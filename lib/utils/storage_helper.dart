import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class StorageHelper {
  static Future<String> _getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> _getLocalFile() async {
    final path = await _getLocalPath();
    return File('$path/journal_entries.json');
  }

  static Future<void> saveEntry(Map<String, dynamic> entry) async {
    final file = await _getLocalFile();

    List<dynamic> entries = [];

    if (await file.exists()) {
      final contents = await file.readAsString();
      if (contents.isNotEmpty) {
        entries = json.decode(contents);
      }
    }

    entries.add(entry);
    await file.writeAsString(json.encode(entries), flush: true);
  }

  static Future<List<Map<String, dynamic>>> loadEntries() async {
    try {
      final file = await _getLocalFile();

      if (!await file.exists()) return [];

      final contents = await file.readAsString();
      final decoded = json.decode(contents);

      return List<Map<String, dynamic>>.from(decoded);
    } catch (e) {
      return [];
    }
  }
}
