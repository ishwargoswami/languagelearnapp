import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../models/app_state.dart';
import '../main.dart'; // Import for TextThemeHelper

class StatsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final userData = appState.userData;
    final selectedLanguage = appState.selectedLanguage;
    final level = userData.getLanguageLevel(selectedLanguage);
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        'Lv${level}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedLanguage,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'Progress to Lv${level + 1}',
                          style: TextStyle(
                            fontSize: 12,
                            color: TextThemeHelper.captionColor(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: TextThemeHelper.captionColor(context),
                ),
              ],
            ),
            SizedBox(height: 16),
            LinearProgressIndicator(
              value: userData.progressPercentage,
              backgroundColor: Theme.of(context).disabledColor.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
              borderRadius: BorderRadius.circular(4),
              minHeight: 8,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context,
                  icon: Icons.emoji_events,
                  value: userData.totalScore.toString(),
                  label: 'Score',
                  color: Colors.amber,
                ),
                _buildStatItem(
                  context,
                  icon: Icons.local_fire_department,
                  value: userData.streak.toString(),
                  label: 'Day Streak',
                  color: Colors.orange,
                ),
                _buildStatItem(
                  context,
                  icon: Icons.star,
                  value: userData.achievements.length.toString(),
                  label: 'Achievements',
                  color: Colors.purple,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: TextThemeHelper.captionColor(context),
          ),
        ),
      ],
    );
  }
} 