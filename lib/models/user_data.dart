class UserData {
  int streak;
  int totalScore;
  double progressPercentage;
  List<String> achievements;
  String? lastLoginDate;
  Map<String, int> languageLevels;
  
  UserData({
    this.streak = 0,
    this.totalScore = 0,
    this.progressPercentage = 0.0,
    this.achievements = const [],
    this.lastLoginDate,
    this.languageLevels = const {},
  });
  
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      streak: json['streak'] as int,
      totalScore: json['totalScore'] as int,
      progressPercentage: json['progressPercentage'] as double,
      achievements: List<String>.from(json['achievements'] as List),
      lastLoginDate: json['lastLoginDate'] as String?,
      languageLevels: Map<String, int>.from(json['languageLevels'] as Map),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'streak': streak,
      'totalScore': totalScore,
      'progressPercentage': progressPercentage,
      'achievements': achievements,
      'lastLoginDate': lastLoginDate,
      'languageLevels': languageLevels,
    };
  }
  
  int getLanguageLevel(String language) {
    return languageLevels[language] ?? 1;
  }
  
  void incrementLanguageLevel(String language) {
    int currentLevel = languageLevels[language] ?? 0;
    languageLevels[language] = currentLevel + 1;
  }
} 