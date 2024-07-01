import 'package:flutter/material.dart';
import '../Paints/r_p_s_custom_painter.dart';

class TriangularConatiner extends StatelessWidget {
  const TriangularConatiner({
    super.key,
    required this.color,
    required this.text,
  });

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RPSCustomPainter(color: color),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 30),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
