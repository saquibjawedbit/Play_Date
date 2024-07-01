import 'dart:async';

import 'package:get/get.dart';
import 'package:play_dates/Screens/leaderboard_screen.dart';
import 'package:play_dates/Screens/quiz_screen.dart';
import 'package:play_dates/Utlis/Models/quiz_model.dart';

class QuizController extends GetxController {
  Timer? _timer;
  final time = '00.00'.obs;
  final question = "00/00".obs;
  int currentQuestion = -1;
  int secondsElapsed = 0;
  final answers = [];

  void _startTimer() {
    const duration = Duration(seconds: 1);
    _timer = Timer.periodic(duration, (Timer timer) {
      int minute = secondsElapsed ~/ 60;
      int seconds = secondsElapsed % 60;
      time.value =
          "${minute.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
      secondsElapsed++;
    });
  }

  void nextPage() {
    if (currentQuestion == -1) _startTimer();
    currentQuestion += 1;
    question.value =
        "${(currentQuestion + 1).toString().padLeft(2, '0')}/${dummyData.length.toString().padLeft(2, '0')}";
    if (currentQuestion >= dummyData.length) {
      Get.off(() => const LeaderBoardScreen());
    } else {
      Get.off(() => QuizScreen(questionData: dummyData[currentQuestion]));
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
