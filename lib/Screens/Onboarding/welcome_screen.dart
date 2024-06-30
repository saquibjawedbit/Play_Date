import 'package:flutter/material.dart';
import 'package:play_dates/Utlis/Colors/theme_color.dart';
import 'package:play_dates/controllers/service/auth_service.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Get Started",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 50,
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
            const Text(
              "Welcome to Playdates!",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 2,
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
            const SizedBox(
              height: 80,
            ),
            ElevatedButton(
              onPressed: () {
                AuthService().signInWithGoogle();
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
                    height: 40,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text(
                    "Continue with Google",
                    style: TextStyle(
                      color: Color.fromARGB(200, 0, 0, 0),
                      fontSize: 20,
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
