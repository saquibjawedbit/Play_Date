import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:play_dates/Utlis/Paints/outlined_text.dart';
import 'package:play_dates/controllers/quiz_controller.dart';
import '../Utlis/Buttons/flat_btn.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final QuizController quizController = Get.put(QuizController());

  bool _selected = false;
  bool _isLoading = true;
  Color? color;

  @override
  void initState() {
    super.initState();
    start();
  }

  void start() async {
    await quizController.loadData();
    setState(() {
      _isLoading = false;
    });
    if (!_isLoading && !quizController.isQuiz) quizController.start();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final round = quizController.round;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 239, 223),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : Stack(
              children: [
                if (round != 2) bannerOne(height, width),
                if (round == 2) lionImage(),
                Padding(
                  padding: EdgeInsets.only(top: 120.h, left: 32.w, right: 32.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TitleBanner(
                        selected: _selected,
                        round: round,
                      ),
                      SizedBox(
                        height: 60.h,
                      ),
                      OutlinedText(
                        text: "Instructions",
                        fontSize: min(34, 34.sp),
                        textColor: Colors.white,
                        borderColor: Colors.black,
                        offset: const Offset(1, 4),
                        letterSpacing: 0,
                        strokeWidth: 2,
                      ),
                      const InfoBox(),
                      SizedBox(
                        height: 40.h,
                      ),
                      Obx(
                        () => FlatBtn(
                          onTap: !quizController.isQuiz
                              ? null
                              : () {
                                  setState(() {
                                    color = Colors.white;
                                    _selected = true;
                                  });
                                  Future.delayed(
                                    const Duration(milliseconds: 1000),
                                    () {
                                      setState(() {
                                        color = Colors.white;
                                        _selected = false;
                                      });
                                      Future.delayed(
                                        const Duration(milliseconds: 1000),
                                        () {
                                          quizController.nextPage();
                                        },
                                      );
                                    },
                                  );
                                },
                          text: "${quizController.timeLeft}",
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
                if (round != 2) jokerImage(),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(items: const [
        BottomNavigationBarItem(icon: Icon(Icons.add), label: "hello"),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: "hello"),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: "hello"),
      ]),
    );
  }

  AnimatedPositioned jokerImage() {
    return AnimatedPositioned(
      left: _selected ? 80 : -20,
      top: -10,
      duration: const Duration(milliseconds: 300),
      child: Image.asset(
        'assets/02.png',
        height: min(150.h, 150),
        fit: BoxFit.cover,
      ),
    );
  }

  Align lionImage() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Image.asset(
        'assets/06.png',
        fit: BoxFit.cover,
        height: min(350, 350.h),
      ),
    );
  }

  AnimatedPositioned bannerOne(double height, double width) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 400),
      top: _selected ? height - 380.h : height - 400.h,
      left: _selected ? width - 240.w : width - 160.w,
      child: Image.asset(
        'assets/04.png',
        fit: BoxFit.cover,
        height: min(360, 360.h),
      ),
    );
  }
}

class InfoBox extends StatelessWidget {
  const InfoBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.help_outline_sharp),
              SizedBox(
                width: min(10.w, 10),
              ),
              Text(
                "4 questions in the quest",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: min(18, 18.sp),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.alarm),
              SizedBox(
                width: min(10, 10.w),
              ),
              Text(
                "10 secs each question",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: min(18, 18.sp),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.info_outline_rounded),
              SizedBox(
                width: 10.w,
              ),
              Text(
                "Don't panic, Don't lie",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: min(18, 18.sp),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TitleBanner extends StatelessWidget {
  const TitleBanner({
    super.key,
    required this.selected,
    required this.round,
  });

  final bool selected;
  final int round;

  @override
  Widget build(BuildContext context) {
    final List<String> val = ["One", "Two", "Three"];
    return ClipRect(
      child: SizedBox(
        width: min(380.w, 380),
        height: min(200, 200.h),
        child: Stack(
          children: [
            Ink(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.black,
                  width: 5.0,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    spreadRadius: 4,
                    offset: Offset(5, 5),
                  )
                ],
              ),
              child: Stack(
                children: round != 2
                    ? questOneBanner(val)
                    : [
                        Align(
                          alignment: Alignment.topCenter,
                          child: OutlinedText(
                            text: "The Secret",
                            fontSize: min(48, 48.sp),
                            textColor: const Color.fromARGB(255, 132, 215, 255),
                            borderColor: Colors.black,
                            offset: const Offset(-5, 5),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: OutlinedText(
                            text: "Library",
                            fontSize: min(78, 78.sp),
                            textColor: const Color.fromARGB(255, 255, 151, 217),
                            borderColor: Colors.black,
                            offset: const Offset(5, 5),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            "Quest ${val[round - 1]}",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: min(28.sp, 28),
                            ),
                          ),
                        ),
                      ],
              ),
            ),
            if (round != 2)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                top: selected ? 10 : 0,
                left: selected ? -10 : 0,
                child: FractionalTranslation(
                  translation: const Offset(-.15, 0.6),
                  child: Image.asset(
                    "assets/rainbow.png",
                    height: min(150, 150.h),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> questOneBanner(List<String> val) {
    return [
      Align(
        alignment: Alignment.topCenter,
        child: OutlinedText(
          text: " Chamber Of ",
          fontSize: min(48, 48.sp),
          textColor: const Color.fromARGB(255, 235, 240, 0),
          borderColor: Colors.black,
          offset: const Offset(-5, 4.5),
        ),
      ),
      Positioned(
        top: 20,
        left: 90,
        child: Stack(
          children: [
            RotationTransition(
              turns: const AlwaysStoppedAnimation(-4.86 / 360),
              child: OutlinedText(
                text: " Lies",
                fontSize: min(77, 77.sp),
                textColor: Colors.black,
                borderColor: Colors.black,
                offset: const Offset(-5, 4.5),
              ),
            ),
            AnimatedRotation(
              turns: selected ? 0 / 360 : -4.86 / 360,
              duration: const Duration(milliseconds: 300),
              child: OutlinedText(
                text: "Lies",
                fontSize: min(77, 77.sp),
                textColor: const Color.fromARGB(255, 132, 215, 255),
                borderColor: Colors.black,
                offset: const Offset(-5, 4.5),
              ),
            ),
            AnimatedRotation(
              turns: selected ? 5 / 360 : -4.86 / 360,
              duration: const Duration(milliseconds: 300),
              child: OutlinedText(
                text: "Lies",
                fontSize: min(77, 77.sp),
                textColor: const Color.fromARGB(255, 255, 151, 217),
                borderColor: Colors.black,
                offset: const Offset(-5, 4.5),
              ),
            ),
            AnimatedRotation(
              turns: selected ? 10 / 360 : -4.86 / 360,
              duration: const Duration(milliseconds: 300),
              child: OutlinedText(
                text: "Lies",
                fontSize: min(77, 77.sp),
                textColor: const Color.fromARGB(255, 219, 22, 47),
                borderColor: Colors.black,
                offset: const Offset(-5, 4.5),
              ),
            ),
          ],
        ),
      ),
      Align(
        alignment: Alignment.bottomRight,
        child: Text(
          "Quest ${val[round - 1]}",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: min(28.sp, 28),
          ),
        ),
      ),
    ];
  }
}
