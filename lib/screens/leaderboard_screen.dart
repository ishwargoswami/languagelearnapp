import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'package:confetti/confetti.dart';

import '../models/app_state.dart';
import '../data/language_data.dart';
import '../main.dart'; // Import for TextThemeHelper

class LeaderboardScreen extends StatefulWidget {
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  bool _showGlobal = true;
  bool _filterByLanguage = false;
  late ConfettiController _confettiController;
  
  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: Duration(seconds: 2));
    
    // Check if user is on the leaderboard and play confetti
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = Provider.of<AppState>(context, listen: false);
      final userData = appState.userData;
      
      if (userData.totalScore > 0) {
        int userRank = _getUserRank(userData.totalScore);
        if (userRank <= 10) {
          _confettiController.play();
        }
      }
    });
  }
  
  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }
  
  int _getUserRank(int userScore) {
    final leaderboard = LanguageData.leaderboard;
    int rank = 1;
    
    for (var userData in leaderboard) {
      if (userScore < userData['score']) {
        rank++;
      }
    }
    
    return rank;
  }
  
  List<Map<String, dynamic>> _getFilteredLeaderboard() {
    final appState = Provider.of<AppState>(context, listen: false);
    final List<Map<String, dynamic>> leaderboard = List.from(LanguageData.leaderboard);
    final userData = appState.userData;
    
    // Add current user to list
    if (userData.totalScore > 0) {
      leaderboard.add({
        'name': 'You',
        'score': userData.totalScore,
        'streak': userData.streak,
        'language': appState.selectedLanguage,
        'isCurrentUser': true,
      });
    }
    
    // Sort by score
    leaderboard.sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));
    
    // Filter by language if needed
    if (_filterByLanguage) {
      return leaderboard.where((user) => 
        user['language'] == appState.selectedLanguage
      ).toList();
    }
    
    return leaderboard;
  }
  
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final filteredLeaderboard = _getFilteredLeaderboard();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_filterByLanguage ? Icons.language : Icons.public),
            onPressed: () {
              setState(() {
                _filterByLanguage = !_filterByLanguage;
              });
            },
            tooltip: _filterByLanguage 
                ? 'Showing ${appState.selectedLanguage} learners' 
                : 'Showing all learners',
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Leaderboard tabs
              Container(
                color: Theme.of(context).primaryColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _showGlobal = true;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _showGlobal 
                                ? Colors.white 
                                : Theme.of(context).primaryColor,
                            foregroundColor: _showGlobal 
                                ? Theme.of(context).primaryColor 
                                : Colors.white,
                            elevation: _showGlobal ? 2 : 0,
                            side: BorderSide(
                              color: Colors.white,
                              width: 1,
                            ),
                          ),
                          child: Text('Global'),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _showGlobal = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: !_showGlobal 
                                ? Colors.white 
                                : Theme.of(context).primaryColor,
                            foregroundColor: !_showGlobal 
                                ? Theme.of(context).primaryColor 
                                : Colors.white,
                            elevation: !_showGlobal ? 2 : 0,
                            side: BorderSide(
                              color: Colors.white,
                              width: 1,
                            ),
                          ),
                          child: Text('Friends'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Leaderboard visualization
              if (_showGlobal && filteredLeaderboard.isNotEmpty)
                Container(
                  height: 200,
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(
                      math.min(5, filteredLeaderboard.length),
                      (index) {
                        final user = filteredLeaderboard[index];
                        final isCurrentUser = user.containsKey('isCurrentUser');
                        final maxScore = filteredLeaderboard.first['score'].toDouble();
                        final score = user['score'].toDouble();
                        final heightPercentage = score / maxScore;
                        
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${score.toInt()}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isCurrentUser ? Theme.of(context).primaryColor : null,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              width: 40,
                              height: 120.0 * heightPercentage,
                              decoration: BoxDecoration(
                                color: isCurrentUser 
                                    ? Theme.of(context).primaryColor
                                    : index == 0
                                        ? Colors.amber
                                        : index == 1
                                            ? Colors.grey[400]
                                            : index == 2
                                                ? Colors.brown[300]
                                                : Theme.of(context).primaryColor.withOpacity(0.7),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(6),
                                  topRight: Radius.circular(6),
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              user['name'].toString().length > 6 
                                  ? '${user['name'].toString().substring(0, 6)}...'
                                  : user['name'].toString(),
                              style: TextStyle(
                                fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
                                color: isCurrentUser ? Theme.of(context).primaryColor : null,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              
              // Leaderboard list
              Expanded(
                child: filteredLeaderboard.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.leaderboard,
                              size: 80,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              _filterByLanguage
                                  ? 'No learners for ${appState.selectedLanguage} yet'
                                  : 'No learners yet',
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
                        padding: EdgeInsets.only(bottom: 16),
                        itemCount: filteredLeaderboard.length,
                        itemBuilder: (context, index) {
                          final user = filteredLeaderboard[index];
                          final isCurrentUser = user.containsKey('isCurrentUser');
                          
                          return Card(
                            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: isCurrentUser
                                  ? BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 2,
                                    )
                                  : BorderSide.none,
                            ),
                            elevation: isCurrentUser ? 4 : 1,
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: index < 3
                                      ? index == 0
                                          ? Colors.amber.withOpacity(0.2)
                                          : index == 1
                                              ? Colors.grey[300]
                                              : Colors.brown[100]
                                      : Theme.of(context).disabledColor.withOpacity(0.1),
                                ),
                                child: Center(
                                  child: index < 3
                                      ? Icon(
                                          Icons.emoji_events,
                                          color: index == 0
                                              ? Colors.amber
                                              : index == 1
                                                  ? Colors.grey[600]
                                                  : Colors.brown,
                                        )
                                      : Text(
                                          '${index + 1}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: TextThemeHelper.bodyText1Color(context),
                                          ),
                                        ),
                                ),
                              ),
                              title: Row(
                                children: [
                                  Text(
                                    user['name'] as String,
                                    style: TextStyle(
                                      fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                  if (isCurrentUser)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        '(You)',
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: TextThemeHelper.captionColor(context),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              subtitle: Row(
                                children: [
                                  Icon(
                                    Icons.language,
                                    size: 14,
                                    color: TextThemeHelper.captionColor(context),
                                  ),
                                  SizedBox(width: 4),
                                  Text(user['language'] as String),
                                ],
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${user['score']} pts',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.local_fire_department,
                                        size: 14,
                                        color: Colors.orange,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        '${user['streak']} day streak',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
          
          // Confetti effect
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.2,
              shouldLoop: false,
              colors: [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
              ],
            ),
          ),
        ],
      ),
    );
  }
} 