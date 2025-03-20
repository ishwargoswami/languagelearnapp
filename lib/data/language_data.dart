import '../models/quiz_question.dart';
import '../models/flashcard.dart';

class LanguageData {
  static final Map<String, List<QuizQuestion>> quizQuestionsByLanguage = {
    'Spanish': [
      QuizQuestion(
        question: 'What is the Spanish word for "Apple"?',
        options: ['Manzana', 'Banana', 'Pera', 'Naranja'],
        answer: 'Manzana',
        difficulty: 1,
      ),
      QuizQuestion(
        question: 'What is the Spanish word for "Hello"?',
        options: ['Hola', 'Adiós', 'Gracias', 'Buenos días'],
        answer: 'Hola',
        difficulty: 1,
      ),
      QuizQuestion(
        question: 'What is the Spanish word for "Thank you"?',
        options: ['Gracias', 'Por favor', 'De nada', 'Lo siento'],
        answer: 'Gracias',
        difficulty: 1,
      ),
      QuizQuestion(
        question: 'Complete the sentence: "Yo ____ estudiar español"',
        options: ['quiero', 'quieres', 'quiere', 'queremos'],
        answer: 'quiero',
        difficulty: 2,
      ),
      QuizQuestion(
        question: 'Which is the correct translation for "I am from the United States"?',
        options: [
          'Soy de los Estados Unidos', 
          'Estoy de los Estados Unidos', 
          'Vengo los Estados Unidos', 
          'Soy los Estados Unidos'
        ],
        answer: 'Soy de los Estados Unidos',
        difficulty: 2,
      ),
    ],
    'French': [
      QuizQuestion(
        question: 'What is the French word for "Hello"?',
        options: ['Bonjour', 'Au revoir', 'Merci', 'S\'il vous plaît'],
        answer: 'Bonjour',
        difficulty: 1,
      ),
      QuizQuestion(
        question: 'What is the French word for "Goodbye"?',
        options: ['Au revoir', 'Bonjour', 'Merci', 'Oui'],
        answer: 'Au revoir',
        difficulty: 1,
      ),
      QuizQuestion(
        question: 'What is the French word for "Yes"?',
        options: ['Oui', 'Non', 'Peut-être', 'Merci'],
        answer: 'Oui',
        difficulty: 1,
      ),
      QuizQuestion(
        question: 'How do you say "I would like coffee" in French?',
        options: [
          'Je voudrais du café', 
          'J\'aime le café', 
          'Je bois du café', 
          'Je veux café'
        ],
        answer: 'Je voudrais du café',
        difficulty: 2,
      ),
      QuizQuestion(
        question: 'Which article would you use with "livre" (book)?',
        options: ['le', 'la', 'les', 'l\''],
        answer: 'le',
        difficulty: 2,
      ),
    ],
    'German': [
      QuizQuestion(
        question: 'What is the German word for "Hello"?',
        options: ['Hallo', 'Tschüss', 'Danke', 'Bitte'],
        answer: 'Hallo',
        difficulty: 1,
      ),
      QuizQuestion(
        question: 'What is the German word for "Please"?',
        options: ['Bitte', 'Danke', 'Ja', 'Nein'],
        answer: 'Bitte',
        difficulty: 1,
      ),
      QuizQuestion(
        question: 'What is the German word for "Car"?',
        options: ['Auto', 'Haus', 'Buch', 'Tisch'],
        answer: 'Auto',
        difficulty: 1,
      ),
      QuizQuestion(
        question: 'What is the correct way to say "I am learning German"?',
        options: [
          'Ich lerne Deutsch', 
          'Ich lernen Deutsch', 
          'Ich bin Deutsch lernen', 
          'Ich bin lerne Deutsch'
        ],
        answer: 'Ich lerne Deutsch',
        difficulty: 2,
      ),
    ],
    'Italian': [
      QuizQuestion(
        question: 'What is the Italian word for "Hello"?',
        options: ['Ciao', 'Arrivederci', 'Grazie', 'Per favore'],
        answer: 'Ciao',
        difficulty: 1,
      ),
      QuizQuestion(
        question: 'What is the Italian word for "Thank you"?',
        options: ['Grazie', 'Prego', 'Ciao', 'Sì'],
        answer: 'Grazie',
        difficulty: 1,
      ),
      QuizQuestion(
        question: 'What is the Italian word for "Good morning"?',
        options: ['Buongiorno', 'Buonasera', 'Buonanotte', 'Ciao'],
        answer: 'Buongiorno',
        difficulty: 1,
      ),
      QuizQuestion(
        question: 'How would you order a coffee in Italian?',
        options: [
          'Un caffè, per favore', 
          'Uno caffè, per favore', 
          'Un caffè, prego favore', 
          'Il caffè, grazie'
        ],
        answer: 'Un caffè, per favore',
        difficulty: 2,
      ),
    ],
    'Japanese': [
      QuizQuestion(
        question: 'What is the Japanese word for "Hello"?',
        options: ['こんにちは (Konnichiwa)', 'さようなら (Sayōnara)', 'ありがとう (Arigatō)', 'お願いします (Onegaishimasu)'],
        answer: 'こんにちは (Konnichiwa)',
        difficulty: 1,
      ),
      QuizQuestion(
        question: 'What is the Japanese word for "Thank you"?',
        options: ['ありがとう (Arigatō)', 'こんにちは (Konnichiwa)', 'さようなら (Sayōnara)', 'はい (Hai)'],
        answer: 'ありがとう (Arigatō)',
        difficulty: 1,
      ),
      QuizQuestion(
        question: 'What is the Japanese word for "Yes"?',
        options: ['はい (Hai)', 'いいえ (Iie)', 'お願いします (Onegaishimasu)', 'すみません (Sumimasen)'],
        answer: 'はい (Hai)',
        difficulty: 1,
      ),
      QuizQuestion(
        question: 'Which particle marks the object of a sentence?',
        options: ['を (o)', 'は (wa)', 'が (ga)', 'に (ni)'],
        answer: 'を (o)',
        difficulty: 3,
      ),
    ],
    'Chinese': [
      QuizQuestion(
        question: 'What is the Chinese word for "Hello"?',
        options: ['你好 (Nǐ hǎo)', '谢谢 (Xièxiè)', '再见 (Zàijiàn)', '是 (Shì)'],
        answer: '你好 (Nǐ hǎo)',
        difficulty: 1,
      ),
      QuizQuestion(
        question: 'What is the Chinese word for "Thank you"?',
        options: ['谢谢 (Xièxiè)', '你好 (Nǐ hǎo)', '再见 (Zàijiàn)', '不 (Bù)'],
        answer: '谢谢 (Xièxiè)',
        difficulty: 1,
      ),
      QuizQuestion(
        question: 'What is the Chinese word for "Goodbye"?',
        options: ['再见 (Zàijiàn)', '你好 (Nǐ hǎo)', '谢谢 (Xièxiè)', '是 (Shì)'],
        answer: '再见 (Zàijiàn)',
        difficulty: 1,
      ),
    ],
    'Korean': [
      QuizQuestion(
        question: 'What is the Korean word for "Hello"?',
        options: ['안녕하세요 (Annyeonghaseyo)', '감사합니다 (Gamsahamnida)', '안녕히 가세요 (Annyeonghi gaseyo)', '네 (Ne)'],
        answer: '안녕하세요 (Annyeonghaseyo)',
        difficulty: 1,
      ),
      QuizQuestion(
        question: 'What is the Korean word for "Thank you"?',
        options: ['감사합니다 (Gamsahamnida)', '안녕하세요 (Annyeonghaseyo)', '안녕히 가세요 (Annyeonghi gaseyo)', '아니요 (Aniyo)'],
        answer: '감사합니다 (Gamsahamnida)',
        difficulty: 1,
      ),
      QuizQuestion(
        question: 'What is the Korean word for "Yes"?',
        options: ['네 (Ne)', '아니요 (Aniyo)', '잘 모르겠어요 (Jal moreugesseoyo)', '미안합니다 (Mianhamnida)'],
        answer: '네 (Ne)',
        difficulty: 1,
      ),
    ],
  };

