import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final Function(bool) onToggleTheme;
  final bool isDarkMode;

  const HomeScreen({
    Key? key,
    required this.onToggleTheme,
    required this.isDarkMode,
  }) : super(key: key);

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
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/journal_static');
              },
            ),
            TextButton.icon(
              icon: const Icon(Icons.lightbulb),
              label: const Text("Prompt-based"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/journal_prompt');
              },
            ),
          ],
        );
      },
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning, Friend';
    } else if (hour < 17) {
      return 'Good afternoon, Friend';
    } else {
      return 'Good evening, Friend';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with logo and settings
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.teal[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'MindfulSpace',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings_outlined),
                      onPressed: () => Navigator.pushNamed(context, '/settings'),
                      color: Colors.grey[600],
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),
                
                // Greeting Section
                Center(
                  child: Column(
                    children: [
                      Text(
                        _getGreeting(),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w300,
                          color: Colors.teal[400],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Take a moment for yourself today. Your mental wellness journey matters, and we\'re here to support you every step of the way.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.teal[50],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.teal[400],
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'You\'re in a safe space',
                              style: TextStyle(
                                color: Colors.teal[700],
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 50),
                
                // Quick Actions Section
                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickActionButton(
                        context,
                        'New Entry',
                        Icons.add,
                        Colors.teal[300]!,
                        () => _showJournalModeDialog(context),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildQuickActionButton(
                        context,
                        'Daily Check-in',
                        Icons.favorite_outline,
                        Colors.teal[200]!,
                        () => Navigator.pushNamed(context, '/journal_static'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickActionButton(
                        context,
                        'Breathing Exercise',
                        Icons.air,
                        Colors.grey[300]!,
                        () => _showComingSoonDialog(context),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildQuickActionButton(
                        context,
                        'Schedule',
                        Icons.calendar_today_outlined,
                        Colors.grey[300]!,
                        () => _showComingSoonDialog(context),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 50),
                
                // Your Wellness Tools Section
                const Text(
                  'Your Wellness Tools',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Explore features designed to support your mental health with empathy and understanding.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 30),
                
                // Wellness Tools Grid
                Row(
                  children: [
                    Expanded(
                      child: _buildWellnessToolCard(
                        context,
                        'Daily Journal',
                        'Reflect on your thoughts and emotions in a safe, private space designed for self-discovery.',
                        Icons.book_outlined,
                        () => _showJournalModeDialog(context),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildWellnessToolCard(
                        context,
                        'Mood Tracking',
                        'Monitor your emotional patterns with gentle insights to understand your mental wellness.',
                        Icons.bar_chart_outlined,
                        () => Navigator.pushNamed(context, '/chart'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: _buildWellnessToolCard(
                        context,
                        'Supportive Chat',
                        'Connect with AI guidance or community support when you need someone to listen.',
                        Icons.chat_bubble_outline,
                        () => Navigator.pushNamed(context, '/chat'),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildWellnessToolCard(
                        context,
                        'Wellness Goals',
                        'Set achievable goals for your mental health journey with compassionate reminders.',
                        Icons.track_changes_outlined,
                        () => Navigator.pushNamed(context, '/goals'),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 60),
                
                // You're Not Alone Section
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.teal[100],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(
                          Icons.favorite,
                          color: Colors.teal[400],
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'You\'re Not Alone',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Remember that seeking support is a sign of strength. Every small step you take toward caring for your mental health is meaningful and worthy of celebration.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWellnessToolCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.teal[100],
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                icon,
                color: Colors.teal[400],
                size: 24,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Coming Soon"),
          content: const Text("This feature is coming soon! Stay tuned for updates."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}

