import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final Function(bool) onToggleTheme;
  final bool isDarkMode;

  const HomeScreen({
    Key? key,
    required this.onToggleTheme,
    required this.isDarkMode,
  }) : super(key: key);

  // The new, updated dialog function as requested
  void _showJournalModeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Choose Journal Mode"),
          content: const Text("How would you like to journal today?"),
          actions: [
            TextButton.icon(
              icon: const Icon(Icons.edit),
              label: const Text("Static Entry"),
              onPressed: () {
                Navigator.of(context).pop(); // close dialog
                Navigator.pushNamed(context, '/journal_static');
              },
            ),
            TextButton.icon(
              icon: const Icon(Icons.lightbulb),
              label: const Text("Prompt-based"),
              onPressed: () {
                Navigator.of(context).pop(); // close dialog
                Navigator.pushNamed(context, '/journal_prompt');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mental Health AI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          // The grid tile for 'Journal' can now directly open the static journal
          _buildTile(context, 'Journal', Icons.book, '/journal_static'),
          _buildTile(context, 'History', Icons.history, '/history'),
          _buildTile(context, 'Chat', Icons.chat, '/chat'),
          _buildTile(context, 'Goals', Icons.flag, '/goals'),
          _buildTile(context, 'Charts', Icons.bar_chart, '/chart'),
        ],
      ),
      // The FloatingActionButton correctly calls the new dialog
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showJournalModeDialog(context),
        child: const Icon(Icons.edit),
        tooltip: 'New Journal Entry',
      ),
    );
  }

  // Reusable tile widget for the grid
  Widget _buildTile(
    BuildContext context,
    String title,
    IconData icon,
    String route,
  ) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40),
              const SizedBox(height: 10),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}
