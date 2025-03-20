import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'language.dart';
import 'user_data.dart';

class AppState extends ChangeNotifier {
  bool _isDarkMode = false;
  String _selectedLanguage = 'Spanish';
  int _currentPage = 0;
  UserData _userData = UserData();
  bool _isLoading = true;
  
  final List<Language> _languages = [
    Language(name: 'Spanish', code: 'es-ES', flag: '🇪🇸'),
    Language(name: 'French', code: 'fr-FR', flag: '🇫🇷'),
    Language(name: 'German', code: 'de-DE', flag: '🇩🇪'),
    Language(name: 'Italian', code: 'it-IT', flag: '🇮🇹'),
    Language(name: 'Japanese', code: 'ja-JP', flag: '🇯🇵'),
    Language(name: 'Chinese', code: 'zh-CN', flag: '🇨🇳'),
    Language(name: 'Korean', code: 'ko-KR', flag: '🇰🇷'),
  ];
  
  bool get isDarkMode => _isDarkMode;
  String get selectedLanguage => _selectedLanguage;
  int get currentPage => _currentPage;
  UserData get userData => _userData;
  List<Language> get languages => _languages;
  bool get isLoading => _isLoading;
  
  AppState() {
    loadPreferences();
  }
  
  void loadPreferences() async {
    _isLoading = true;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _selectedLanguage = prefs.getString('selectedLanguage') ?? 'Spanish';
    
    // Load user data
    final userDataJson = prefs.getString('userData');
    if (userDataJson != null) {
      try {
        final Map<String, dynamic> userDataMap = json.decode(userDataJson);
        _userData = UserData.fromJson(userDataMap);
      } catch (e) {
        print('Error loading user data: $e');
        _userData = UserData();
      }
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  void setDarkMode(bool value) async {
    _isDarkMode = value;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
  }
  
  void toggleDarkMode() {
    setDarkMode(!_isDarkMode);
  }
  
  void setSelectedLanguage(String language) async {
    _selectedLanguage = language;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', language);
  }
  
  void setCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }
  
  Language getSelectedLanguageObj() {
    return _languages.firstWhere(
      (lang) => lang.name == _selectedLanguage,
      orElse: () => _languages.first,
    );
  }
  
  void updateUserScore(int points) {
    _userData.totalScore += points;
    saveUserData();
    notifyListeners();
  }
  
  void updateUserProgress(double amount) {
    _userData.progressPercentage = 
        (_userData.progressPercentage + amount).clamp(0.0, 1.0);
    saveUserData();
    notifyListeners();
  }
  
  void updateStreak() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    if (_userData.lastLoginDate == null) {
      // First time logging in
      _userData.streak = 1;
      _userData.lastLoginDate = today.toString();
    } else {
      final lastLogin = DateTime.parse(_userData.lastLoginDate!);
      final lastLoginDay = DateTime(lastLogin.year, lastLogin.month, lastLogin.day);
      
      final difference = today.difference(lastLoginDay).inDays;
      
      if (difference == 0) {
        // Already logged in today
      } else if (difference == 1) {
        // Consecutive day
        _userData.streak++;
      } else {
        // Streak broken
        _userData.streak = 1;
      }
      
      _userData.lastLoginDate = today.toString();
    }
    
    saveUserData();
    notifyListeners();
  }
  
  void addAchievement(String achievement) {
    if (!_userData.achievements.contains(achievement)) {
      _userData.achievements.add(achievement);
      saveUserData();
      notifyListeners();
    }
  }
  
  void saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataJson = json.encode(_userData.toJson());
    await prefs.setString('userData', userDataJson);
  }
} 