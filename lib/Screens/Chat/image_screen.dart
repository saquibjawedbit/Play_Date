import 'package:flutter/material.dart';

class ImageScreen extends StatelessWidget {
  const ImageScreen({
    super.key,
    required this.imagePath,
  });

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox(
          child: Image.network(
            imagePath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
