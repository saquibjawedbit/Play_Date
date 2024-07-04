import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Paints/r_p_s_custom_painter.dart';

class TriangularConatiner extends StatelessWidget {
  const TriangularConatiner({
    super.key,
    required this.color,
    required this.text,
    required this.fontColor,
  });

  final Color color;
  final Color fontColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RPSCustomPainter(color: color),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: min(42, 42.w),
          vertical: min(36.h, 36),
        ),
        child: Text(
          text,
          style: TextStyle(
              fontSize: min(20, 20.sp),
              fontWeight: FontWeight.w600,
              color: fontColor),
        ),
      ),
    );
  }
}
