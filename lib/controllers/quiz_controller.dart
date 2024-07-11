import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ntp/ntp.dart';
import 'package:play_dates/Screens/Quiz/leaderboard_screen.dart';
import 'package:play_dates/Screens/Quiz/quest_end_screen.dart';
import 'package:play_dates/Screens/Quiz/quiz_screen.dart';
import 'package:play_dates/Utlis/Models/participants_model.dart';
import 'package:play_dates/Utlis/Models/quiz_model.dart';
import 'package:play_dates/controllers/user_controller.dart';
import 'package:play_dates/main.dart';

class QuizController extends GetxController {
  Timer? _timer;
  Timer? _qTimer;
  QuizModel? quizModel;
  double percent = 0;

  int nextQuiz = 0;
  int currentQuestion = -1;
  int secondsElapsed = 0;
  int round = 1;
  int nextQuestion = 15;
  int seconds = 0;

  var isQuiz = false.obs;

  final time = '00:00'.obs;
  final tTime = '00:00'.obs;
  final timeLeft = '00:00'.obs;
  final question = "00/00".obs;
  final nextQTime = "00:00".obs;
  final List<List<int>> answers = [[], [], []];

  final UserController controller = Get.find();

  Future<void> loadData() async {
    //categoryRepo.createCategories('contest', dummyData[0].toMap());
    DateTime currentTime = await NTP.now();
    isQuiz.value = false;
    DateTime startTime, endTime;
    if (currentTime.hour < 13 ||
        (currentTime.hour == 13 && currentTime.minute <= 12)) {
      startTime = DateTime(
          currentTime.year, currentTime.month, currentTime.day, 13, 11);
      endTime = DateTime(
          currentTime.year, currentTime.month, currentTime.day, 13, 12);
    } else if (currentTime.hour < 17 ||
        (currentTime.hour == 17 && currentTime.minute <= 55)) {
      startTime = DateTime(
          currentTime.year, currentTime.month, currentTime.day, 17, 55);
      endTime = DateTime(
          currentTime.year, currentTime.month, currentTime.day, 17, 56);
    } else if (currentTime.hour < 20 ||
        (currentTime.hour == 20 && currentTime.minute <= 32)) {
      startTime = DateTime(
          currentTime.year, currentTime.month, currentTime.day, 20, 31, 00);
      endTime = DateTime(
          currentTime.year, currentTime.month, currentTime.day, 20, 32, 00);
    } else {
      startTime = DateTime(
          currentTime.year, currentTime.month, currentTime.day, 13, 11);
      endTime = DateTime(
          currentTime.year, currentTime.month, currentTime.day, 13, 12);
    }

    if (currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {
      debugPrint("Quiz started at $startTime, Round: $round");
      isQuiz.value = true;
      final models = await categoryRepo.fetchQuizModel(
        startTime:
            DateTime(currentTime.year, currentTime.month, currentTime.day),
      );
      if (models.isNotEmpty) {
        quizModel = models[0];
      } else {
        debugPrint("Contest not loaded!");
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

  void registerUser() async {
    if (quizModel == null) return;
    final id = controller.user!.id;
    ParticipantModels model = ParticipantModels(
      userRef: FirebaseFirestore.instance.collection('user').doc(id),
      gender: 'M',
      round1: answers[0],
      round2: answers[1],
      round3: answers[2],
    );
    categoryRepo.createParticpant(
        'contest', quizModel!.id!, 'player', model.toMap());
  }

  void getLeaderBoard() async {
    List<ParticipantModels> players =
        await categoryRepo.fetchPlayers(id: quizModel!.id!);
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
      loadData();
    }
    timeLeft.value =
        "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  void _startTimer() {
    seconds = 0;
    const duration = Duration(seconds: 1);
    _timer = Timer.periodic(duration, (Timer timer) {
      int minute = seconds ~/ 60;
      int second = seconds % 60;
      tTime.value =
          "00:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}";
      seconds++;
    });
  }

  void onQuestionStart() {
    nextQuestion = 15;
    const duration = Duration(seconds: 1);
    _qTimer = Timer.periodic(
      duration,
      (Timer timer) {
        nextQTime.value = "${nextQuestion.toString().padLeft(2, '0')} secs";
        if (nextQuestion <= 0) {
          _qTimer!.cancel();
          nextPage();
        }
        nextQuestion--;
      },
    );
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
    if (currentQuestion == -1) {
      _startTimer();
    }
    currentQuestion += 1;
    question.value = "${(currentQuestion + 1).toString().padLeft(2, '0')}/04";
    percent = (currentQuestion + 1) / 4;
    if (currentQuestion >= 4) {
      if (round == 3) registerUser();
      _qTimer!.cancel();
      _timer!.cancel();
      _elapsedTimer(switchToLeaderBoard, 5);
      Get.offAll(() => QuestEndScreen());
      currentQuestion = -1;
      round++;
      round = max(round % 4, 1);
    } else if (quizModel != null) {
      if (round == 1) {
        _changeScreen(
            quizModel!.round1[currentQuestion] as Map<String, dynamic>);
      } else if (round == 2) {
        _changeScreen(
            quizModel!.round2[currentQuestion] as Map<String, dynamic>);
      } else {
        _changeScreen(
            quizModel!.round3[currentQuestion] as Map<String, dynamic>);
      }
      onQuestionStart();
    }
  }

  void _changeScreen(Map<String, dynamic> json) {
    Get.offAll(
      () => QuizScreen(
        questionData: QuizData.fromJson(json),
      ),
      transition: Transition.fadeIn,
    );
  }

  void submitAns(int option) {
    answers[round - 1].add(option);
    if (currentQuestion == 3) nextPage();
  }

  @override
  void onClose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.onClose();
  }
}
