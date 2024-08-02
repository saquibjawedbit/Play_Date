import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:play_dates/Screens/Quiz/match_screen.dart';
import 'package:play_dates/Utlis/Colors/theme_color.dart';
import 'package:play_dates/Utlis/Models/user_model.dart';
import 'package:play_dates/Utlis/Paints/outlined_text.dart';
import 'package:play_dates/controllers/user_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int index = 0;

  final UserController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final user = controller.user;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 251, 255, 204),
        body: CustomPaint(
          painter: ProfilePainter(),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 0,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const AppTitle(),
                  SizedBox(
                    height: min(20, 20.h),
                  ),
                  Stack(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: min(36, 36.w),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(
                                () {
                                  index = (index + 1) % 4;
                                },
                              );
                            },
                            child: _profileContainer(user),
                          ),
                          SizedBox(
                            width: min(36, 36.w),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 16,
                        left: 50,
                        child: Row(
                          children: [
                            for (int i = 0; i < 4; i++)
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                width: min(56, 56.h),
                                height: min(4, 4.h),
                                decoration: BoxDecoration(
                                  color: (i == index)
                                      ? Colors.black
                                      : const Color.fromARGB(255, 56, 57, 97),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 80,
                        left: 60,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            OutlinedText(
                              text: "${user!.name},",
                              fontSize: min(48, 48.sp),
                              textColor: Colors.white,
                              borderColor: Colors.black,
                              offset: const Offset(-5, 5),
                            ),
                            SizedBox(
                              width: min(10, 10.w),
                            ),
                            OutlinedText(
                              text: "${user.age}",
                              fontSize: min(48, 48.sp),
                              textColor: const Color.fromARGB(255, 250, 255, 0),
                              borderColor: Colors.black,
                              offset: const Offset(-5, 5),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 48,
                        left: 60,
                        child: OutlinedText(
                          text: "Student.",
                          fontSize: min(36, 36.sp),
                          textColor: Colors.white,
                          borderColor: Colors.black,
                          offset: const Offset(-5, 5),
                        ),
                      ),
                      Positioned(
                        top: 20,
                        left: 40,
                        child: Image.asset(
                          'assets/start_image.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: SizedBox(
                          height: min(120, 120.h),
                          width: min(120, 120.w),
                          child: Stack(
                            children: [
                              Image.asset(
                                'assets/Side_btn.png',
                              ),
                              const Align(
                                alignment: Alignment(0.26, 0.26),
                                child: Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.black,
                                  size: 80,
                                ),
                              ),
                              const Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: 80,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: min(20, 20.h),
                  ),
                  statBar()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  AnimatedContainer _profileContainer(UserModel? user) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        image: DecorationImage(
          image: NetworkImage(
            user!.imageUrls[index],
          ),
          fit: BoxFit.fill,
        ),
        border: Border.all(
          color: Colors.black,
          width: 3,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 0.5,
            offset: Offset(13, 13),
          )
        ],
      ),
      height: min(450, 450.h),
      width: min(320, 320.h),
    );
  }

  Stack statBar() {
    return Stack(
      fit: StackFit.loose,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: min(32, 32.h),
            ),
            Center(
              child: Container(
                width: min(350, 350.w),
                decoration: BoxDecoration(
                  color: bColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.only(
                    left: 24, right: 24, top: 32, bottom: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/green_diamond.png',
                          height: min(24, 24.h),
                          fit: BoxFit.fill,
                        ),
                        Text(
                          "You performed in 2 quests today",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: min(16, 16.sp),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/green_diamond.png',
                          height: min(24, 24.sp),
                          fit: BoxFit.fill,
                        ),
                        Text(
                          "You have 3 matches we are proud!",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: min(16, 16.sp),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: min(10, 10.h),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.topCenter,
          child: OutlinedText(
            text: "Stats",
            fontSize: min(40, 40.sp),
            textColor: const Color.fromARGB(255, 255, 255, 0),
            borderColor: Colors.black,
            offset: const Offset(-5, 5),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 24,
          child: Image.asset(
            'assets/green_heart.png',
            fit: BoxFit.fill,
          ),
        ),
      ],
    );
  }
}

class ProfilePainter extends CustomPainter {
  ProfilePainter({super.repaint});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = bColor
      ..strokeWidth = 1.5;

    Offset start = Offset(size.width / 4, 0);
    Offset end = Offset(size.width / 4, size.height);

    canvas.drawLine(start, end, paint);
    canvas.drawLine(
        Offset(size.width / 2, 0), Offset(size.width / 2, size.height), paint);
    canvas.drawLine(Offset(3 * size.width / 4, 0),
        Offset(3 * size.width / 4, size.height), paint);

    for (int i = 1; i <= 6; i++) {
      canvas.drawLine(Offset(0, i * size.height / 7),
          Offset(size.width, i * size.height / 7), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
