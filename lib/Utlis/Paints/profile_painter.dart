import 'package:flutter/material.dart';
import 'package:play_dates/Utlis/Colors/theme_color.dart';

class ProfilePainter extends CustomPainter {
  ProfilePainter({super.repaint});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = bColor
      ..strokeWidth = 1.5;

    Offset start = Offset(size.width / 4, 0);
    Offset end = Offset(size.width / 4, size.height);

    canvas.drawLine(start, end, paint);
    canvas.drawLine(
        Offset(size.width / 2, 0), Offset(size.width / 2, size.height), paint);
    canvas.drawLine(Offset(3 * size.width / 4, 0),
        Offset(3 * size.width / 4, size.height), paint);

    for (int i = 1; i <= 6; i++) {
      canvas.drawLine(Offset(0, i * size.height / 7),
          Offset(size.width, i * size.height / 7), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
