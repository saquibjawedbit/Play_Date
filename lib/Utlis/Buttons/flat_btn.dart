import 'package:flutter/material.dart';

class FlatBtn extends StatefulWidget {
  const FlatBtn({
    super.key,
    required this.onTap,
    required this.text,
  });

  final Function() onTap;
  final String text;

  @override
  State<FlatBtn> createState() => _FlatBtnState();
}

class _FlatBtnState extends State<FlatBtn> {
  Color color = const Color.fromARGB(255, 255, 208, 0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          color = Colors.white;
        });
        widget.onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 12),
        decoration: BoxDecoration(
            color: color,
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
          widget.text,
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
