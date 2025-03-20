import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

import '../models/app_state.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/language_selector.dart';
import '../widgets/stats_card.dart';
import '../main.dart';
import 'quiz_screen.dart';
import 'flashcard_screen.dart';
import 'pronunciation_screen.dart';
import 'leaderboard_screen.dart';
import 'achievements_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isDarkMode = appState.isDarkMode;
    final selectedLanguage = appState.selectedLanguage;
    final userData = appState.userData;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Language Mastery',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
        ),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: () => appState.toggleDarkMode(),
            tooltip: 'Toggle theme',
          ),
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
            tooltip: 'Profile',
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: appState.isLoading 
        ? Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () async {
              // Simulate a refresh delay
              await Future.delayed(Duration(milliseconds: 1500));
              appState.updateStreak();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Language selector
                      LanguageSelector(),
                      SizedBox(height: 24),
                      
                      // Stats card
                      StatsCard(),
                      SizedBox(height: 32),
                      
                      // Section title
                      Text(
                        'Continue Learning',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      
                      // Learning activities
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        children: [
                          _buildActivityCard(
                            context,
                            title: 'Quiz',
                            icon: Icons.quiz,
                            color: Colors.blue,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => QuizScreen()),
                            ),
                          ),
                          _buildActivityCard(
                            context,
                            title: 'Flashcards',
                            icon: Icons.style,
                            color: Colors.orange,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => FlashcardScreen()),
                            ),
                          ),
                          _buildActivityCard(
                            context,
                            title: 'Pronunciation',
                            icon: Icons.record_voice_over,
                            color: Colors.green,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PronunciationScreen()),
                            ),
                          ),
                          _buildActivityCard(
                            context,
                            title: 'Community',
                            icon: Icons.people,
                            color: Colors.purple,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LeaderboardScreen()),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 32),
                      
                      // Achievements section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Your Achievements',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AchievementsScreen()),
                            ),
                            child: Text('See All'),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      
                      // Achievement cards
                      SizedBox(
                        height: 100,
                        child: userData.achievements.isEmpty
                            ? Center(
                                child: Text(
                                  'No achievements yet. Keep learning!',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: TextThemeHelper.captionColor(context),
                                  ),
                                ),
                              )
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: math.min(userData.achievements.length, 3),
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: 120,
                                    margin: EdgeInsets.only(right: 12),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.emoji_events,
                                          color: Colors.amber,
                                          size: 36,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          userData.achievements[index],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),
                      SizedBox(height: 32),
                      
                      // Daily tip
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context).primaryColor.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.lightbulb,
                                  color: Colors.amber,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Daily Tip',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Learning just 15 minutes a day can significantly improve your language skills. Consistency is key!',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: appState.currentPage,
        onTap: (index) {
          if (index != 0) {
            switch (index) {
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FlashcardScreen()),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PronunciationScreen()),
                );
                break;
            }
          }
          appState.setCurrentPage(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.style),
            label: 'Flashcards',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.record_voice_over),
            label: 'Speak',
          ),
        ],
      ),
    );
  }
  
  Widget _buildActivityCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),
              SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 