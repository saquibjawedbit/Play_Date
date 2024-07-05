import 'dart:async';
import 'package:get/get.dart';
import 'package:play_dates/Screens/leaderboard_screen.dart';
import 'package:play_dates/Screens/quest_end_screen.dart';
import 'package:play_dates/Screens/quiz_screen.dart';
import 'package:play_dates/Utlis/Models/quiz_model.dart';
import 'package:play_dates/main.dart';

class QuizController extends GetxController {
  Timer? _timer;
  double percent = 0;

  QuizModel? quizModel;

  int round = 2;
  int currentQuestion = -1;
  int secondsElapsed = 0;
  final time = '00.00'.obs;

  final question = "00/00".obs;
  final List<int> answers = [];

  void loadData() async {
    final models = await categoryRepo.fetchQuizModel();
    if (models.isNotEmpty) {
      quizModel = models[0];
    }
  }

  void _startTimer() {
    const duration = Duration(seconds: 1);
    _timer = Timer.periodic(duration, (Timer timer) {
      int minute = secondsElapsed ~/ 60;
      int seconds = secondsElapsed % 60;
      time.value =
          "00:${minute.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
      secondsElapsed++;
    });
  }

  void _elapsedTimer() {
    _timer!.cancel();
    time.value = "05 secs";
    secondsElapsed = 4;
    const duration = Duration(seconds: 1);
    _timer = Timer.periodic(duration, (Timer timer) {
      int seconds = (secondsElapsed % 60);
      if (secondsElapsed <= 0) {
        _timer!.cancel();
        Get.offAll(
          () => const LeaderBoardScreen(),
        );
      }
      time.value = "${seconds.toString().padLeft(2, '0')} secs";
      secondsElapsed--;
    });
  }

  void nextPage() {
    if (currentQuestion == -1) _startTimer();
    currentQuestion += 1;
    question.value = "${(currentQuestion + 1).toString().padLeft(2, '0')}/04";
    percent = (currentQuestion + 1) / 4;
    if (currentQuestion >= 4) {
      _elapsedTimer();
      Get.offAll(() => QuestEndScreen());
    } else if (quizModel != null) {
      Get.offAll(
        () => QuizScreen(
            questionData: QuizData.fromJson(
                quizModel!.questions[currentQuestion] as Map<String, dynamic>)),
        transition: Transition.fadeIn,
      );
    }
  }

  void submitAns(int option) {
    answers.add(option);
  }

  @override
  void onClose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.onClose();
  }
}