  static final Map<String, List<Flashcard>> flashcardsByLanguage = {
    'Spanish': [
      Flashcard(
        word: 'Manzana',
        translation: 'Apple',
        example: 'Me gusta comer manzanas.',
      ),
      Flashcard(
        word: 'Hola',
        translation: 'Hello',
        example: 'Hola, ¿cómo estás?',
      ),
      Flashcard(
        word: 'Gracias',
        translation: 'Thank you',
        example: 'Muchas gracias por tu ayuda.',
      ),
      Flashcard(
        word: 'Adiós',
        translation: 'Goodbye',
        example: 'Adiós, hasta mañana.',
      ),
      Flashcard(
        word: 'Agua',
        translation: 'Water',
        example: 'Necesito un vaso de agua, por favor.',
      ),
      Flashcard(
        word: 'Libro',
        translation: 'Book',
        example: 'Estoy leyendo un libro interesante.',
      ),
      Flashcard(
        word: 'Casa',
        translation: 'House',
        example: 'Mi casa está cerca del parque.',
      ),
    ],
    'French': [
      Flashcard(
        word: 'Pomme',
        translation: 'Apple',
        example: 'J\'aime manger des pommes.',
      ),
      Flashcard(
        word: 'Bonjour',
        translation: 'Hello',
        example: 'Bonjour, comment allez-vous?',
      ),
      Flashcard(
        word: 'Merci',
        translation: 'Thank you',
        example: 'Merci beaucoup pour votre aide.',
      ),
      Flashcard(
        word: 'Au revoir',
        translation: 'Goodbye',
        example: 'Au revoir, à demain.',
      ),
      Flashcard(
        word: 'Eau',
        translation: 'Water',
        example: 'Je voudrais un verre d\'eau, s\'il vous plaît.',
      ),
      Flashcard(
        word: 'Livre',
        translation: 'Book',
        example: 'Je lis un livre intéressant.',
      ),
      Flashcard(
        word: 'Maison',
        translation: 'House',
        example: 'Ma maison est près du parc.',
      ),
    ],
    'German': [
      Flashcard(
        word: 'Apfel',
        translation: 'Apple',
        example: 'Ich esse gerne Äpfel.',
      ),
      Flashcard(
        word: 'Hallo',
        translation: 'Hello',
        example: 'Hallo, wie geht es dir?',
      ),
      Flashcard(
        word: 'Danke',
        translation: 'Thank you',
        example: 'Vielen Danke für deine Hilfe.',
      ),
      Flashcard(
        word: 'Auf Wiedersehen',
        translation: 'Goodbye',
        example: 'Auf Wiedersehen, bis morgen.',
      ),
      Flashcard(
        word: 'Wasser',
        translation: 'Water',
        example: 'Ich brauche ein Glas Wasser, bitte.',
      ),
      Flashcard(
        word: 'Buch',
        translation: 'Book',
        example: 'Ich lese ein interessantes Buch.',
      ),
      Flashcard(
        word: 'Haus',
        translation: 'House',
        example: 'Mein Haus ist in der Nähe vom Park.',
      ),
    ],
    'Italian': [
      Flashcard(
        word: 'Mela',
        translation: 'Apple',
        example: 'Mi piace mangiare le mele.',
      ),
      Flashcard(
        word: 'Ciao',
        translation: 'Hello',
        example: 'Ciao, come stai?',
      ),
      Flashcard(
        word: 'Grazie',
        translation: 'Thank you',
        example: 'Grazie mille per il tuo aiuto.',
      ),
      Flashcard(
        word: 'Arrivederci',
        translation: 'Goodbye',
        example: 'Arrivederci, a domani.',
      ),
      Flashcard(
        word: 'Acqua',
        translation: 'Water',
        example: 'Vorrei un bicchiere d\'acqua, per favore.',
      ),
      Flashcard(
        word: 'Libro',
        translation: 'Book',
        example: 'Sto leggendo un libro interessante.',
      ),
      Flashcard(
        word: 'Casa',
        translation: 'House',
        example: 'La mia casa è vicino al parco.',
      ),
    ],
    'Japanese': [
      Flashcard(
        word: 'りんご (Ringo)',
        translation: 'Apple',
        example: '私はりんごが好きです。(Watashi wa ringo ga suki desu.)',
      ),
      Flashcard(
        word: 'こんにちは (Konnichiwa)',
        translation: 'Hello',
        example: 'こんにちは、お元気ですか？(Konnichiwa, o-genki desu ka?)',
      ),
      Flashcard(
        word: 'ありがとう (Arigatō)',
        translation: 'Thank you',
        example: '手伝ってくれてありがとう。(Tetsudatte kurete arigatō.)',
      ),
      Flashcard(
        word: 'さようなら (Sayōnara)',
        translation: 'Goodbye',
        example: 'さようなら、また明日。(Sayōnara, mata ashita.)',
      ),
      Flashcard(
        word: '水 (Mizu)',
        translation: 'Water',
        example: '水をください。(Mizu o kudasai.)',
      ),
      Flashcard(
        word: '本 (Hon)',
        translation: 'Book',
        example: '面白い本を読んでいます。(Omoshiroi hon o yonde imasu.)',
      ),
      Flashcard(
        word: '家 (Ie)',
        translation: 'House',
        example: '私の家は公園の近くにあります。(Watashi no ie wa kōen no chikaku ni arimasu.)',
      ),
    ],
    'Chinese': [
      Flashcard(
        word: '苹果 (Píngguǒ)',
        translation: 'Apple',
        example: '我喜欢吃苹果。(Wǒ xǐhuān chī píngguǒ.)',
      ),
      Flashcard(
        word: '你好 (Nǐ hǎo)',
        translation: 'Hello',
        example: '你好，你好吗？(Nǐ hǎo, nǐ hǎo ma?)',
      ),
      Flashcard(
        word: '谢谢 (Xièxiè)',
        translation: 'Thank you',
        example: '非常谢谢你的帮助。(Fēicháng xièxiè nǐ de bāngzhù.)',
      ),
      Flashcard(
        word: '再见 (Zàijiàn)',
        translation: 'Goodbye',
        example: '再见，明天见。(Zàijiàn, míngtiān jiàn.)',
      ),
      Flashcard(
        word: '水 (Shuǐ)',
        translation: 'Water',
        example: '请给我一杯水。(Qǐng gěi wǒ yì bēi shuǐ.)',
      ),
    ],
    'Korean': [
      Flashcard(
        word: '사과 (Sagwa)',
        translation: 'Apple',
        example: '저는 사과를 좋아해요. (Jeoneun sagwaleul joahaeyo.)',
      ),
      Flashcard(
        word: '안녕하세요 (Annyeonghaseyo)',
        translation: 'Hello',
        example: '안녕하세요, 잘 지내셨어요? (Annyeonghaseyo, jal jinaeseosseoyo?)',
      ),
      Flashcard(
        word: '감사합니다 (Gamsahamnida)',
        translation: 'Thank you',
        example: '도와주셔서 감사합니다. (Dowajusyeoseo gamsahamnida.)',
      ),
      Flashcard(
        word: '안녕히 가세요 (Annyeonghi gaseyo)',
        translation: 'Goodbye',
        example: '안녕히 가세요, 내일 봐요. (Annyeonghi gaseyo, naeil bwayo.)',
      ),
      Flashcard(
        word: '물 (Mul)',
        translation: 'Water',
        example: '물 한 잔 주세요. (Mul han jan juseyo.)',
      ),
    ],
  };

