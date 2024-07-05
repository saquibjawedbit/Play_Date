import 'package:cloud_firestore/cloud_firestore.dart';

class QuizModel {
  final Timestamp startTime;
  final Timestamp endTime;
  final List<Map> questions;

  const QuizModel({
    required this.startTime,
    required this.endTime,
    required this.questions,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return QuizModel(
      startTime: json['startTime'],
      endTime: json['endTime'],
      questions: (json['questions'] as List<dynamic>)
          .map((question) => Map<String, dynamic>.from(question))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'startTime': startTime,
      'endTime': endTime,
      'questions': questions,
    };
  }
}

final dummyData = [
  QuizModel(
    startTime: Timestamp.fromDate(
      DateTime(2024, 07, 05, 23, 11, 0),
    ),
    endTime: Timestamp.fromDate(
      DateTime(2024, 07, 05, 23, 12, 0),
    ),
    questions: [
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
