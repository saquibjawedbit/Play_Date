import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_dates/Utlis/Colors/theme_color.dart';
import 'package:play_dates/Utlis/Paints/outlined_text.dart';
import 'package:play_dates/Utlis/Widgets/custom_dialog_box.dart';

class MatchScreen extends StatelessWidget {
  const MatchScreen({super.key, required this.match});

  final bool match;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: sandColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 36,
          ),
          child: Center(
            child: Column(
              children: [
                const AppTitle(),
                SizedBox(
                  height: min(36, 36.h),
                ),
                if (match)
                  RichText(
                    text: TextSpan(
                      text: "It's a ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: min(40, 40.sp),
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: "Match!",
                          style: TextStyle(
                            fontSize: min(56, 56.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (!match)
                  Text(
                    "You couldn't find a match",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: min(36, 36.sp),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                SizedBox(
                  height: min(30, 30.h),
                ),
                if (match) matchWidget(),
                if (!match)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/02.png",
                          height: min(200, 200.h),
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                          height: min(10, 10.h),
                        ),
                        Text(
                          "But your match might be just around the corner",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: min(18, 18.sp),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(
                  height: min(40, 40.h),
                ),
                if (match)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: horButton(
                          "Chat",
                          const Color.fromARGB(255, 127, 159, 188),
                          min(164, 164.w),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => CustomDialogBox(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 12),
                              content: premiumDialogBox(),
                            ),
                          );
                        },
                        child: horButton(
                          "Swap",
                          const Color.fromARGB(255, 255, 102, 102),
                          min(164.w, 164),
                        ),
                      ),
                    ],
                  ),
                if (!match)
                  horButton(
                    "Next Quest in 00:00:00",
                    const Color.fromARGB(255, 127, 159, 188),
                    null,
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Stack matchWidget() {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              profileImage(),
              SizedBox(
                height: min(10, 10.h),
              ),
              Text(
                "Hank",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: min(32, 32.sp),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: min(100, 100.h),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Column(
            children: [
              Text(
                "Natie",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: min(32, 32.sp),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: min(10, 10.h),
              ),
              profileImage(),
            ],
          ),
        ),
      ],
    );
  }

  Column premiumDialogBox() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedText(
          text: "Want more Swaps?",
          fontSize: min(31, 31.sp),
          textColor: const Color.fromARGB(255, 255, 208, 0),
          borderColor: Colors.black,
          offset: const Offset(2, 5),
        ),
        SizedBox(
          height: min(20, 20.h),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Buy ",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: min(20, 20.sp),
              ),
            ),
            SizedBox(
              width: min(150, 150.w),
              child: const FittedBox(
                child: AppTitle(),
              ),
            ),
            Text(
              "    premium",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: min(20, 20.sp),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "At just",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: min(20, 20.sp),
              ),
            ),
            Text(
              " Rs 99.",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: min(36, 36.sp),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Container horButton(String text, Color color, double? width) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 2,
        vertical: 12,
      ),
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.black, width: 2.0),
        boxShadow: const [
          BoxShadow(
            spreadRadius: 1,
            color: Colors.black,
            offset: Offset(2, 4),
          )
        ],
      ),
      child: SizedBox(
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontSize: min(28, 28.sp),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Container profileImage() {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 2.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              spreadRadius: 2,
              offset: Offset(5, 2),
            )
          ]),
      child: CircleAvatar(
        backgroundColor: Colors.green,
        radius: min(96, 96.sp),
      ),
    );
  }
}

class AppTitle extends StatelessWidget {
  const AppTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 245, 27, 55),
        border: Border.all(color: Colors.black, width: 5.0),
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 1,
            offset: Offset(5, 5),
          ),
        ],
      ),
      child: OutlinedText(
        text: "playDates.",
        textColor: const Color.fromARGB(255, 235, 240, 0),
        fontSize: min(64, 64.sp),
        borderColor: Colors.black,
        offset: const Offset(2, 2),
      ),
    );
  }
}
