import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ntp/ntp.dart';
import 'package:play_dates/Screens/Quiz/home_screen.dart';
import 'package:play_dates/Screens/Quiz/match_screen.dart';
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
  int dayRound = 1;
  // int seconds = 0;

  DateTime? startTime, endTime;

  var isQuiz = false.obs;

  final time = '00:00'.obs;
  final tTime = '00:00'.obs;
  final timeLeft = '00:00'.obs;
  final question = "00/00".obs;
  final nextQTime = "00:00".obs;
  final List<List<int>> answers = [[], [], []];

  final UserController controller = Get.find();

  Future<void> loadData() async {
    categoryRepo.createUser("contest", dummyData[0].toMap(),
        "${DateTime.now().year}y${DateTime.now().month}m${DateTime.now().day}");

    DateTime currentTime = await NTP.now();
    isQuiz.value = false;
    if (currentTime.hour < 13 ||
        (currentTime.hour == 13 && currentTime.minute <= 12)) {
      controller.todaysQuest = 0;
      startTime = DateTime(
          currentTime.year, currentTime.month, currentTime.day, 13, 11);
      endTime = DateTime(
          currentTime.year, currentTime.month, currentTime.day, 13, 12);
      dayRound = 1;
    } else if (currentTime.hour < 17 ||
        (currentTime.hour == 17 && currentTime.minute <= 56)) {
      startTime = DateTime(
          currentTime.year, currentTime.month, currentTime.day, 17, 55);
      endTime = DateTime(
          currentTime.year, currentTime.month, currentTime.day, 17, 56);
      dayRound = 2;
    } else if (currentTime.hour < 23 ||
        (currentTime.hour == 23 && currentTime.minute <= 12)) {
      startTime = DateTime(
          currentTime.year, currentTime.month, currentTime.day, 23, 11, 00);
      endTime = DateTime(
          currentTime.year, currentTime.month, currentTime.day, 23, 12, 00);
      dayRound = 3;
    } else {
      startTime = DateTime(
          currentTime.year, currentTime.month, currentTime.day, 13, 11);
      endTime = DateTime(
          currentTime.year, currentTime.month, currentTime.day, 13, 12);
    }

    if (currentTime.isAfter(startTime!) && currentTime.isBefore(endTime!)) {
      isQuiz.value = true;
      timeLeft.value = "Play Now";
    } else {
      debugPrint("Next At $startTime");
      if (startTime!.isAfter(currentTime)) {
        nextQuiz = startTime!.difference(currentTime).inSeconds;
      } else {
        nextQuiz = currentTime.difference(startTime!).inSeconds;
      }
    }
  }

  void waitForPlayers() async {
    controller.todaysQuest += 1;
    isQuiz.value = false;
    DateTime currentTime = await NTP.now();
    if (round != 1) {
      endTime = endTime!.add(const Duration(minutes: 1, seconds: 5));
    }
    Duration offset = endTime!.difference(currentTime);
    _elapsedTimer(() async {
      int second = secondsElapsed % 60;
      timeLeft.value =
          "${second.toString().padLeft(2, '0')}s \nwaiting for players";
      if (second <= 0) {
        debugPrint("Quiz started at $endTime, Round: $round");
        _timer!.cancel();
        isQuiz.value = true;
        if (round == 1) {
          final models = await categoryRepo.fetchQuizDate(
              id: "${DateTime.now().year}y${DateTime.now().month}m${DateTime.now().day}");
          quizModel = models;
        }

        if (quizModel != null) {
          nextPage();
        } else {
          debugPrint("Contest not loaded!");
        }
      }
    }, offset.inSeconds);
  }

  void registerUser() async {
    if (quizModel == null) return;
    debugPrint("Writing data");
    final id = controller.user!.id!;
    ParticipantModel model = ParticipantModel(
      id: id,
      gender: controller.user!.gender,
      address: controller.user!.address,
      round1: answers[0],
      round2: answers[1],
      round3: answers[2],
    );
    categoryRepo.addFriend(
        'contest', quizModel!.id!, '$dayRound', id, model.toMap());
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
    int seconds = 0;
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

  //Starts next quest round
  void _startNextRound() {
    time.value = "${secondsElapsed.toString().padLeft(2, "0")} secs";
    if (secondsElapsed <= 0) {
      _timer!.cancel();
      if (round != 1) {
        waitForPlayers();
      }
      Get.offAll(
        () => const HomeScreen(),
      );
    }
  }

  void _elapsedTimer(Function onTimeEnd, int tTime) {
    if (_timer != null) _timer!.cancel();
    time.value = "${tTime.toString().padLeft(2, "0")} secs";
    secondsElapsed = tTime;
    const duration = Duration(seconds: 1);
    _timer = Timer.periodic(duration, (Timer timer) {
      onTimeEnd();
      secondsElapsed--;
    });
  }

  //When user answers all the four questions
  void _onQuizEnd() async {
    registerUser();
    _qTimer!.cancel();
    _timer!.cancel();
    currentQuestion = -1;
    round++;
    round = max(round % 4, 1);
    DateTime currentTime = await NTP.now();
    DateTime resultTime = endTime!.add(
      const Duration(minutes: 1, seconds: 2),
    );

    Duration deltaTime = resultTime.difference(currentTime);
    if (round != 1) {
      _elapsedTimer(_startNextRound, deltaTime.inSeconds);
    } else {
      _elapsedTimer(_switchToMatchScreen, deltaTime.inSeconds);
    }
    Get.offAll(() => QuestEndScreen());
  }

  void _switchToMatchScreen() async {
    int seconds = secondsElapsed % 60;
    if (secondsElapsed <= 0) {
      _timer!.cancel();

      Get.offAll(() => MatchScreen(
            round: "$dayRound",
          ));
    }
    time.value = "${seconds.toString().padLeft(2, '0')} secs";
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
      _onQuizEnd();
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
    if (currentQuestion == 3) {
      _qTimer!.cancel();
      nextPage();
    }
  }

  @override
  void onClose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.onClose();
  }
}
