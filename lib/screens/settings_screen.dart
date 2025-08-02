import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onToggleTheme;

  const SettingsScreen({
    Key? key,
    required this.isDarkMode,
    required this.onToggleTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SwitchListTile(
              title: Text('Dark Mode'),
              subtitle: Text(isDarkMode ? 'Enabled' : 'Disabled'),
              value: isDarkMode,
              onChanged: onToggleTheme,
              secondary: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('About'),
              subtitle: Text('Mental Health Companion App'),
            ),
          ],
        ),
      ),
    );
  }
}
