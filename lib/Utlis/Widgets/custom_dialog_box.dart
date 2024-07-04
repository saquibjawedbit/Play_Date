import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_dates/Screens/home_screen.dart';
import 'package:play_dates/Utlis/Colors/theme_color.dart';
import 'package:play_dates/Utlis/Paints/outlined_text.dart';

class CustomDialogBox extends StatelessWidget {
  const CustomDialogBox({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              // margin: EdgeInsets.symmetric(horizontal: 0.01 * width),
              padding: const EdgeInsets.only(
                  top: 20, left: 44, right: 44, bottom: 30),
              decoration: BoxDecoration(
                color: sandColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    spreadRadius: 1,
                    offset: Offset(5, 5),
                  ),
                ],
              ),
              child: Column(
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
              ),
            ),
            Positioned(
              top: -28,
              left: (width) / 2 + 50,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      spreadRadius: 2,
                      offset: Offset(5, 1),
                    )
                  ],
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const CircleAvatar(
                    minRadius: 16,
                    maxRadius: 28,
                    backgroundColor: Color.fromARGB(255, 255, 105, 180),
                    child: Icon(
                      Icons.close,
                      size: 40,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
