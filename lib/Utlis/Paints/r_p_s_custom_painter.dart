import 'package:flutter/material.dart';

class RPSCustomPainter extends CustomPainter {
  final Color color;

  RPSCustomPainter({super.repaint, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_fill_1 = Paint()
      ..color = const Color.fromARGB(255, 0, 0, 0)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    Path path_1 = Path();
    Offset offset = const Offset(8, 2);
    path_1.moveTo(
        size.width * 0.48 + offset.dx, size.height * 0.250 + offset.dy);
    path_1.lineTo(
        size.width * 0.250 + offset.dx, size.height * 0.500 + offset.dy);
    path_1.lineTo(
        size.width * 0.500 + offset.dx, size.height * 0.750 + offset.dy);
    path_1.lineTo(
        size.width * 0.750 + offset.dx, size.height * 0.500 + offset.dy);
    path_1.lineTo(
        size.width * 0.500 + offset.dx, size.height * 0.250 + offset.dy);
    path_1.close();

    canvas.drawPath(path_1, paint_fill_1);

    // Layer 1

    Paint paint_fill_0 = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    Path path_0 = Path();
    path_0.moveTo(size.width * 0.5, size.height * 0.250);
    path_0.lineTo(size.width * 0.250, size.height * 0.500);
    path_0.lineTo(size.width * 0.500, size.height * 0.750);
    path_0.lineTo(size.width * 0.750, size.height * 0.500);
    path_0.lineTo(size.width * 0.500, size.height * 0.250);
    path_0.close();

    canvas.drawPath(path_0, paint_fill_0);

    // Layer 1

    Paint paintStroke = Paint()
      ..color = const Color.fromARGB(255, 0, 0, 0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.05
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.miter;

    canvas.drawPath(path_0, paintStroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
