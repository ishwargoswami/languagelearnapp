import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:math' as math;

import '../models/app_state.dart';
import '../models/flashcard.dart';
import '../data/language_data.dart';
import '../services/tts_service.dart';
import '../widgets/language_selector.dart';
import '../main.dart'; // Import for TextThemeHelper

class PronunciationScreen extends StatefulWidget {
  @override
  _PronunciationScreenState createState() => _PronunciationScreenState();
}

class _PronunciationScreenState extends State<PronunciationScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _practiceCount = 0;
  int? _selectedCardIndex;
  bool _isPlaying = false;
  Timer? _soundWaveTimer;
  List<double> _soundWaveHeights = List.generate(30, (_) => 0.1);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _soundWaveTimer?.cancel();
    super.dispose();
  }

  void _speakWord(Flashcard card, String languageCode) {
    final ttsService = Provider.of<TtsService>(context, listen: false);
    final appState = Provider.of<AppState>(context, listen: false);

    setState(() {
      _isPlaying = true;
    });

    // Animate sound waves while speaking
    _soundWaveTimer?.cancel();
    _soundWaveTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        for (int i = 0; i < _soundWaveHeights.length; i++) {
          _soundWaveHeights[i] = 0.1 + (0.9 * (i % 2 == 0 ? 1 : 0.5)) * 
                                 (0.5 + 0.5 * math.sin((timer.tick + i) * 0.2));
        }
      });
    });

    ttsService.speak(card.word, languageCode).then((_) {
      setState(() {
        _practiceCount++;
        _isPlaying = false;
      });
      _soundWaveTimer?.cancel();
      
      // Reset sound wave heights
      setState(() {
        _soundWaveHeights = List.generate(30, (_) => 0.1);
      });
      
      // Update progress and score
      appState.updateUserScore(2);
      appState.updateUserProgress(0.01);
      
      // Check pronunciation achievement
      if (_practiceCount >= 20 && !appState.userData.achievements.contains('Pronunciation Pro')) {
        appState.addAchievement('Pronunciation Pro');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final selectedLanguage = appState.selectedLanguage;
    final languageCode = appState.getSelectedLanguageObj().code;
    final cards = LanguageData.flashcardsByLanguage[selectedLanguage] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Pronunciation Practice'),
        elevation: 0,
      ),
      body: cards.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.record_voice_over,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No vocabulary available yet for $selectedLanguage',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Go Back'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Improve Your Pronunciation',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tap on any word to hear its pronunciation. Then practice saying it yourself.',
                      style: TextStyle(
                        fontSize: 14,
                        color: TextThemeHelper.captionColor(context),
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    // Practice count
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.celebration,
                            color: Theme.of(context).primaryColor,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Words Practiced: $_practiceCount',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    
                    // Sound waves visualization (shows when playing)
                    if (_isPlaying && _selectedCardIndex != null) ...[
                      Container(
                        height: 120,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: List.generate(
                            _soundWaveHeights.length, 
                            (index) => Container(
                              margin: EdgeInsets.symmetric(horizontal: 1),
                              width: 5,
                              height: _soundWaveHeights[index] * 100,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Center(
                        child: Text(
                          cards[_selectedCardIndex!].word,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 8),
                      Center(
                        child: Text(
                          cards[_selectedCardIndex!].translation,
                          style: TextStyle(
                            fontSize: 16,
                            color: TextThemeHelper.bodyText2Color(context),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 24),
                    ],
                    
                    // Word list
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.5,
                        ),
                        itemCount: cards.length,
                        itemBuilder: (context, index) {
                          final card = cards[index];
                          final isSelected = _selectedCardIndex == index;
                          
                          return AnimatedScale(
                            scale: isSelected && _isPlaying ? 1.05 : 1.0,
                            duration: Duration(milliseconds: 300),
                            child: Card(
                              elevation: isSelected ? 4 : 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(
                                  color: isSelected 
                                      ? Theme.of(context).primaryColor 
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: InkWell(
                                onTap: _isPlaying
                                    ? null
                                    : () {
                                        setState(() {
                                          _selectedCardIndex = index;
                                        });
                                        _speakWord(card, languageCode);
                                      },
                                borderRadius: BorderRadius.circular(16),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        card.word,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        card.translation,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: TextThemeHelper.captionColor(context),
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 8),
                                      Icon(
                                        Icons.volume_up,
                                        size: 18,
                                        color: Theme.of(context).primaryColor.withOpacity(
                                          isSelected && _isPlaying ? 1.0 : 0.5
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Achievement progress
                    LinearProgressIndicator(
                      value: _practiceCount / 20,
                      backgroundColor: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                      minHeight: 8,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Practice 20 times to earn the "Pronunciation Pro" achievement (${_practiceCount}/20)',
                      style: TextStyle(
                        fontSize: 12,
                        color: TextThemeHelper.captionColor(context),
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