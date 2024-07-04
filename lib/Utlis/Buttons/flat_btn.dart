import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FlatBtn extends StatefulWidget {
  const FlatBtn({
    super.key,
    required this.onTap,
    required this.text,
    this.color,
  });

  final Function() onTap;
  final String text;
  final Color? color;

  @override
  State<FlatBtn> createState() => _FlatBtnState();
}

class _FlatBtnState extends State<FlatBtn> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: EdgeInsets.symmetric(
            horizontal: min(44, 44.w), vertical: min(12.h, 12)),
        decoration: BoxDecoration(
            color: widget.color ?? const Color.fromARGB(255, 255, 208, 0),
            border: Border.all(
              width: 2,
              color: Colors.black,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                spreadRadius: 0.2,
                offset: Offset(7.5, 7.5),
              )
            ]),
        child: Text(
          widget.text,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: min(32, 32.sp),
          ),
        ),
      ),
    );
  }
}
