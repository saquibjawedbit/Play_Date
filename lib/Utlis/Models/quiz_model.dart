import 'package:cloud_firestore/cloud_firestore.dart';

class QuizModel {
  final Timestamp startTime;
  final Timestamp endTime;
  final List<Map> round1;
  final List<Map> round2;
  final List<Map> round3;

  const QuizModel({
    required this.startTime,
    required this.endTime,
    required this.round1,
    required this.round2,
    required this.round3,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return QuizModel(
      startTime: json['startTime'],
      endTime: json['endTime'],
      round1: (json['round1'] as List<dynamic>)
          .map((question) => Map<String, dynamic>.from(question))
          .toList(),
      round2: (json['round2'] as List<dynamic>)
          .map((question) => Map<String, dynamic>.from(question))
          .toList(),
      round3: (json['round3'] as List<dynamic>)
          .map((question) => Map<String, dynamic>.from(question))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'startTime': startTime,
      'endTime': endTime,
      'round1': round1,
      'round2': round2,
      'round3': round3,
    };
  }
}

final dummyData = [
  QuizModel(
    startTime: Timestamp.fromDate(
      DateTime(2024, 07, 07),
    ),
    endTime: Timestamp.fromDate(
      DateTime(2024, 07, 07),
    ),
    round1: [
      const QuizData(
        question:
            "If every canvas has a color and every color has a meaning, then choose the canvas that resembles to your color the nearest?",
        answers: [
          "Endless Sky",
          "The Exorcist Fire",
          "The Gleams of Plateau",
          "The Chillies of Sunflower",
        ],
      ).toMap(),
      const QuizData(
        question:
            "Everyone holds something special, what is your secret sauce that makes the people AWWed around you?",
        answers: [
          "My Personality",
          "My Dressing sense",
          "My sense of humour",
          "My body features",
        ],
      ).toMap(),
      const QuizData(
        question:
            "In a room full of people, you saw him/her what should be your first move to start the fire?",
        answers: [
          "With lingering eye contact and subtle smiles",
          "With witty and clever conversation while looking straight in the eyes",
          "Highlighting your persona to get his/her attention",
          "To wait for a miracle to happen and for him/her to make a move",
        ],
      ).toMap(),
      const QuizData(
        question:
            "If you dive into the quest of finding love , you must understand the words of affection for that choose your language of love .",
        answers: [
          "Through physical touch and closeness",
          " By giving thoughtful gifts and surprises",
          "With words of affirmation and compliments",
          "By spending quality time together",
        ],
      ).toMap(),
    ],
    round2: [
      const QuizData(
        question:
            "Everyone wants to add little but spice thus name your pleasure that spices your life up ?",
        answers: [
          "A nasty scene while a steamy shower",
          "A ball of Strawberries and Nutella",
          "A Rom Com Kjo movie with bowl of popcorn",
          "A sip of Whine with cooking meal in your kitchen",
        ],
      ).toMap(),
      const QuizData(
        question:
            "Choose one pair that you look upto no strings no double thoughts !",
        answers: [
          "Mia and Sebastian",
          "Naina and Kabir",
          "Hazel and Augustus",
          " Raj and Simran",
        ],
      ).toMap(),
      const QuizData(
        question:
            "How you imagine your end of time your Vinland , after all turns out as you planned what life looks like for you  ?",
        answers: [
          "Having a luxurious villa with a view of city by side.",
          "Sipping coffee in your porch while your kids play in your backyard",
          "A lonely farm where you sitting alone the see the wheat flowing golden",
          "Hustlin’ hard with your work and rushing to become and earn as more as you can.",
        ],
      ).toMap(),
      const QuizData(
        question:
            "They say when its double stakes then the its call for the trouble takes , so  what's your call for double dates ?",
        answers: [
          "Totally into it, more people, more fun! It’s like our own mini Central Perk gathering.",
          "A bit too chaotic, kind of like Ross’s love life.",
          "Love it! It’s a perfect chance to see how my date interacts with others, like Joey at an audition.",
          "So sweet, especially with the right company—think Monica and Chandler vibes.",
        ],
      ).toMap(),
    ],
    round3: [
      const QuizData(
        question:
            "Lets get the thing to table , What’s your biggest ick on a date?",
        answers: [
          "When someone’s late, like waiting for a text back from Noah in “To All the Boys I’ve Loved Before”.",
          " When they keep going on about their job—total “Suits” vibes.",
          "When they dodge deep convos, like avoiding feels in “The Kissing Booth”.",
          "When they’re rude to others, unlike the sweet charm of Noah Flynn in “Euphoria”.",
        ],
      ).toMap(),
      const QuizData(
        question: "What’s the golden trait you seek in your perfect match?",
        answers: [
          "Loyalty, a steadfast soul who stands by you through every storm.",
          "Open-mindedness, an adventurous spirit eager to explore new horizons with you.",
          "Compassion, a heart that feels deeply and loves gently.",
          "A good listener, someone who truly hears you and understands your unspoken words.",
        ],
      ).toMap(),
      const QuizData(
        question:
            "One Last question Froddo , what is the partner the your are looking for ?",
        answers: [
          "Someone who gets my interests, is super kind, and totally trustworthy.",
          "Someone driven and ambitious, pushing me to be my best self.",
          "Someone fun and spontaneous, making every moment a blast.",
          "Someone loyal and honest, always there for me when things get tough.",
        ],
      ).toMap(),
      const QuizData(
        question:
            "What electrifying moment would make your heart race and keep the spark alive in your relationship?",
        answers: [
          "A daring midnight skinny dip, reminiscent of ‘Outer Banks’.",
          "An intense game of truth or dare that leads to revealing secrets, like in ‘Never Have I Ever’.",
          "A surprise visit that turns into an all-night adventure, channeling ‘Stranger Things’.",
          "A risky public display of affection at a fancy event, giving off ‘Elite’ vibes.",
        ],
      ).toMap(),
    ],
  ),
];

class QuizData {
  final String question;
  final List<dynamic> answers;

  const QuizData({
    required this.question,
    required this.answers,
  });

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answers': answers,
    };
  }

  factory QuizData.fromJson(Map<String, dynamic> json, {String? id}) {
    return QuizData(
      question: json['question'],
      answers: json['answers'] as List<dynamic>,
    );
  }
}
