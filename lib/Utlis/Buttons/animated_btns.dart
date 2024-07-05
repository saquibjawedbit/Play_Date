import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:play_dates/controllers/quiz_controller.dart';

class AnimatedBtns extends StatefulWidget {
  const AnimatedBtns({
    super.key,
    required this.color,
    required this.text,
    required this.option,
  });

  final int option;
  final Color color;
  final String text;

  @override
  State<AnimatedBtns> createState() => _AnimatedBtnsState();
}

class _AnimatedBtnsState extends State<AnimatedBtns> {
  final Color color = const Color.fromARGB(255, 244, 215, 56);
  bool isTapped = false;

  final QuizController controller = Get.find();

  void onTap(context) {
    setState(() {
      isTapped = true;
    });
    controller.submitAns(widget.option);

    Future.delayed(const Duration(milliseconds: 500), () {
      controller.nextPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(context);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: min(400.w, 400),
        padding: const EdgeInsets.symmetric(
          vertical: 23,
          horizontal: 24,
        ),
        decoration: BoxDecoration(
          color: isTapped ? color : widget.color,
          borderRadius: BorderRadius.circular(100),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              spreadRadius: 5.0,
              offset: Offset(5, 3),
            )
          ],
        ),
        child: Center(
          child: Text(
            widget.text,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ),
    );
  }
}
