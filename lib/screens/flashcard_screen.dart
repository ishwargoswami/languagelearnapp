import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../models/app_state.dart';
import '../models/flashcard.dart';
import '../data/language_data.dart';
import '../services/tts_service.dart';
import '../main.dart'; // Import for TextThemeHelper

class FlashcardScreen extends StatefulWidget {
  @override
  _FlashcardScreenState createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> with SingleTickerProviderStateMixin {
  int _currentCardIndex = 0;
  bool _isFlipped = false;
  late AnimationController _animationController;
  late Animation<double> _frontRotation;
  late Animation<double> _backRotation;
  bool _isDragging = false;
  double _dragOffset = 0.0;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _frontRotation = TweenSequence<double>([
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.0, end: pi / 2)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50.0,
      ),
      TweenSequenceItem<double>(
        tween: ConstantTween<double>(pi / 2),
        weight: 50.0,
      ),
    ]).animate(_animationController);
    
    _backRotation = TweenSequence<double>([
      TweenSequenceItem<double>(
        tween: ConstantTween<double>(pi / 2),
        weight: 50.0,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: -pi / 2, end: 0.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50.0,
      ),
    ]).animate(_animationController);
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  void _flipCard() {
    if (_isFlipped) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
    
    setState(() {
      _isFlipped = !_isFlipped;
    });
  }
  
  void _nextCard() {
    final appState = Provider.of<AppState>(context, listen: false);
    final selectedLanguage = appState.selectedLanguage;
    final cards = LanguageData.flashcardsByLanguage[selectedLanguage] ?? [];
    
    if (cards.isEmpty) return;
    
    if (_isFlipped) {
      _animationController.reverse();
    }
    
    setState(() {
      _currentCardIndex = (_currentCardIndex + 1) % cards.length;
      _isFlipped = false;
    });
    
    // Update progress
    appState.updateUserProgress(0.01);
    appState.updateUserScore(1);
  }
  
  void _previousCard() {
    final appState = Provider.of<AppState>(context, listen: false);
    final selectedLanguage = appState.selectedLanguage;
    final cards = LanguageData.flashcardsByLanguage[selectedLanguage] ?? [];
    
    if (cards.isEmpty) return;
    
    if (_isFlipped) {
      _animationController.reverse();
    }
    
    setState(() {
      _currentCardIndex = (_currentCardIndex - 1 + cards.length) % cards.length;
      _isFlipped = false;
    });
  }
  
  void _speakWord() {
    final appState = Provider.of<AppState>(context, listen: false);
    final ttsService = Provider.of<TtsService>(context, listen: false);
    final selectedLanguage = appState.selectedLanguage;
    final cards = LanguageData.flashcardsByLanguage[selectedLanguage] ?? [];
    
    if (cards.isEmpty) return;
    
    ttsService.speak(
      cards[_currentCardIndex].word,
      appState.getSelectedLanguageObj().code,
    );
    
    // Update progress and score
    appState.updateUserScore(1);
    
    // Check for pronunciation achievement
    if (appState.userData.achievements.contains('Pronunciation Pro')) {
      appState.addAchievement('Pronunciation Pro');
    }
  }
  
  void _onDragStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
      _dragOffset = 0.0;
    });
  }
  
  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta.dx;
    });
  }
  
  void _onDragEnd(DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond.dx;
    final appState = Provider.of<AppState>(context, listen: false);
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Check if swipe was strong enough or far enough
    if (_dragOffset.abs() > screenWidth * 0.3 || velocity.abs() > 500) {
      if (_dragOffset > 0) {
        // Swiped right - previous card
        _previousCard();
      } else {
        // Swiped left - next card
        _nextCard();
      }
    }
    
    setState(() {
      _isDragging = false;
      _dragOffset = 0.0;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final selectedLanguage = appState.selectedLanguage;
    final cards = LanguageData.flashcardsByLanguage[selectedLanguage] ?? [];
    
    // Calculate rotation and translation based on drag
    final double rotationFactor = _isDragging ? _dragOffset / 800 : 0.0;
    final double translationX = _isDragging ? _dragOffset : 0.0;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Flashcards'),
        elevation: 0,
      ),
      body: cards.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.style,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No flashcards available yet for $selectedLanguage',
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Progress indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Card ${_currentCardIndex + 1} of ${cards.length}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: (_currentCardIndex + 1) / cards.length,
                      backgroundColor: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                      minHeight: 8,
                    ),
                    SizedBox(height: 32),
                    
                    // Flashcard
                    Expanded(
                      child: GestureDetector(
                        onTap: _flipCard,
                        onHorizontalDragStart: _onDragStart,
                        onHorizontalDragUpdate: _onDragUpdate,
                        onHorizontalDragEnd: _onDragEnd,
                        child: Center(
                          child: Transform(
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateY(rotationFactor)
                              ..translate(translationX),
                            alignment: Alignment.center,
                            child: Stack(
                              children: [
                                // Front of card (word)
                                AnimatedBuilder(
                                  animation: _frontRotation,
                                  builder: (context, child) {
                                    return Transform(
                                      transform: Matrix4.identity()
                                        ..setEntry(3, 2, 0.001)
                                        ..rotateY(_frontRotation.value),
                                      alignment: Alignment.center,
                                      child: child,
                                    );
                                  },
                                  child: Visibility(
                                    visible: _frontRotation.value < pi / 2,
                                    child: Container(
                                      width: double.infinity,
                                      height: 350,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            blurRadius: 10,
                                            offset: Offset(0, 5),
                                          ),
                                        ],
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Theme.of(context).primaryColor.withOpacity(0.1),
                                            Theme.of(context).primaryColor.withOpacity(0.2),
                                          ],
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(24.0),
                                            child: Text(
                                              cards[_currentCardIndex].word,
                                              style: TextStyle(
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          SizedBox(height: 32),
                                          Text(
                                            'Tap to reveal translation',
                                            style: TextStyle(
                                              color: TextThemeHelper.captionColor(context),
                                              fontSize: 14,
                                            ),
                                          ),
                                          Icon(
                                            Icons.touch_app,
                                            color: TextThemeHelper.captionColor(context),
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                
                                // Back of card (translation and example)
                                AnimatedBuilder(
                                  animation: _backRotation,
                                  builder: (context, child) {
                                    return Transform(
                                      transform: Matrix4.identity()
                                        ..setEntry(3, 2, 0.001)
                                        ..rotateY(_backRotation.value),
                                      alignment: Alignment.center,
                                      child: child,
                                    );
                                  },
                                  child: Visibility(
                                    visible: _backRotation.value > -pi / 2 && _backRotation.value <= 0,
                                    child: Container(
                                      width: double.infinity,
                                      height: 350,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.1),
                                            blurRadius: 10,
                                            offset: Offset(0, 5),
                                          ),
                                        ],
                                        gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                          colors: [
                                            Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                                            Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                                          ],
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(24.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              cards[_currentCardIndex].translation,
                                              style: TextStyle(
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(height: 24),
                                            if (cards[_currentCardIndex].example != null) ...[
                                              Container(
                                                padding: EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                                                  ),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Example:',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 14,
                                                        color: Theme.of(context).colorScheme.secondary,
                                                      ),
                                                    ),
                                                    SizedBox(height: 8),
                                                    Text(
                                                      cards[_currentCardIndex].example!,
                                                      style: TextStyle(
                                                        fontStyle: FontStyle.italic,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                            SizedBox(height: 24),
                                            Text(
                                              'Tap to flip back',
                                              style: TextStyle(
                                                color: TextThemeHelper.captionColor(context),
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 32),
                    
                    // Control buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios_rounded),
                          onPressed: _previousCard,
                          iconSize: 28,
                          tooltip: 'Previous card',
                          color: Theme.of(context).primaryColor,
                        ),
                        FloatingActionButton(
                          onPressed: _speakWord,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Icon(Icons.volume_up),
                          tooltip: 'Listen to pronunciation',
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_forward_ios_rounded),
                          onPressed: _nextCard,
                          iconSize: 28,
                          tooltip: 'Next card',
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Hint
                    Center(
                      child: Text(
                        'Swipe left or right to navigate between cards',
                        style: TextStyle(
                          color: TextThemeHelper.captionColor(context),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
} 