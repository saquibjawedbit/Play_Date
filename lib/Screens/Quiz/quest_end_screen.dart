import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:play_dates/Utlis/Buttons/flat_btn.dart';
import 'package:play_dates/Utlis/Colors/theme_color.dart';
import 'package:play_dates/Utlis/Paints/outlined_text.dart';
import 'package:play_dates/controllers/quiz_controller.dart';

class QuestEndScreen extends StatelessWidget {
  QuestEndScreen({super.key});

  final QuizController quizController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: sandColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 120, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/05.png',
                height: min(160.h, 160),
              ),
              SizedBox(
                height: 30.h,
              ),
              OutlinedText(
                text: "Quest End",
                offset: const Offset(-6, 6),
                textColor: Colors.white,
                fontSize: min(64, 64.sp),
                borderColor: Colors.black,
              ),
              const SizedBox(
                height: 60,
              ),
              Text(
                "LeaderBoards in...",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: min(28, 28.sp),
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Obx(
                () => FlatBtn(onTap: () {}, text: "${quizController.time}"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
