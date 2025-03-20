import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(LanguageLearningApp());
}

class LanguageLearningApp extends StatefulWidget {
  @override
  _LanguageLearningAppState createState() => _LanguageLearningAppState();
}

class _LanguageLearningAppState extends State<LanguageLearningApp> {
  bool isDarkMode = false;
  String selectedLanguage = 'Spanish';
  int currentPage = 0;
  int streak = 0;
  int totalScore = 0;
  double progressPercentage = 0.0;
  List<String> achievements = [];
  FlutterTts flutterTts = FlutterTts();

  final List<Map<String, dynamic>> languages = [
    {'name': 'Spanish', 'code': 'es-ES'},
    {'name': 'French', 'code': 'fr-FR'},
    {'name': 'German', 'code': 'de-DE'},
    {'name': 'Italian', 'code': 'it-IT'},
    {'name': 'Japanese', 'code': 'ja-JP'},
  ];

  final Map<String, List<Map<String, dynamic>>> quizQuestionsByLanguage = {
    'Spanish': [
      {
        'question': 'What is the Spanish word for "Apple"?',
        'options': ['Manzana', 'Banana', 'Pera', 'Naranja'],
        'answer': 'Manzana'
      },
      {
        'question': 'What is the Spanish word for "Hello"?',
        'options': ['Hola', 'Adiós', 'Gracias', 'Buenos días'],
        'answer': 'Hola'
      },
      {
        'question': 'What is the Spanish word for "Thank you"?',
        'options': ['Gracias', 'Por favor', 'De nada', 'Lo siento'],
        'answer': 'Gracias'
      },
    ],
    'French': [
      {
        'question': 'What is the French word for "Hello"?',
        'options': ['Bonjour', 'Au revoir', 'Merci', 'S\'il vous plaît'],
        'answer': 'Bonjour'
      },
      {
        'question': 'What is the French word for "Goodbye"?',
        'options': ['Au revoir', 'Bonjour', 'Merci', 'Oui'],
        'answer': 'Au revoir'
      },
      {
        'question': 'What is the French word for "Yes"?',
        'options': ['Oui', 'Non', 'Peut-être', 'Merci'],
        'answer': 'Oui'
      },
    ],
    'German': [
      {
        'question': 'What is the German word for "Hello"?',
        'options': ['Hallo', 'Tschüss', 'Danke', 'Bitte'],
        'answer': 'Hallo'
      },
      {
        'question': 'What is the German word for "Please"?',
        'options': ['Bitte', 'Danke', 'Ja', 'Nein'],
        'answer': 'Bitte'
      },
    ],
    'Italian': [
      {
        'question': 'What is the Italian word for "Hello"?',
        'options': ['Ciao', 'Arrivederci', 'Grazie', 'Per favore'],
        'answer': 'Ciao'
      },
      {
        'question': 'What is the Italian word for "Thank you"?',
        'options': ['Grazie', 'Prego', 'Ciao', 'Sì'],
        'answer': 'Grazie'
      },
    ],
    'Japanese': [
      {
        'question': 'What is the Japanese word for "Hello"?',
        'options': ['こんにちは (Konnichiwa)', 'さようなら (Sayōnara)', 'ありがとう (Arigatō)', 'お願いします (Onegaishimasu)'],
        'answer': 'こんにちは (Konnichiwa)'
      },
      {
        'question': 'What is the Japanese word for "Thank you"?',
        'options': ['ありがとう (Arigatō)', 'こんにちは (Konnichiwa)', 'さようなら (Sayōnara)', 'はい (Hai)'],
        'answer': 'ありがとう (Arigatō)'
      },
    ],
  };

