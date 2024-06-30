import 'package:flutter/material.dart';
import 'package:play_dates/Utlis/Colors/theme_color.dart';

import 'custom_text_field.dart';

class SmallTextBar extends StatelessWidget {
  const SmallTextBar({
    super.key,
    required this.title,
    required this.controller,
  });

  final String title;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          CustomTextField(
            controller: controller,
            fontSize: 20,
            keyboardType: TextInputType.datetime,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            hintText: "",
            textAlign: TextAlign.center,
            color: tColor,
          ),
        ],
      ),
    );
  }
}
