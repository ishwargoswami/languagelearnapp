class Flashcard {
  final String word;
  final String translation;
  final String? example;
  final String? imageUrl;
  final int difficulty;
  
  Flashcard({
    required this.word,
    required this.translation,
    this.example,
    this.imageUrl,
    this.difficulty = 1,
  });
  
  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      word: json['word'] as String,
      translation: json['translation'] as String,
      example: json['example'] as String?,
      imageUrl: json['imageUrl'] as String?,
      difficulty: json['difficulty'] as int? ?? 1,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'translation': translation,
      'example': example,
      'imageUrl': imageUrl,
      'difficulty': difficulty,
    };
  }
} 