  final Map<String, List<Map<String, dynamic>>> flashcardsByLanguage = {
    'Spanish': [
      {'word': 'Manzana', 'translation': 'Apple'},
      {'word': 'Hola', 'translation': 'Hello'},
      {'word': 'Gracias', 'translation': 'Thank you'},
      {'word': 'Adiós', 'translation': 'Goodbye'},
      {'word': 'Agua', 'translation': 'Water'},
    ],
    'French': [
      {'word': 'Pomme', 'translation': 'Apple'},
      {'word': 'Bonjour', 'translation': 'Hello'},
      {'word': 'Merci', 'translation': 'Thank you'},
      {'word': 'Au revoir', 'translation': 'Goodbye'},
      {'word': 'Eau', 'translation': 'Water'},
    ],
    'German': [
      {'word': 'Apfel', 'translation': 'Apple'},
      {'word': 'Hallo', 'translation': 'Hello'},
      {'word': 'Danke', 'translation': 'Thank you'},
      {'word': 'Auf Wiedersehen', 'translation': 'Goodbye'},
      {'word': 'Wasser', 'translation': 'Water'},
    ],
    'Italian': [
      {'word': 'Mela', 'translation': 'Apple'},
      {'word': 'Ciao', 'translation': 'Hello'},
      {'word': 'Grazie', 'translation': 'Thank you'},
      {'word': 'Arrivederci', 'translation': 'Goodbye'},
      {'word': 'Acqua', 'translation': 'Water'},
    ],
    'Japanese': [
      {'word': 'りんご (Ringo)', 'translation': 'Apple'},
      {'word': 'こんにちは (Konnichiwa)', 'translation': 'Hello'},
      {'word': 'ありがとう (Arigatō)', 'translation': 'Thank you'},
      {'word': 'さようなら (Sayōnara)', 'translation': 'Goodbye'},
      {'word': '水 (Mizu)', 'translation': 'Water'},
    ],
  };

  final List<Map<String, dynamic>> leaderboard = [
    {'name': 'Sarah', 'score': 980, 'streak': 45},
    {'name': 'Michael', 'score': 850, 'streak': 30},
    {'name': 'Emma', 'score': 790, 'streak': 25},
    {'name': 'James', 'score': 720, 'streak': 20},
    {'name': 'Olivia', 'score': 650, 'streak': 18},
  ];

  int currentQuestionIndex = 0;
  int quizScore = 0;
  int currentFlashcardIndex = 0;
  bool isFlipped = false;

  @override
  void initState() {
    super.initState();
    setupTts();
    loadUserData();
    checkDailyStreak();
  }

  void setupTts() async {
    await flutterTts.setLanguage(getLanguageCode());
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
  }

  void loadUserData() async {
    // This would normally load from SharedPreferences
    setState(() {
      streak = 3;
      totalScore = 150;
      progressPercentage = 0.35;
      achievements = ['First Word', 'Perfect Quiz'];
    });
  }

  void checkDailyStreak() {
    // Logic to check if user has practiced today
    // Would normally use SharedPreferences to store last login date
  }

  String getLanguageCode() {
    return languages.firstWhere((lang) => lang['name'] == selectedLanguage)['code'];
  }

  void changeLanguage(String language) {
    setState(() {
      selectedLanguage = language;
      currentQuestionIndex = 0;
      currentFlashcardIndex = 0;
      quizScore = 0;
    });
    setupTts();
  }

  void checkAnswer(String selectedOption) {
    final questions = quizQuestionsByLanguage[selectedLanguage] ?? [];
    if (questions.isNotEmpty && currentQuestionIndex < questions.length &&
        selectedOption == questions[currentQuestionIndex]['answer']) {
      setState(() {
        quizScore++;
        totalScore += 10;
      });
      updateProgress();
      checkAchievements();
    }

    final questionsList = quizQuestionsByLanguage[selectedLanguage] ?? [];
    if (currentQuestionIndex < questionsList.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      // Quiz completed
      setState(() {
        currentQuestionIndex = 0;
      });
    }
  }

  void nextFlashcard() {
    final cards = flashcardsByLanguage[selectedLanguage] ?? [];
    setState(() {
      if (currentFlashcardIndex < cards.length - 1) {
        currentFlashcardIndex++;
      } else {
        currentFlashcardIndex = 0;
      }
      isFlipped = false;
    });
  }

  void previousFlashcard() {
    final cards = flashcardsByLanguage[selectedLanguage] ?? [];
    setState(() {
      if (currentFlashcardIndex > 0) {
        currentFlashcardIndex--;
      } else {
        currentFlashcardIndex = cards.length - 1;
      }
      isFlipped = false;
    });
  }

  void flipFlashcard() {
    setState(() {
      isFlipped = !isFlipped;
    });
  }

  void speak(String text) async {
    await flutterTts.setLanguage(getLanguageCode());
    await flutterTts.speak(text);
    // Add to progress after practicing pronunciation
    totalScore += 2;
    updateProgress();
  }

  void updateProgress() {
    setState(() {
      progressPercentage = min(1.0, progressPercentage + 0.02);
    });
  }

