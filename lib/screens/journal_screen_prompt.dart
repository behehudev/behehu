import 'dart:math';
import 'package:flutter/material.dart';
import '../models/journal_entry.dart';
import '../utils/journal_storage.dart';

class JournalScreenPrompt extends StatefulWidget {
  const JournalScreenPrompt({Key? key}) : super(key: key);

  @override
  _JournalScreenPromptState createState() => _JournalScreenPromptState();
}

class _JournalScreenPromptState extends State<JournalScreenPrompt> {
  final TextEditingController _controller = TextEditingController();
  // Using more descriptive mood names for clarity in data
  String _selectedMood = 'Neutral';
  final List<String> _moods = ['Happy', 'Sad', 'Anxious', 'Calm', 'Neutral'];

  List<String> _prompts = [];
  final List<String> _promptPool = [
    'What made you smile today?',
    'Describe a challenge you overcame recently.',
    'What are you grateful for right now?',
    'What’s one thing you’d like to improve about yourself?',
    'What does your ideal day look like?',
    'Who or what inspires you the most?',
    'What’s something you’re proud of?',
    'How are you feeling emotionally today?',
    'What’s a recent positive experience you had?',
    'Describe a moment of peace you experienced.',
  ];

  @override
  void initState() {
    super.initState();
    _generatePrompts();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _generatePrompts() {
    final rand = Random();
    // Ensure new prompts are generated and different from the old ones if possible
    final newPrompts = <String>{};
    while (newPrompts.length < 3) {
      newPrompts.add(_promptPool[rand.nextInt(_promptPool.length)]);
    }
    setState(() {
      _prompts = newPrompts.toList();
    });
  }

  // --- THIS IS THE NEWLY UPDATED _saveEntry METHOD ---
  void _saveEntry() async {
    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Entry cannot be empty.')));
      return;
    }

    // Create a JournalEntry object using the correct model
    final entry = JournalEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: _controller.text.trim(),
      date: DateTime.now(),
      mood: _selectedMood,
      source: 'prompt', // Indicate this is from prompt mode
    );

    // Use the centralized JournalStorage to save the new entry
    await JournalStorage.saveEntry(entry);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Journal saved!')));

    // Reset the screen for a new entry
    _controller.clear();
    _generatePrompts();
    setState(() => _selectedMood = 'Neutral');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prompt-based Journal'),
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
            const Text(
              'Here are some prompts to inspire you:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Display prompts in a more structured way
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _prompts
                    .map(
                      (prompt) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          '• $prompt',
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedMood,
              decoration: const InputDecoration(
                labelText: 'Select Mood',
                border: OutlineInputBorder(),
              ),
              items: _moods.map((mood) {
                return DropdownMenuItem(value: mood, child: Text(mood));
              }).toList(),
              onChanged: (value) => setState(() => _selectedMood = value!),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: 'Write your thoughts here...',
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
