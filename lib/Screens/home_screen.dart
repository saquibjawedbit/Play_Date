import 'package:flutter/material.dart';
import 'package:play_dates/Utlis/Paints/outlined_text.dart';

import '../Utlis/Buttons/flat_btn.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 239, 223),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Image.asset(
              'assets/04.png',
              height: 380,
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 120, left: 32, right: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const TitleBanner(),
                const SizedBox(
                  height: 60,
                ),
                const OutlinedText(
                  text: "Instructions",
                  fontSize: 34,
                  textColor: Colors.white,
                  borderColor: Colors.black,
                  offset: Offset(1, 4),
                  letterSpacing: 0,
                  strokeWidth: 2,
                ),
                const InfoBox(),
                const SizedBox(
                  height: 40,
                ),
                FlatBtn(
                  onTap: () {},
                  text: "Play Now",
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Image.asset(
              'assets/02.png',
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(items: const [
        BottomNavigationBarItem(icon: Icon(Icons.add), label: "hello"),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: "hello"),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: "hello"),
      ]),
    );
  }
}

class InfoBox extends StatelessWidget {
  const InfoBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.help_outline_sharp),
              SizedBox(
                width: 10,
              ),
              Text(
                "4 questions in the quest",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.alarm),
              SizedBox(
                width: 10,
              ),
              Text(
                "10 secs each question",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.info_outline_rounded),
              SizedBox(
                width: 10,
              ),
              Text(
                "Don't panic, Don't lie",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ShadowText extends StatelessWidget {
  final String data;
  final TextStyle style;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final bool softWrap;
  final TextOverflow overflow;
  final double textScaleFactor;
  final int maxLines;

  const ShadowText(
    this.data, {
    super.key,
    required this.style,
    required this.textAlign,
    required this.textDirection,
    required this.softWrap,
    required this.overflow,
    required this.textScaleFactor,
    required this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Stack(
        children: [
          Positioned(
            top: 3.0,
            left: 3.0,
            child: Text(
              data,
              style: style.copyWith(color: Colors.black.withOpacity(1)),
              textAlign: textAlign,
              textDirection: textDirection,
              softWrap: softWrap,
              overflow: overflow,
              maxLines: maxLines,
            ),
          ),
          Text(
            data,
            style: style,
            textAlign: textAlign,
            textDirection: textDirection,
            softWrap: softWrap,
            overflow: overflow,
            maxLines: maxLines,
          ),
        ],
      ),
    );
  }
}

class TitleBanner extends StatelessWidget {
  const TitleBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width > 400 ? 380 : width,
      height: 180,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/03.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: const Align(
        alignment: Alignment.bottomRight,
        child: Text(
          "Quest One",
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
          ),
        ),
      ),
    );
  }
}
