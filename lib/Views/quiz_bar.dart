import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_dates/Utlis/Colors/theme_color.dart';
import 'package:play_dates/Utlis/Widgets/indicator_linear.dart';

import '../Utlis/Widgets/triangular_conatiner.dart';

class QuizBar extends StatelessWidget {
  const QuizBar({
    super.key,
    required this.percent,
    required this.round,
  });

  final double percent;
  final int round;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: sandColor,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: min(20, 20.h)),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Positioned(
            left: min(50, 50.w),
            child: IndicatorLinear(
              percent: round == 1 ? percent : 1,
              backgroundColor: Colors.black,
              animation: false,
              padding: const EdgeInsets.only(
                // right: 40,
                top: 32,
                bottom: 32,
                left: 20,
              ),
              width: max(70, 70.w),
            ),
          ),
          Positioned(
            left: min(140, 140.w),
            child: IndicatorLinear(
              percent: round <= 2 ? (round == 2 ? percent : 0) : 1,
              backgroundColor: Colors.black,
              animation: false,
              padding: const EdgeInsets.only(
                // right: 40,
                top: 32,
                bottom: 32,
                left: 20,
              ),
              width: max(70, 70.w),
            ),
          ),
          Positioned(
            left: min(240, 240.w),
            child: IndicatorLinear(
              percent: round <= 3 ? (round == 3 ? percent : 0) : 1,
              backgroundColor: Colors.black,
              animation: false,
              padding: const EdgeInsets.only(
                // right: 40,
                top: 32,
                bottom: 32,
                left: 20,
              ),
              width: max(70, 70.w),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < 3; i++)
                TriangularConatiner(
                  color: (round) >= (i + 1)
                      ? const Color.fromARGB(255, 219, 22, 47)
                      : const Color.fromARGB(255, 186, 252, 162),
                  fontColor: (round) >= (i + 1)
                      ? const Color.fromARGB(255, 219, 223, 172)
                      : Colors.black,
                  text: (i + 1).toString(),
                ),
              Container(
                margin: const EdgeInsets.only(
                  left: 20,
                ),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      spreadRadius: 5,
                      offset: Offset(4, 2),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundImage: const AssetImage("assets/quiz_icon.png"),
                  radius: min(32, 32.w),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
