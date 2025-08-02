import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/journal_entry.dart';
import '../utils/journal_storage.dart';

class JournalScreen extends StatefulWidget {
  @override
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final _controller = TextEditingController();

  void _saveEntry() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final entry = JournalEntry(
      id: Uuid().v4(),
      timestamp: DateTime.now(),
      content: text,
    );

    final entries = await JournalStorage.loadEntries();
    entries.add(entry);
    await JournalStorage.saveEntries(entries);

    _controller.clear();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Entry saved')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Journal Entry')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: 'Write about your day...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton.icon(
              icon: Icon(Icons.save),
              label: Text('Save'),
              onPressed: _saveEntry,
            ),
          ],
        ),
      ),
    );
  }
}
