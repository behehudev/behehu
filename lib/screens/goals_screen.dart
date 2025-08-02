import 'package:flutter/material.dart';

class GoalsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mindset Goals')),
      body: Center(
        child: Text('Set your daily mindset and wellness goals here.'),
      ),
    );
  }
}
