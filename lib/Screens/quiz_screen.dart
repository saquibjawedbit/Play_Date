import 'package:flutter/material.dart';
import 'package:play_dates/Utlis/Colors/theme_color.dart';
import '../Utlis/Buttons/animated_btns.dart';
import '../Utlis/Widgets/time_bar.dart';
import '../Views/quiz_bar.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: bColor,
        body: Column(
          children: [
            const QuizBar(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Column(
                children: [
                  const TimeBar(),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    "You have a free afternoon. Where do you hangout?",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.white),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const AnimatedBtns(
                    color: Color.fromARGB(255, 255, 160, 122),
                    text: "Option 1",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const AnimatedBtns(
                    color: Color.fromARGB(255, 255, 178, 239),
                    text: "Option 2",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const AnimatedBtns(
                    color: Color.fromARGB(255, 253, 253, 150),
                    text: "Option 3",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const AnimatedBtns(
                    color: Color.fromARGB(255, 127, 188, 140),
                    text: "Option 4",
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
