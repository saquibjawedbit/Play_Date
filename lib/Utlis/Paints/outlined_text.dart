import 'package:flutter/material.dart';

class OutlinedText extends StatelessWidget {
  const OutlinedText({
    super.key,
    required this.text,
    required this.fontSize,
    this.strokeWidth,
    required this.textColor,
    required this.borderColor,
    required this.offset,
    this.letterSpacing,
  });

  final String text;
  final double fontSize;
  final double? strokeWidth;
  final Color textColor;
  final Color borderColor;
  final Offset offset;
  final double? letterSpacing;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            letterSpacing: letterSpacing,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth ?? 5
              ..color = borderColor,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            letterSpacing: letterSpacing,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: borderColor,
                offset: offset,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
