import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:play_dates/Utlis/Colors/theme_color.dart';
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
            const Icon(
              Icons.info_outline_rounded,
              color: sbColor,
            ),
            const SizedBox(
              width: 10,
            ),
            Obx(
              () => Text(
                controller.question.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                )),
            const SizedBox(
              width: 10,
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
