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
      DateTime(2024, 07, 04, 20, 0, 0),
    ),
    endTime: Timestamp.fromDate(
      DateTime(2024, 07, 04, 20, 0, 0),
    ),
    questions: [
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
