import 'dart:io';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/journal_entry.dart';
import '../utils/journal_storage.dart';

class JournalHistoryScreen extends StatefulWidget {
  const JournalHistoryScreen({Key? key}) : super(key: key);

  @override
  _JournalHistoryScreenState createState() => _JournalHistoryScreenState();
}

class _JournalHistoryScreenState extends State<JournalHistoryScreen> {
  List<JournalEntry> _entries = [];
  List<JournalEntry> _filtered = [];
  final TextEditingController _searchController = TextEditingController();
  String _selectedMood = 'All';
  DateTime? _selectedDate; // To keep track of the selected date filter

  @override
  void initState() {
    super.initState();
    _loadEntries();
    _searchController.addListener(_applyFilters);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadEntries() async {
    final entries = await JournalStorage.loadEntries();
    setState(() {
      entries.sort((a, b) => b.date.compareTo(a.date));
      _entries = entries;
      _filtered = _entries;
    });
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filtered = _entries.where((entry) {
        // Mood filter
        final moodMatch = _selectedMood == 'All' || entry.mood == _selectedMood;

        // Date filter
        final dateMatch =
            _selectedDate == null ||
            (entry.date.year == _selectedDate!.year &&
                entry.date.month == _selectedDate!.month &&
                entry.date.day == _selectedDate!.day);

        // Search query filter
        final searchMatch = entry.content.toLowerCase().contains(query);

        return moodMatch && dateMatch && searchMatch;
      }).toList();
    });
  }

  void _deleteEntry(JournalEntry entry) async {
    final originalEntries = List<JournalEntry>.from(_entries);
    setState(() {
      _entries.removeWhere((e) => e.id == entry.id);
      _applyFilters();
    });
    await JournalStorage.saveEntries(_entries);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Entry deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _entries = originalEntries;
              _applyFilters();
            });
            JournalStorage.saveEntries(_entries);
          },
        ),
      ),
    );
  }

  void _editEntry(JournalEntry entry) {
    final editController = TextEditingController(text: entry.content);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Entry'),
        content: TextField(
          controller: editController,
          maxLines: null,
          autofocus: true,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final index = _entries.indexWhere((e) => e.id == entry.id);
              if (index != -1) {
                final updatedEntry = _entries[index].copyWith(
                  content: editController.text,
                );
                setState(() {
                  _entries[index] = updatedEntry;
                  _applyFilters();
                });
                await JournalStorage.saveEntries(_entries);
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _exportToCSV() async {
    // CSV export should reflect the currently filtered list
    final List<List<String>> rows = [
      ['Date', 'Mood', 'Content', 'Source'],
      ..._filtered.map(
        (e) => [
          e.date.toIso8601String(),
          e.mood,
          e.content.replaceAll('\n', ' '),
          e.source,
        ],
      ),
    ];

    final csvData = const ListToCsvConverter().convert(rows);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/journal_export.csv');
    await file.writeAsString(csvData);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Exported to ${file.path}')));
  }

  void _exportToPDF() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              'Journal Entries',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
          ),
          ..._filtered.map(
            (entry) => pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 15),
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey300),
                borderRadius: pw.BorderRadius.circular(5),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Date: ${entry.date.toLocal().toString().split(' ')[0]}',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text('Mood: ${entry.mood}'),
                  pw.SizedBox(height: 5),
                  pw.Text(entry.content),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    'Source: ${entry.source}',
                    style: const pw.TextStyle(color: PdfColors.grey600),
                  ),
                  pw.Divider(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    final output = await getApplicationDocumentsDirectory();
    final file = File('${output.path}/journal_entries.pdf');
    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Exported to ${file.path}')));
  }

  // ✅ THIS FUNCTION IS NOW CALLED BY THE DATE FILTER BUTTON
  void _filterByDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _applyFilters();
      });
    }
  }

  void _filterByMood(String mood) {
    setState(() {
      _selectedMood = mood;
      _applyFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Export to CSV',
            onPressed: _exportToCSV,
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Export to PDF',
            onPressed: _exportToPDF,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Search entries...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // ✅ ADDED BUTTON TO TRIGGER _filterByDate
                    IconButton(
                      icon: Icon(
                        Icons.calendar_today,
                        color: _selectedDate != null
                            ? Theme.of(context).primaryColor
                            : null,
                      ),
                      tooltip: 'Filter by Date',
                      onPressed: _filterByDate,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedMood,
                        decoration: const InputDecoration(
                          labelText: 'Filter by Mood',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                        items:
                            [
                              'All',
                              'Happy',
                              'Sad',
                              'Neutral',
                              'Calm',
                              'Anxious',
                            ].map((mood) {
                              return DropdownMenuItem(
                                value: mood,
                                child: Text(mood),
                              );
                            }).toList(),
                        onChanged: (val) => _filterByMood(val!),
                      ),
                    ),
                    // ✅ ADDED BUTTON TO CLEAR ALL FILTERS
                    if (_selectedDate != null || _selectedMood != 'All')
                      IconButton(
                        icon: const Icon(Icons.clear),
                        tooltip: 'Clear Filters',
                        onPressed: () {
                          setState(() {
                            _selectedDate = null;
                            _selectedMood = 'All';
                            _searchController
                                .clear(); // Also clears search text
                            _applyFilters();
                          });
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _filtered.isEmpty
                ? const Center(child: Text('No entries found.'))
                : ListView.builder(
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      final entry = _filtered[index];
                      return Dismissible(
                        key: Key(entry.id),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        secondaryBackground: Container(
                          color: Colors.blue,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.edit, color: Colors.white),
                        ),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.startToEnd) {
                            _deleteEntry(entry);
                            return true;
                          } else {
                            _editEntry(entry);
                            return false;
                          }
                        },
                        child: ListTile(
                          title: Text(
                            entry.content,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            '${entry.date.toLocal().toString().split('.')[0]} — Mood: ${entry.mood}',
                          ),
                          onTap: () => _editEntry(entry),
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
