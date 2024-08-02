import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:play_dates/Utlis/Buttons/flat_btn.dart';

class PickedImageScreen extends StatelessWidget {
  const PickedImageScreen({
    super.key,
    required this.imagePath,
  });

  final File imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            child: Image.file(
              imagePath,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(
            height: min(20, 20.h),
          ),
          FlatBtn(
            onTap: () {
              Get.back(result: true);
            },
            text: "SEND",
          ),
        ],
      ),
    );
  }
}
