class QuizQuestion {
  final String question;
  final List<String> options;
  final String answer;
  final String? imageUrl;
  final int difficulty;
  
  QuizQuestion({
    required this.question,
    required this.options,
    required this.answer,
    this.imageUrl,
    this.difficulty = 1,
  });
  
  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      question: json['question'] as String,
      options: List<String>.from(json['options'] as List),
      answer: json['answer'] as String,
      imageUrl: json['imageUrl'] as String?,
      difficulty: json['difficulty'] as int? ?? 1,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'options': options,
      'answer': answer,
      'imageUrl': imageUrl,
      'difficulty': difficulty,
    };
  }
} 