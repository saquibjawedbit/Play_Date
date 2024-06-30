import 'package:flutter/material.dart';
import '../Colors/theme_color.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    super.key,
    required this.icons,
    required this.onPressed,
    this.shape,
  });

  final IconData icons;
  final Function() onPressed;
  final OutlinedBorder? shape;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      onPressed: onPressed,
      icon: Icon(icons),
      iconSize: 24,
      color: Colors.black,
      padding: const EdgeInsets.all(8),
      style: IconButton.styleFrom(
        backgroundColor: sbColor,
        shape: shape,
      ),
    );
  }
}
