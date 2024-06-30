import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:play_dates/Utlis/Inputs/custom_text_field.dart';
import 'package:play_dates/Utlis/Colors/theme_color.dart';
import 'package:play_dates/Screens/Onboarding/address_screen.dart';
import 'package:play_dates/Utlis/Widgets/indicator_linear.dart';
import 'package:play_dates/controllers/user_controller.dart';

class HeightScreen extends StatelessWidget {
  HeightScreen({
    super.key,
  });

  final TextEditingController height = TextEditingController();
  final UserController userController = Get.find();

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
            if (!height.text.isNumericOnly) return;
            userController.updateHeight(height.text);
            Get.offAll(
              () => AddressScreen(),
              transition: Transition.rightToLeft,
            );
          },
          child: const Icon(Icons.arrow_forward_ios_sharp),
        ),
        body: Stack(
          children: [
            const Align(
              alignment: Alignment.topCenter,
              child: IndicatorLinear(percent: 0.6),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$name, tell us more about you.",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Choose your height, its okay if you wanna skip.",
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    "Your Height",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  CustomTextField(
                    controller: height,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 18,
                    ),
                    keyboardType: TextInputType.number,
                    fontSize: 24,
                    hintText: "cm",
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
