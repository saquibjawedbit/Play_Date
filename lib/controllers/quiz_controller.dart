import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ntp/ntp.dart';
import 'package:play_dates/Screens/leaderboard_screen.dart';
import 'package:play_dates/Screens/quest_end_screen.dart';
import 'package:play_dates/Screens/quiz_screen.dart';
import 'package:play_dates/Utlis/Models/quiz_model.dart';
import 'package:play_dates/main.dart';

class QuizController extends GetxController {
  Timer? _timer;
  QuizModel? quizModel;
  double percent = 0;

  int nextQuiz = 0;
  int currentQuestion = -1;
  int secondsElapsed = 0;
  int round = 1;

  var isQuiz = false.obs;

  final time = '00.00'.obs;
  final timeLeft = '00:00'.obs;
  final question = "00/00".obs;
  final List<int> answers = [];

  Future<void> loadData() async {
    //categoryRepo.createCategories('contest', dummyData[0].toMap());
    DateTime currentTime = await NTP.now();
    DateTime startTime, endTime;
    if (currentTime.hour <= 13 && currentTime.minute <= 11) {
      startTime = DateTime(
          currentTime.year, currentTime.month, currentTime.day, 00, 38);
      endTime = DateTime(
          currentTime.year, currentTime.month, currentTime.day, 00, 36);
      round = 1;
    } else if (currentTime.hour <= 17 && currentTime.minute <= 56) {
      startTime = DateTime(
          currentTime.year, currentTime.month, currentTime.day, 17, 55);
      endTime = DateTime(
          currentTime.year, currentTime.month, currentTime.day, 17, 58);
      round = 2;
    } else if (currentTime.hour <= 23 && currentTime.minute <= 12) {
      startTime = DateTime(
          currentTime.year, currentTime.month, currentTime.day, 23, 11, 00);
      endTime = DateTime(
          currentTime.year, currentTime.month, currentTime.day, 23, 12, 00);
      round = 3;
    } else {
      startTime = DateTime(
          currentTime.year, currentTime.month, currentTime.day, 13, 11);
      endTime = DateTime(
          currentTime.year, currentTime.month, currentTime.day, 13, 15);
      round = 1;
    }

    if (currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {
      debugPrint("Quiz started at $startTime, Round: $round");
      isQuiz.value = true;
      final models = await categoryRepo.fetchQuizModel(startTime: startTime);
      if (models.isNotEmpty) {
        quizModel = models[0];
      }
    } else {
      debugPrint("Next At $startTime");
      if (startTime.isAfter(currentTime)) {
        nextQuiz = startTime.difference(currentTime).inSeconds;
      } else {
        nextQuiz = currentTime.difference(startTime).inSeconds;
      }
    }
  }

  void start() {
    _elapsedTimer(onTimerEnd, nextQuiz);
  }

  void onTimerEnd() async {
    int hours = secondsElapsed ~/ 3600;
    int minutes = (secondsElapsed % 3600) ~/ 60;
    int seconds = secondsElapsed % 60;
    if (secondsElapsed <= 0) {
      _timer!.cancel();
      await loadData();
    }
    timeLeft.value =
        "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
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

  void switchToLeaderBoard() {
    int seconds = (secondsElapsed % 60);
    if (secondsElapsed <= 0) {
      _timer!.cancel();
      Get.offAll(
        () => const LeaderBoardScreen(),
      );
    }
    time.value = "${seconds.toString().padLeft(2, '0')} secs";
  }

  void _elapsedTimer(Function onTimeEnd, int tTime) {
    if (_timer != null) _timer!.cancel();
    time.value = "05 secs";
    secondsElapsed = tTime;
    const duration = Duration(seconds: 1);
    _timer = Timer.periodic(duration, (Timer timer) {
      onTimeEnd();
      secondsElapsed--;
    });
  }

  void nextPage() {
    if (!isQuiz.value) return;
    if (currentQuestion == -1) _startTimer();
    currentQuestion += 1;
    question.value = "${(currentQuestion + 1).toString().padLeft(2, '0')}/04";
    percent = (currentQuestion + 1) / 4;
    if (currentQuestion >= 4) {
      _elapsedTimer(switchToLeaderBoard, 5);
      Get.offAll(() => QuestEndScreen());
    } else if (quizModel != null) {
      Get.offAll(
        () => QuizScreen(
          questionData: QuizData.fromJson(
              quizModel!.questions[currentQuestion] as Map<String, dynamic>),
        ),
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
