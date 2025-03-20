import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();
  
  TtsService() {
    _initTts();
  }
  
  Future<void> _initTts() async {
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }
  
  Future<void> speak(String text, String languageCode) async {
    await _flutterTts.setLanguage(languageCode);
    await _flutterTts.speak(text);
  }
  
  Future<void> stop() async {
    await _flutterTts.stop();
  }
  
  Future<void> setPitch(double pitch) async {
    await _flutterTts.setPitch(pitch);
  }
  
  Future<void> setRate(double rate) async {
    await _flutterTts.setSpeechRate(rate);
  }
  
  Future<void> setVolume(double volume) async {
    await _flutterTts.setVolume(volume);
  }
  
  Future<List<dynamic>> getLanguages() async {
    return await _flutterTts.getLanguages;
  }
  
  Future<List<dynamic>> getVoices() async {
    return await _flutterTts.getVoices;
  }
} 