import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:play_dates/Utlis/Colors/theme_color.dart';
import 'package:play_dates/Utlis/Models/quiz_model.dart';
import 'package:play_dates/controllers/quiz_controller.dart';
import '../Utlis/Buttons/animated_btns.dart';
import '../Utlis/Widgets/time_bar.dart';
import '../Views/quiz_bar.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({
    super.key,
    required this.questionData,
  });

  final QuizModel questionData;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final QuizController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: bColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            QuizBar(
              percent: controller.percent,
              round: controller.round,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 24,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TimeBar(),
                  SizedBox(
                    height: 30.h,
                  ),
                  SizedBox(
                    width: min(400, 400.w),
                    child: Text(
                      widget.questionData.question,
                      textAlign: TextAlign.start,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  AnimatedBtns(
                    option: 1,
                    color: Colors.white,
                    text: widget.questionData.option1,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  AnimatedBtns(
                    option: 2,
                    color: Colors.white,
                    text: widget.questionData.option2,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  AnimatedBtns(
                    option: 3,
                    color: Colors.white,
                    text: widget.questionData.option3,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  AnimatedBtns(
                    option: 4,
                    color: Colors.white,
                    text: widget.questionData.option4,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