  static final List<Map<String, dynamic>> leaderboard = [
    {'name': 'Sarah', 'score': 980, 'streak': 45, 'language': 'Spanish'},
    {'name': 'Michael', 'score': 850, 'streak': 30, 'language': 'Japanese'},
    {'name': 'Emma', 'score': 790, 'streak': 25, 'language': 'French'},
    {'name': 'James', 'score': 720, 'streak': 20, 'language': 'German'},
    {'name': 'Olivia', 'score': 650, 'streak': 18, 'language': 'Italian'},
    {'name': 'Noah', 'score': 620, 'streak': 15, 'language': 'Korean'},
    {'name': 'Sophia', 'score': 590, 'streak': 12, 'language': 'Chinese'},
    {'name': 'Liam', 'score': 550, 'streak': 10, 'language': 'Spanish'},
  ];

  static final List<Map<String, dynamic>> achievements = [
    {
      'id': 'first_word',
      'name': 'First Word',
      'description': 'Learn your first word',
      'icon': 'emoji_events',
    },
    {
      'id': 'perfect_quiz',
      'name': 'Perfect Quiz',
      'description': 'Get a perfect score on a quiz',
      'icon': 'military_tech',
    },
    {
      'id': 'streak_master',
      'name': 'Streak Master',
      'description': 'Maintain a 7-day streak',
      'icon': 'local_fire_department',
    },
    {
      'id': 'vocab_collector',
      'name': 'Vocabulary Collector',
      'description': 'Learn 50 words in one language',
      'icon': 'collections_bookmark',
    },
    {
      'id': 'pronunciation_pro',
      'name': 'Pronunciation Pro',
      'description': 'Practice pronunciation 20 times',
      'icon': 'record_voice_over',
    },
    {
      'id': 'polyglot',
      'name': 'Budding Polyglot',
      'description': 'Study at least 3 different languages',
      'icon': 'public',
    },
  ];
} 