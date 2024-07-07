import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_dates/Utlis/Colors/theme_color.dart';
import 'package:play_dates/Utlis/Paints/outlined_text.dart';
import 'package:play_dates/Utlis/Widgets/custom_dialog_box.dart';

class MatchScreen extends StatelessWidget {
  const MatchScreen({super.key});

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
                  height: min(80, 80.sp),
                ),
                RichText(
                  text: const TextSpan(
                    text: "It's a ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: "Match!",
                        style: TextStyle(fontSize: 56),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: min(40, 40.sp),
                ),
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          profileImage(),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Hank",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 32,
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
                          const Text(
                            "Natie",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          profileImage(),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: min(20, 20.h),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => CustomDialogBox(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 40, horizontal: 12),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  OutlinedText(
                                    text: "Want more Swaps?",
                                    fontSize: min(31, 31.sp),
                                    textColor:
                                        const Color.fromARGB(255, 255, 208, 0),
                                    borderColor: Colors.black,
                                    offset: const Offset(2, 5),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  RichText(
                                    text: const TextSpan(
                                      text: "Buy PlayDates. premium",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                      ),
                                      children: [
                                        TextSpan(text: "\nAt just"),
                                        TextSpan(
                                          text: " Rs 99.",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 36,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: horButton(
                            "Chat", const Color.fromARGB(255, 127, 159, 188))),
                    horButton("Swap", const Color.fromARGB(255, 255, 102, 102)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container horButton(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 2,
        vertical: 6,
      ),
      width: min(164, 164.w),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
