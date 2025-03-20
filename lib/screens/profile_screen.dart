import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final userData = appState.userData;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile header
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Language Learner',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Member since ${DateTime.now().year}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 32),
              
              // Stats section
              Text(
                'Your Stats',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildStatRow(
                        context, 
                        icon: Icons.emoji_events, 
                        title: 'Total Score', 
                        value: '${userData.totalScore}',
                      ),
                      Divider(),
                      _buildStatRow(
                        context, 
                        icon: Icons.local_fire_department, 
                        title: 'Current Streak', 
                        value: '${userData.streak} days',
                        iconColor: Colors.orange,
                      ),
                      Divider(),
                      _buildStatRow(
                        context, 
                        icon: Icons.emoji_events, 
                        title: 'Achievements', 
                        value: '${userData.achievements.length}',
                        iconColor: Colors.amber,
                      ),
                      Divider(),
                      _buildStatRow(
                        context, 
                        icon: Icons.trending_up, 
                        title: 'Progress', 
                        value: '${(userData.progressPercentage * 100).toInt()}%',
                        iconColor: Colors.green,
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 32),
              
              // Settings section
              Text(
                'Settings',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: Text('Dark Mode'),
                      value: appState.isDarkMode,
                      onChanged: (bool value) {
                        appState.setDarkMode(value);
                      },
                      secondary: Icon(
                        appState.isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.notifications),
                      title: Text('Notifications'),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        // Would navigate to notification settings
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Notification settings coming soon!')),
                        );
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.security),
                      title: Text('Privacy'),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        // Would navigate to privacy settings
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Privacy settings coming soon!')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 32),
              
              // Account actions
              Center(
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(Icons.delete),
                      label: Text('Reset Progress'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        minimumSize: Size(200, 45),
                      ),
                      onPressed: () {
                        // Show confirmation dialog
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Reset Progress?'),
                            content: Text('This will reset all your progress, scores, and achievements. This action cannot be undone.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('CANCEL'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Would reset user data
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Feature coming soon!')),
                                  );
                                },
                                child: Text('RESET'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 16),
                    TextButton(
                      child: Text('About Language Mastery'),
                      onPressed: () {
                        showAboutDialog(
                          context: context,
                          applicationName: 'Language Mastery',
                          applicationVersion: '1.0.0',
                          applicationIcon: Icon(Icons.language),
                          applicationLegalese: '© 2023 Language Mastery',
                          children: [
                            SizedBox(height: 16),
                            Text('A language learning app designed to help you master new languages in a fun and effective way.'),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildStatRow(BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    Color? iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor ?? Theme.of(context).primaryColor,
            size: 24,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
} 