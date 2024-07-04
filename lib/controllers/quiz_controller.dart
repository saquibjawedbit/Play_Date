import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:play_dates/Screens/leaderboard_screen.dart';
import 'package:play_dates/Screens/quest_end_screen.dart';
import 'package:play_dates/Screens/quiz_screen.dart';
import 'package:play_dates/Utlis/Models/quiz_model.dart';

class QuizController extends GetxController {
  Timer? _timer;
  final time = '00.00'.obs;
  final question = "00/00".obs;
  double percent = 0;
  int round = 1;
  int currentQuestion = -1;
  int secondsElapsed = 0;
  final List<int> answers = [];

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
    question.value =
        "${(currentQuestion + 1).toString().padLeft(2, '0')}/${dummyData.length.toString().padLeft(2, '0')}";
    percent = (currentQuestion + 1) / 4;
    if (currentQuestion >= dummyData.length) {
      _elapsedTimer();
      Get.offAll(() => QuestEndScreen());
    } else {
      Get.offAll(
        () => QuizScreen(questionData: dummyData[currentQuestion]),
        transition: Transition.fadeIn,
        curve: Curves.bounceIn,
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
