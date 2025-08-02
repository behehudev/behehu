import 'package:flutter/material.dart';
import 'routes.dart';

void main() {
  runApp(MentalHealthApp());
}

class MentalHealthApp extends StatefulWidget {
  @override
  _MentalHealthAppState createState() => _MentalHealthAppState();
}

class _MentalHealthAppState extends State<MentalHealthApp> {
  bool _isDarkMode = false;

  void _toggleTheme(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mental Health AI',
      theme: ThemeData(
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        primarySwatch: Colors.teal,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      routes: buildRoutes(_toggleTheme, _isDarkMode),
      debugShowCheckedModeBanner: false,
    );
  }
}
