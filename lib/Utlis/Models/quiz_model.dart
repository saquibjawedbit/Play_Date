class QuizModel {
  final String question;
  final String option1;
  final String option2;
  final String option3;
  final String option4;

  const QuizModel({
    required this.question,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.option4,
  });
}

const dummyData = [
  QuizModel(
    question: "You have a free afternoon. Where do you hangout?",
    option1: "Park",
    option2: "office",
    option3: "Campus",
    option4: "Restraunt",
  ),
  QuizModel(
    question: "Your favourite canteen?",
    option1: "Mehak",
    option2: "Chotu",
    option3: "Techno",
    option4: "Food Stall",
  ),
  QuizModel(
    question: "Your favourite dish?",
    option1: "Pizza",
    option2: "Burger",
    option3: "Biryani",
    option4: "Dosa",
  ),
  QuizModel(
    question: "Your hobby?",
    option1: "Singing",
    option2: "Dancing",
    option3: "Playing instruments",
    option4: "Chess",
  ),
];
