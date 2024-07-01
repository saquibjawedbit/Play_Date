import 'package:flutter/material.dart';
import 'package:play_dates/Utlis/Colors/theme_color.dart';
import 'package:play_dates/Utlis/Models/quiz_model.dart';
import '../Utlis/Buttons/animated_btns.dart';
import '../Utlis/Widgets/time_bar.dart';
import '../Views/quiz_bar.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({
    super.key,
    required this.questionData,
  });

  final QuizModel questionData;

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
                  TimeBar(),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    questionData.question,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.white),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  AnimatedBtns(
                    option: 1,
                    color: const Color.fromARGB(255, 255, 160, 122),
                    text: questionData.option1,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AnimatedBtns(
                    option: 2,
                    color: const Color.fromARGB(255, 255, 178, 239),
                    text: questionData.option2,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AnimatedBtns(
                    option: 3,
                    color: const Color.fromARGB(255, 253, 253, 150),
                    text: questionData.option3,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AnimatedBtns(
                    option: 4,
                    color: const Color.fromARGB(255, 127, 188, 140),
                    text: questionData.option4,
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
