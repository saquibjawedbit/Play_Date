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
    this.height,
  });

  final String text;
  final double fontSize;
  final double? strokeWidth;
  final Color textColor;
  final Color borderColor;
  final Offset offset;
  final double? letterSpacing;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          textAlign: TextAlign.center,
          maxLines: 1,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            letterSpacing: letterSpacing,
            height: height,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth ?? 5
              ..color = borderColor,
          ),
        ),
        Text(
          text,
          textAlign: TextAlign.center,
          maxLines: 1,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            height: height,
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
