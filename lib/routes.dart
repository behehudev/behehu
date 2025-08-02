import 'package:flutter/material.dart';

// Import all screen widgets
import 'screens/home_screen.dart';
import 'screens/journal_history_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/goals_screen.dart';
import 'screens/chart_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/journal_screen_static.dart'; // New static journal screen
import 'screens/journal_screen_prompt.dart'; // New prompt-based journal screen

// Define the app's routes in a map for clarity
final Map<String, WidgetBuilder> appRoutes = {
  // New journal routes
  '/journal_static': (context) => JournalScreenStatic(),
  '/journal_prompt': (context) => JournalScreenPrompt(),

  // Other feature routes
  '/history': (context) => JournalHistoryScreen(),
  '/chat': (context) => ChatScreen(),
  '/goals': (context) => GoalsScreen(),
  '/chart': (context) => ChartScreen(),
};

// This function builds the final routes map, including routes that need parameters
Map<String, WidgetBuilder> buildRoutes(
  Function(bool) onToggleTheme,
  bool isDarkMode,
) {
  return {
    // The home route needs theme toggling functions
    '/': (context) =>
        HomeScreen(onToggleTheme: onToggleTheme, isDarkMode: isDarkMode),

    // The settings route also needs theme toggling functions
    '/settings': (context) =>
        SettingsScreen(onToggleTheme: onToggleTheme, isDarkMode: isDarkMode),

    // Spread the rest of the app routes from the map
    ...appRoutes,
  };
}
