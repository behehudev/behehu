import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AI Chat')),
      body: Center(
        child: Text('This will be your AI-based journaling chat interface.'),
      ),
    );
  }
}
