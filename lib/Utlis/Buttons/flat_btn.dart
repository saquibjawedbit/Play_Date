import 'package:flutter/material.dart';

class FlatBtn extends StatelessWidget {
  const FlatBtn({
    super.key,
    required this.onTap,
    required this.text,
  });

  final Function() onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(seconds: 1),
        padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 12),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 208, 0),
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
          text,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 32,
          ),
        ),
      ),
    );
  }
}
