import 'dart:collection';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:play_dates/Screens/home_screen.dart';
import 'package:play_dates/Utlis/Colors/theme_color.dart';
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
  Color? color;

  final QuizController controller = Get.find();

  void onTap(context) {
    setState(() {
      color = Colors.red;
    });
    controller.submitAns(widget.option);
    controller.nextPage();
    //showDialog(context: context, builder: (context) => const CustomDialogBox());
  }

  @override
  Widget build(BuildContext context) {
    color = widget.color;
    return GestureDetector(
      onTap: () {
        onTap(context);
      },
      child: AnimatedContainer(
        duration: const Duration(seconds: 1),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 23,
        ),
        decoration: BoxDecoration(
          color: color,
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

class CustomDialogBox extends StatelessWidget {
  const CustomDialogBox({super.key});

  static List<Shadow> outlinedText(
      {double strokeWidth = 2,
      Color strokeColor = Colors.black,
      int precision = 5}) {
    Set<Shadow> result = HashSet();
    for (int x = 1; x < strokeWidth + precision; x++) {
      for (int y = 1; y < strokeWidth + precision; y++) {
        double offsetX = x.toDouble();
        double offsetY = y.toDouble();
        result.add(Shadow(
            offset: Offset(-strokeWidth / offsetX, -strokeWidth / offsetY),
            color: strokeColor));
        result.add(Shadow(
            offset: Offset(-strokeWidth / offsetX, strokeWidth / offsetY),
            color: strokeColor));
        result.add(Shadow(
            offset: Offset(strokeWidth / offsetX, -strokeWidth / offsetY),
            color: strokeColor));
        result.add(Shadow(
            offset: Offset(strokeWidth / offsetX, strokeWidth / offsetY),
            color: strokeColor));
      }
    }
    return result.toList();
  }

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
                  Text(
                    "Instructions",
                    style: TextStyle(
                      shadows: outlinedText(strokeWidth: 2.2, precision: 0),
                      fontSize: 32,
                      color: Colors.yellow,
                      letterSpacing: 2,
                    ),
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
                decoration:
                    const BoxDecoration(shape: BoxShape.circle, boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    spreadRadius: 2,
                    offset: Offset(5, 1),
                  )
                ]),
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
          ],
        ),
      ),
    );
  }
}
