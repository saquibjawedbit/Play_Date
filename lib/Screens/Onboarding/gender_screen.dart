import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:play_dates/Utlis/Buttons/left_aligned_btns.dart';
import 'package:play_dates/Utlis/Colors/theme_color.dart';
import 'package:play_dates/Screens/Onboarding/height_screen.dart';
import 'package:play_dates/Utlis/Widgets/indicator_linear.dart';
import 'package:play_dates/controllers/user_controller.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({
    super.key,
  });

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  final UserController userController = Get.find();
  bool _male = true;

  @override
  Widget build(BuildContext context) {
    final name = userController.name;
    return SafeArea(
      child: Scaffold(
        backgroundColor: bColor,
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          backgroundColor: sbColor,
          shape: const CircleBorder(),
          onPressed: () {
            userController.updateGender(_male);
            Get.offAll(
              () => HeightScreen(),
              transition: Transition.rightToLeft,
            );
          },
          child: const Icon(Icons.arrow_forward_ios_sharp),
        ),
        body: Stack(
          children: [
            const Align(
              alignment: Alignment.topCenter,
              child: IndicatorLinear(
                percent: 0.2,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hey $name, Great name.",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Let us know more about you, tell us your\ngender so that we can match you easily.",
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "What is your Gender?",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  LeftAlignedBtns(
                    text: "Woman",
                    backgroundColor: !_male ? sbColor : Colors.white,
                    onPressed: () {
                      setState(() {
                        _male = false;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  LeftAlignedBtns(
                    text: "Man",
                    backgroundColor: _male ? sbColor : Colors.white,
                    onPressed: () {
                      setState(() {
                        _male = true;
                      });
                    },
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
