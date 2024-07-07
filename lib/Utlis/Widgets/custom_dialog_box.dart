import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:play_dates/Utlis/Colors/theme_color.dart';

class CustomDialogBox extends StatelessWidget {
  const CustomDialogBox(
      {super.key, required this.content, required this.padding});

  final Widget content;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              // margin: EdgeInsets.symmetric(horizontal: 0.01 * width),
              padding: padding,
              width: width,

              decoration: BoxDecoration(
                color: sandColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    spreadRadius: 1,
                    offset: Offset(5, 5),
                  ),
                ],
              ),
              child: content,
            ),
            Positioned(
              top: -28,
              left: (width) / 2 + 50,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      spreadRadius: 2,
                      offset: Offset(5, 1),
                    )
                  ],
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const CircleAvatar(
                    minRadius: 16,
                    maxRadius: 28,
                    backgroundColor: Color.fromARGB(255, 255, 105, 180),
                    child: Icon(
                      Icons.close,
                      size: 40,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
