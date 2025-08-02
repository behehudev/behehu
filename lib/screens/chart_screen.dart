import 'package:flutter/material.dart';

class ChartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mood & Energy Charts')),
      body: Center(
        child: Text('Mood and energy trends will be visualized here.'),
      ),
    );
  }
}
