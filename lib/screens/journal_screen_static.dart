import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart'; // Import for generating unique IDs
import '../models/journal_entry.dart';
import '../utils/journal_storage.dart';

class JournalScreenStatic extends StatefulWidget {
  const JournalScreenStatic({Key? key}) : super(key: key);

  @override
  _JournalScreenStaticState createState() => _JournalScreenStaticState();
}

class _JournalScreenStaticState extends State<JournalScreenStatic> {
  // This is the correctly named controller
  final TextEditingController _controller = TextEditingController();

  // Use descriptive strings for moods to match the data model
  String _selectedMood = 'Neutral';
  final List<String> _moods = ['Happy', 'Sad', 'Anxious', 'Calm', 'Neutral'];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // --- THIS IS THE CORRECTED _saveEntry METHOD ---
  void _saveEntry() async {
    // 1. Validate that the text field is not empty
    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Journal entry cannot be empty.')),
      );
      return;
    }

    // 2. Create a JournalEntry object with all required fields
    final entry = JournalEntry(
      id: const Uuid().v4(), // Using a unique ID
      content: _controller.text
          .trim(), // ✅ Use the correct controller name '_controller'
      date: DateTime.now(), // ✅ Correctly use 'date' instead of 'timestamp'
      mood: _selectedMood,
      source: 'static', // Provide the required 'source' field
    );

    // 3. Call the correct static method from JournalStorage
    await JournalStorage.saveEntry(entry);

    // 4. Show confirmation and reset the UI
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Journal saved!')));
    _controller.clear();
    setState(() => _selectedMood = 'Neutral'); // Reset to default mood

    // 5. Go back to the previous screen after saving
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Journal Entry'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveEntry,
            tooltip: 'Save Entry',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedMood,
              decoration: const InputDecoration(
                labelText: 'Select Mood',
                border: OutlineInputBorder(),
              ),
              items: _moods.map((mood) {
                return DropdownMenuItem(value: mood, child: Text(mood));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedMood = value);
                }
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _controller, // ✅ Use the correct controller here
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: 'What\'s on your mind?',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Save Entry'),
              onPressed: _saveEntry,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
