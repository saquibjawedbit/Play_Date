import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:play_dates/Screens/Onboarding/image_picker_screen.dart';
import 'package:play_dates/Utlis/Colors/theme_color.dart';
import 'package:play_dates/controllers/user_controller.dart';

import '../../Utlis/Widgets/indicator_linear.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({
    super.key,
  });

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final UserController userController = Get.find();
  final List<String> _dropdownMenuItems = [
    "LNMIIT, Jaipur, Rajasthan",
    "BIT MESRA, Ranchi, Jharkhand",
    "IIT Roorkee, Roorkee, Uttarakhand"
  ];

  String? _selectedValues;

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
            if (_selectedValues == null) return;
            userController.updateAddress(_selectedValues!);
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
                  SizedBox(
                    child: DropdownButtonFormField<String>(
                      value: _selectedValues,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 24,
                        ),
                        hintText: "Select Your University",
                        hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 51, 51, 51),
                          fontSize: 14,
                        ),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Colors.white,
                      ),
                      items: _dropdownMenuItems.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: min(18, 18.sp),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedValues = newValue!;
                        });
                      },
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
