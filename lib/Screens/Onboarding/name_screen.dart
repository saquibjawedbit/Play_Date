import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:play_dates/Utlis/Inputs/custom_text_field.dart';
import 'package:play_dates/Utlis/Colors/theme_color.dart';
import 'package:play_dates/Utlis/Inputs/small_text_bar.dart';
import 'package:play_dates/Screens/Onboarding/gender_screen.dart';
import 'package:play_dates/Utlis/Widgets/indicator_linear.dart';
import 'package:play_dates/controllers/user_controller.dart';

class NameScreen extends StatelessWidget {
  final UserController userController = Get.put(UserController());

  final TextEditingController name = TextEditingController();
  final TextEditingController day = TextEditingController();
  final TextEditingController month = TextEditingController();
  final TextEditingController year = TextEditingController();

  NameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: bColor,
        floatingActionButton: FloatingActionButton(
          backgroundColor: sbColor,
          shape: const CircleBorder(),
          onPressed: () {
            if (name.text.isNotEmpty &&
                day.text.isNotEmpty &&
                month.text.isNotEmpty &&
                year.text.isNotEmpty) {
              final bool res = userController.updateName(
                  name.text, day.text, month.text, year.text);
              if (res) {
                Get.offAll(
                  () => const GenderScreen(),
                  transition: Transition.rightToLeft,
                );
              }
            }
          },
          child: const Icon(Icons.arrow_forward_ios_sharp),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const IndicatorLinear(percent: 0.2),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hold your Horses, Give us an intro.",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Your first name",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    CustomTextField(
                      controller: name,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 14,
                      ),
                      keyboardType: TextInputType.name,
                      fontSize: 20,
                      hintText: "",
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Your Birthday",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SmallTextBar(
                          title: "Day",
                          controller: day,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SmallTextBar(
                          title: "Month",
                          controller: month,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SmallTextBar(
                          title: "Year",
                          controller: year,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