  void checkAchievements() {
    // Logic to check and award achievements
    final questions = quizQuestionsByLanguage[selectedLanguage] ?? [];
    if (questions.isNotEmpty && quizScore == questions.length && !achievements.contains('Perfect Quiz')) {
      setState(() {
        achievements.add('Perfect Quiz');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light().copyWith(
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.orange,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Language Learning App'),
          actions: [
            IconButton(
              icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
              onPressed: () {
                setState(() {
                  isDarkMode = !isDarkMode;
                });
              },
            )
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.blueGrey[800] : Colors.blue,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Language Learning',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Select a language:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              ...languages.map((language) => ListTile(
                title: Text(language['name']),
                selected: selectedLanguage == language['name'],
                onTap: () {
                  changeLanguage(language['name']);
                  Navigator.pop(context);
                },
              )).toList(),
              Divider(),
              ListTile(
                leading: Icon(Icons.leaderboard),
                title: Text('Leaderboard'),
                onTap: () {
                  setState(() {
                    currentPage = 3;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.emoji_events),
                title: Text('Achievements'),
                onTap: () {
                  setState(() {
                    currentPage = 4;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // User Stats
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.blueGrey[700] : Colors.blue[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text('Score', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('$totalScore', style: TextStyle(fontSize: 18)),
                        ],
                      ),
                      Column(
                        children: [
                          Text('Streak', style: TextStyle(fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              Icon(Icons.local_fire_department, color: Colors.orange),
                              Text('$streak days', style: TextStyle(fontSize: 18)),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text('Progress', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 5),
                          SizedBox(
                            width: 80,
                            child: LinearProgressIndicator(
                              value: progressPercentage,
                              backgroundColor: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                
                // Navigation Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(Icons.quiz),
                      label: Text('Quiz'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: currentPage == 0 ? Colors.blue : null,
                        foregroundColor: currentPage == 0 ? Colors.white : null,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      onPressed: () {
                        setState(() {
                          currentPage = 0;
                        });
                      },
                    ),
                    ElevatedButton.icon(
                      icon: Icon(Icons.flip),
                      label: Text('Flashcards'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: currentPage == 1 ? Colors.blue : null,
                        foregroundColor: currentPage == 1 ? Colors.white : null,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      onPressed: () {
                        setState(() {
                          currentPage = 1;
                        });
                      },
                    ),
                    ElevatedButton.icon(
                      icon: Icon(Icons.volume_up),
                      label: Text('Audio'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: currentPage == 2 ? Colors.blue : null,
                        foregroundColor: currentPage == 2 ? Colors.white : null,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      onPressed: () {
                        setState(() {
                          currentPage = 2;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                
                // Main Content Area
                if (currentPage == 0) ...[
                  // Quiz Section
                  Text(
                    'Quiz: ${selectedLanguage} Words',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        if (quizQuestionsByLanguage[selectedLanguage] != null && 
                            quizQuestionsByLanguage[selectedLanguage]!.isNotEmpty) ...[
                          Text(
                            quizQuestionsByLanguage[selectedLanguage]![currentQuestionIndex]['question'] as String,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          ...(quizQuestionsByLanguage[selectedLanguage]![currentQuestionIndex]['options'] as List<dynamic>).map<Widget>((option) {
                            return Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(bottom: 10),
                              child: ElevatedButton(
                                onPressed: () => checkAnswer(option as String),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: Text(option as String),
                              ),
                            );
                          }).toList(),
                          SizedBox(height: 10),
                          Text('Score: $quizScore / ${quizQuestionsByLanguage[selectedLanguage]?.length ?? 0}', 
                               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ] else ...[
                          Text(
                            "No quiz questions available for this language yet.",
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                  ),
                ] else if (currentPage == 1) ...[
                  // Flashcards Section
                  Text(
                    'Flashcards: ${selectedLanguage} Words',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),
                  if (flashcardsByLanguage[selectedLanguage] != null && 
                      flashcardsByLanguage[selectedLanguage]!.isNotEmpty) ...[
                    GestureDetector(
                      onTap: flipFlashcard,
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.blueGrey[700] : Colors.blue[100],
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            isFlipped 
                                ? flashcardsByLanguage[selectedLanguage]![currentFlashcardIndex]['translation'] as String
                                : flashcardsByLanguage[selectedLanguage]![currentFlashcardIndex]['word'] as String,
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          icon: Icon(Icons.arrow_back),
                          label: Text('Previous'),
                          onPressed: previousFlashcard,
                        ),
                        SizedBox(width: 20),
                        ElevatedButton.icon(
                          icon: Icon(Icons.volume_up),
                          label: Text('Hear it'),
                          onPressed: () => speak(flashcardsByLanguage[selectedLanguage]![currentFlashcardIndex]['word'] as String),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton.icon(
                          icon: Icon(Icons.arrow_forward),
                          label: Text('Next'),
                          onPressed: nextFlashcard,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text('Card ${currentFlashcardIndex + 1} of ${flashcardsByLanguage[selectedLanguage]?.length ?? 0}',
                         style: TextStyle(fontSize: 16)),
                  ] else ...[
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.blueGrey[700] : Colors.blue[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          "No flashcards available for this language yet.",
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ] else if (currentPage == 2) ...[
                  // Audio Pronunciation Section
                  Text(
                    'Audio Pronunciation: ${selectedLanguage}',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Practice pronunciation with text-to-speech',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        if (flashcardsByLanguage[selectedLanguage] != null)
                          ...flashcardsByLanguage[selectedLanguage]!.map((item) => 
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(bottom: 10),
                              child: ListTile(
                                title: Text(item['word'] as String),
                                subtitle: Text(item['translation'] as String),
                                trailing: IconButton(
                                  icon: Icon(Icons.volume_up),
                                  onPressed: () => speak(item['word'] as String),
                                ),
                              ),
                            )
                          ).toList()
                        else
                          Center(
                            child: Text(
                              "No audio content available for this language yet.",
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ),
                  ),
                ] else if (currentPage == 3) ...[
                  // Leaderboard Section
                  Text(
                    'Leaderboard',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: Row(
                            children: [
                              Expanded(flex: 1, child: Text('Rank', style: TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(flex: 2, child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(flex: 1, child: Text('Score', style: TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(flex: 1, child: Text('Streak', style: TextStyle(fontWeight: FontWeight.bold))),
                            ],
                          ),
                        ),
                        Divider(),
                        ...leaderboard.asMap().entries.map((entry) {
                          final int index = entry.key;
                          final Map<String, dynamic> user = entry.value;
                          return ListTile(
                            title: Row(
                              children: [
                                Expanded(
                                  flex: 1, 
                                  child: Text('${index + 1}',
                                    style: TextStyle(
                                      fontWeight: index < 3 ? FontWeight.bold : FontWeight.normal,
                                      color: index == 0 ? Colors.amber : (index == 1 ? Colors.grey[400] : (index == 2 ? Colors.brown : null)),
                                    ),
                                  ),
                                ),
                                Expanded(flex: 2, child: Text(user['name'])),
                                Expanded(flex: 1, child: Text('${user['score']}')),
                                Expanded(
                                  flex: 1, 
                                  child: Row(
                                    children: [
                                      Icon(Icons.local_fire_department, size: 16, color: Colors.orange),
                                      Text('${user['streak']}'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ] else if (currentPage == 4) ...[
                  // Achievements Section
                  Text(
                    'Your Achievements',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        ...achievements.map((achievement) => 
                          ListTile(
                            leading: Icon(Icons.emoji_events, color: Colors.amber),
                            title: Text(achievement),
                          )
                        ).toList(),
                        if (achievements.isEmpty)
                          Center(
                            child: Text(
                              'No achievements yet. Keep learning!',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Available Achievements',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.emoji_events, 
                            color: achievements.contains('First Word') ? Colors.amber : Colors.grey,
                          ),
                          title: Text('First Word'),
                          subtitle: Text('Learn your first word'),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.emoji_events, 
                            color: achievements.contains('Perfect Quiz') ? Colors.amber : Colors.grey,
                          ),
                          title: Text('Perfect Quiz'),
                          subtitle: Text('Get a perfect score on a quiz'),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.emoji_events, 
                            color: achievements.contains('Streak Master') ? Colors.amber : Colors.grey,
                          ),
                          title: Text('Streak Master'),
                          subtitle: Text('Maintain a 7-day streak'),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentPage < 3 ? currentPage : 0,
          onTap: (index) {
            setState(() {
              currentPage = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.quiz),
              label: 'Quiz',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.flip),
              label: 'Flashcards',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.volume_up),
              label: 'Audio',
            ),
          ],
        ),
      ),
    );
  }
}
