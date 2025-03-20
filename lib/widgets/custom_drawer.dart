import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../screens/achievements_screen.dart';
import '../screens/leaderboard_screen.dart';
import '../screens/profile_screen.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isDarkMode = appState.isDarkMode;
    final languages = appState.languages;
    final selectedLanguage = appState.selectedLanguage;
    
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Language Mastery',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Select a language:',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          ...languages.map((language) => ListTile(
            leading: Text(
              language.flag,
              style: TextStyle(fontSize: 24),
            ),
            title: Text(language.name),
            selected: selectedLanguage == language.name,
            onTap: () {
              appState.setSelectedLanguage(language.name);
              Navigator.pop(context);
            },
          )).toList(),
          Divider(),
          ListTile(
            leading: Icon(Icons.leaderboard),
            title: Text('Leaderboard'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LeaderboardScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.emoji_events),
            title: Text('Achievements'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AchievementsScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            title: Text(isDarkMode ? 'Light Mode' : 'Dark Mode'),
            onTap: () {
              appState.toggleDarkMode();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
} 