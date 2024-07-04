import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:play_dates/Utlis/Colors/theme_color.dart';
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
                    builder: (context) => const CustomDialogBox());
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
                  controller.time.toString(),
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
