import 'package:flutter/material.dart';
import 'routes.dart';

void main() {
  runApp(MindfulSpaceApp());
}

class MindfulSpaceApp extends StatefulWidget {
  @override
  _MindfulSpaceAppState createState() => _MindfulSpaceAppState();
}

class _MindfulSpaceAppState extends State<MindfulSpaceApp> {
  bool _isDarkMode = false;

  void _toggleTheme(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MindfulSpace',
      theme: ThemeData(
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        primarySwatch: Colors.teal,
        primaryColor: Colors.teal[400],
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.teal,
          brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        ).copyWith(
          primary: Colors.teal[400],
          secondary: Colors.teal[300],
          surface: Colors.grey[50],
        ),
        fontFamily: 'Roboto',
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          titleTextStyle: const TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        cardTheme: CardThemeData(
          // Corrected from CardTheme to CardThemeData
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal[400],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.teal[400],
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.teal,
        primaryColor: Colors.teal[300],
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.teal,
          brightness: Brightness.dark,
        ).copyWith(
          primary: Colors.teal[300],
          secondary: Colors.teal[200],
          surface: Colors.grey[900],
        ),
        fontFamily: 'Roboto',
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/',
      routes: buildRoutes(_toggleTheme, _isDarkMode),
      debugShowCheckedModeBanner: false,
    );
  }
}

