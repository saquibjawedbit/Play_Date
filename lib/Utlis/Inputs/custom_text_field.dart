import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.keyboardType,
    required this.hintText,
    required this.fontSize,
    required this.padding,
    this.textAlign = TextAlign.left,
    this.color = Colors.white,
    required this.controller,
  });

  final TextInputType keyboardType;
  final String hintText;
  final double fontSize;
  final EdgeInsets padding;
  final TextAlign? textAlign;
  final Color? color;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textAlign: textAlign!,
      keyboardType: keyboardType,
      style: TextStyle(
        color: Colors.black,
        fontSize: fontSize,
      ),
      decoration: InputDecoration(
        contentPadding: padding,
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color.fromARGB(255, 51, 51, 51),
          fontSize: 14,
        ),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        fillColor: color,
      ),
    );
  }
}
