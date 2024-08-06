import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_dates/Utlis/Colors/theme_color.dart';
import 'package:play_dates/controllers/service/auth_service.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    authService.checkInstallationId();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Get Started",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: min(50, 50.sp),
                fontWeight: FontWeight.w600,
                color: pColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Image.asset(
                "assets/01.png",
              ),
            ),
            Text(
              "Welcome to Playdates!",
              style: TextStyle(
                fontSize: min(18, 18.sp),
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: min(2.h, 2),
            ),
            const Text(
              "Every Quest is a Step Closer \n  Your Perfect Match!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: pColor,
                wordSpacing: -2,
              ),
            ),
            SizedBox(
              height: min(80, 80.h),
            ),
            ElevatedButton(
              onPressed: () {
                authService.signInWithGoogle();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shadowColor: Colors.black,
                elevation: 10,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.network(
                    'http://pngimg.com/uploads/google/google_PNG19635.png',
                    height: min(40, 40.h),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Continue with Google",
                    style: TextStyle(
                      color: const Color.fromARGB(200, 0, 0, 0),
                      fontSize: min(20, 20.sp),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
