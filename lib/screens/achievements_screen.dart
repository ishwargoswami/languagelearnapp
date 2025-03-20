import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

import '../models/app_state.dart';
import '../data/language_data.dart';
import '../main.dart'; // Import for TextThemeHelper

class AchievementsScreen extends StatefulWidget {
  @override
  _AchievementsScreenState createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _selectedAchievementIndex = -1;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  void _selectAchievement(int index) {
    setState(() {
      if (_selectedAchievementIndex == index) {
        _selectedAchievementIndex = -1;
        _animationController.reverse();
      } else {
        _selectedAchievementIndex = index;
        _animationController.forward();
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final userAchievements = appState.userData.achievements;
    final allAchievements = LanguageData.achievements;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Achievements'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Progress header
          Container(
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Progress',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '${userAchievements.length}/${allAchievements.length}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                LinearProgressIndicator(
                  value: allAchievements.isEmpty ? 0 : userAchievements.length / allAchievements.length,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  borderRadius: BorderRadius.circular(4),
                  minHeight: 8,
                ),
              ],
            ),
          ),
          
          // Achievement list
          Expanded(
            child: allAchievements.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.emoji_events,
                          size: 80,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No achievements available yet',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    itemCount: allAchievements.length,
                    itemBuilder: (context, index) {
                      final achievement = allAchievements[index];
                      final isUnlocked = userAchievements.contains(achievement['name']);
                      final isSelected = _selectedAchievementIndex == index;
                      
                      return Column(
                        children: [
                          Card(
                            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: isSelected ? 4 : 1,
                            child: InkWell(
                              onTap: () => _selectAchievement(index),
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: isUnlocked
                                                ? Colors.amber.withOpacity(0.2)
                                                : Theme.of(context).disabledColor.withOpacity(0.1),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              IconData(
                                                Icons.emoji_events.codePoint,
                                                fontFamily: Icons.emoji_events.fontFamily,
                                              ),
                                              size: 32,
                                              color: isUnlocked
                                                  ? Colors.amber
                                                  : Theme.of(context).disabledColor,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                achievement['name'] as String,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: isUnlocked
                                                      ? TextThemeHelper.bodyText1Color(context)
                                                      : TextThemeHelper.captionColor(context),
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                achievement['description'] as String,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: isUnlocked
                                                      ? TextThemeHelper.captionColor(context)
                                                      : TextThemeHelper.captionColor(context)?.withOpacity(0.7) ?? Colors.grey.withOpacity(0.7),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          isSelected ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                          color: TextThemeHelper.captionColor(context),
                                        ),
                                      ],
                                    ),
                                    
                                    // Achievement details (expanded when selected)
                                    if (isSelected)
                                      FadeTransition(
                                        opacity: _fadeAnimation,
                                        child: Container(
                                          margin: EdgeInsets.only(top: 16),
                                          padding: EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).scaffoldBackgroundColor,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                              color: Theme.of(context).dividerColor,
                                              width: 1,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.info_outline,
                                                    size: 20,
                                                    color: TextThemeHelper.captionColor(context),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    'Achievement Details',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 12),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        _buildDetailItem(
                                                          icon: Icons.star,
                                                          label: 'Difficulty',
                                                          value: 'Medium',
                                                        ),
                                                        SizedBox(height: 12),
                                                        _buildDetailItem(
                                                          icon: Icons.emoji_events,
                                                          label: 'Status',
                                                          value: isUnlocked ? 'Unlocked' : 'Locked',
                                                          valueColor: isUnlocked 
                                                              ? Colors.green 
                                                              : TextThemeHelper.errorColor(context),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        _buildDetailItem(
                                                          icon: Icons.military_tech,
                                                          label: 'Reward',
                                                          value: '+50 points',
                                                        ),
                                                        SizedBox(height: 12),
                                                        _buildDetailItem(
                                                          icon: Icons.calendar_today,
                                                          label: isUnlocked ? 'Achieved' : 'Requirement',
                                                          value: isUnlocked ? 'Today' : 'In progress',
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              if (isUnlocked) ...[
                                                SizedBox(height: 16),
                                                Center(
                                                  child: Container(
                                                    height: 80,
                                                    child: Lottie.network(
                                                      'https://assets10.lottiefiles.com/packages/lf20_touohxv0.json',
                                                      repeat: true,
                                                      animate: true,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: TextThemeHelper.captionColor(context),
        ),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: TextThemeHelper.captionColor(context),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
} 