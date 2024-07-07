import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:play_dates/Screens/Quiz/home_screen.dart';
import 'package:play_dates/Utlis/Colors/theme_color.dart';
import 'package:play_dates/Utlis/Paints/outlined_text.dart';
import 'package:play_dates/Utlis/Widgets/custom_dialog_box.dart';
import 'package:play_dates/controllers/quiz_controller.dart';

class TimeBar extends StatelessWidget {
  TimeBar({
    super.key,
  });

  final QuizController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => const CustomDialogBox(
                    content: QuizInfoContent(),
                    padding: EdgeInsets.only(
                        top: 20, left: 12, right: 44, bottom: 30),
                  ),
                );
              },
              child: const Icon(
                Icons.info_outline_rounded,
                color: sbColor,
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Obx(
              () => Text(
                controller.question.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: min(16, 16.sp),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() => Text(
                  controller.tTime.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: min(16, 16.sp),
                  ),
                )),
            SizedBox(
              width: 10.w,
            ),
            const Icon(
              Icons.access_time,
              color: sbColor,
            ),
          ],
        ),
      ],
    );
  }
}

class QuizInfoContent extends StatelessWidget {
  const QuizInfoContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 10,
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
        const SizedBox(
          height: 10,
        ),
        const InfoBox(),
      ],
    );
  }
}
