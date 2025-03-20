import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../models/app_state.dart';
import '../models/quiz_question.dart';
import '../data/language_data.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with SingleTickerProviderStateMixin {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _answeredCorrectly = false;
  bool _answered = false;
  String? _selectedOption;
  late AnimationController _animationController;
  late Animation<double> _animation;
  Timer? _timer;
  int _timeLeft = 15; // 15 seconds per question
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
    _startTimer();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }
  
  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _timeLeft = 15;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        // Time's up, move to next question
        _timer?.cancel();
        if (!_answered) {
          _checkAnswer('');
        }
      }
    });
  }
  
  void _checkAnswer(String selectedOption) {
    final appState = Provider.of<AppState>(context, listen: false);
    final selectedLanguage = appState.selectedLanguage;
    final questions = LanguageData.quizQuestionsByLanguage[selectedLanguage] ?? [];
    
    if (questions.isEmpty || _currentQuestionIndex >= questions.length) {
      return;
    }
    
    final currentQuestion = questions[_currentQuestionIndex];
    final isCorrect = selectedOption == currentQuestion.answer;
    
    setState(() {
      _selectedOption = selectedOption;
      _answered = true;
      _answeredCorrectly = isCorrect;
      
      if (isCorrect) {
        _score++;
        // Add more points for harder questions and faster answers
        final difficultyPoints = currentQuestion.difficulty * 5;
        final timeBonus = _timeLeft > 10 ? 5 : (_timeLeft > 5 ? 3 : 1);
        final points = 10 + difficultyPoints + timeBonus;
        
        appState.updateUserScore(points);
        appState.updateUserProgress(0.02);
        
        // Check for perfect quiz achievement
        if (_score == questions.length) {
          appState.addAchievement('Perfect Quiz');
        }
      }
    });
    
    // Pause for a moment to show the result, then move to next question
    _timer?.cancel();
    Timer(Duration(seconds: 1), () {
      if (_currentQuestionIndex < questions.length - 1) {
        setState(() {
          _currentQuestionIndex++;
          _answered = false;
          _selectedOption = null;
          _animationController.reset();
          _animationController.forward();
        });
        _startTimer();
      } else {
        // Quiz complete
        _showQuizCompleteDialog();
      }
    });
  }
  
  void _resetQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
      _answered = false;
      _selectedOption = null;
      _animationController.reset();
      _animationController.forward();
    });
    _startTimer();
  }
  
  void _showQuizCompleteDialog() {
    _timer?.cancel();
    final appState = Provider.of<AppState>(context, listen: false);
    final selectedLanguage = appState.selectedLanguage;
    final questions = LanguageData.quizQuestionsByLanguage[selectedLanguage] ?? [];
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Quiz Complete!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _score >= questions.length / 2 
                    ? (_score == questions.length ? Icons.emoji_events : Icons.thumb_up)
                    : Icons.sentiment_neutral,
                color: _score >= questions.length / 2 
                    ? (_score == questions.length ? Colors.amber : Colors.green)
                    : Colors.orange,
                size: 64,
              ),
              SizedBox(height: 16),
              Text(
                'You scored $_score out of ${questions.length}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                _score == questions.length
                    ? 'Perfect! You\'ve mastered this set!'
                    : (_score >= questions.length / 2 
                        ? 'Good job! Keep practicing to improve.'
                        : 'Keep practicing to improve your score.'),
                style: TextStyle(
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('Exit'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _resetQuiz();
              },
              child: Text('Try Again'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final selectedLanguage = appState.selectedLanguage;
    final questions = LanguageData.quizQuestionsByLanguage[selectedLanguage] ?? [];
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Challenge'),
        elevation: 0,
      ),
      body: questions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.quiz,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No quiz questions available yet for $selectedLanguage',
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
                    // Progress and timer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Question ${_currentQuestionIndex + 1}/${questions.length}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.timer,
                              size: 20,
                              color: _timeLeft <= 5 ? Colors.red : null,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '$_timeLeft s',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: _timeLeft <= 5 ? Colors.red : null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: (_currentQuestionIndex + 1) / questions.length,
                      backgroundColor: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                      minHeight: 8,
                    ),
                    SizedBox(height: 24),
                    
                    // Score
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.emoji_events,
                            color: Colors.amber,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Score: $_score',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32),
                    
                    // Question
                    FadeTransition(
                      opacity: _animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.05, 0),
                          end: Offset.zero,
                        ).animate(_animation),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Text(
                                  questions[_currentQuestionIndex].question,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 16),
                                if (questions[_currentQuestionIndex].imageUrl != null)
                                  Container(
                                    height: 120,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.grey[200],
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.image,
                                        size: 48,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    
                    // Options
                    Expanded(
                      child: FadeTransition(
                        opacity: _animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.05),
                            end: Offset.zero,
                          ).animate(_animation),
                          child: ListView.builder(
                            itemCount: questions[_currentQuestionIndex].options.length,
                            itemBuilder: (context, index) {
                              final option = questions[_currentQuestionIndex].options[index];
                              final isSelected = _selectedOption == option;
                              final isCorrectAnswer = option == questions[_currentQuestionIndex].answer;
                              
                              // Determine the option color based on state
                              Color? optionColor;
                              if (_answered) {
                                if (isCorrectAnswer) {
                                  optionColor = Colors.green;
                                } else if (isSelected && !isCorrectAnswer) {
                                  optionColor = Colors.red;
                                }
                              }
                              
                              return Container(
                                margin: EdgeInsets.only(bottom: 12),
                                child: Material(
                                  color: optionColor != null 
                                      ? optionColor.withOpacity(0.2) 
                                      : (isSelected ? Theme.of(context).primaryColor.withOpacity(0.2) : null),
                                  borderRadius: BorderRadius.circular(12),
                                  child: InkWell(
                                    onTap: _answered ? null : () => _checkAnswer(option),
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: optionColor ?? (isSelected ? Theme.of(context).primaryColor : Colors.grey.withOpacity(0.3)),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              option,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                                color: optionColor,
                                              ),
                                            ),
                                          ),
                                          if (_answered && isCorrectAnswer)
                                            Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                            )
                                          else if (_answered && isSelected && !isCorrectAnswer)
                                            Icon(
                                              Icons.cancel,
                                              color: Colors.red,
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
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
} 