import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:play_dates/Screens/Onboarding/image_picker_screen.dart';
import 'package:play_dates/Utlis/Inputs/custom_text_field.dart';
import 'package:play_dates/Utlis/Colors/theme_color.dart';
import 'package:play_dates/controllers/user_controller.dart';

import '../../Utlis/Widgets/indicator_linear.dart';

class AddressScreen extends StatelessWidget {
  AddressScreen({
    super.key,
  });

  final UserController userController = Get.find();
  final TextEditingController address = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: bColor,
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          backgroundColor: sbColor,
          shape: const CircleBorder(),
          onPressed: () {
            if (address.text.isEmpty) return;
            userController.updateAddress(address.text);
            Get.offAll(
              () => const ImagePickerScreen(),
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
                percent: 0.6,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Finally, tell us where you live.",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Write your address down below so that we can match you up with people around you.",
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Text(
                    "Your Address",
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    controller: address,
                    //onComplete: () {},
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 18,
                    ),
                    keyboardType: TextInputType.streetAddress,
                    fontSize: 24,
                    hintText: "",
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
