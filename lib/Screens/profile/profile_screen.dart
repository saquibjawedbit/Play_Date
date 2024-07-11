import 'package:flutter/material.dart';
import 'package:play_dates/Screens/Quiz/match_screen.dart';
import 'package:play_dates/Utlis/Colors/theme_color.dart';
import 'package:play_dates/Utlis/Paints/outlined_text.dart';

const List<String> imageUrl = [
  "https://images.unsplash.com/photo-1718963892270-04300c864522?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
];

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 251, 255, 204),
        body: CustomPaint(
          painter: ProfilePainter(),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 0,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const AppTitle(),
                  const SizedBox(
                    height: 20,
                  ),
                  Stack(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 36,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                index = (index + 1) % 4;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    imageUrl[index],
                                  ),
                                  fit: BoxFit.fill,
                                ),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 3,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black,
                                    spreadRadius: 0.5,
                                    offset: Offset(13, 13),
                                  )
                                ],
                              ),
                              height: 450,
                              width: 320,
                            ),
                          ),
                          const SizedBox(
                            width: 36,
                          ),
                        ],
                      ),
                      Positioned(
                        top: 16,
                        left: 50,
                        child: Row(
                          children: [
                            for (int i = 0; i < 4; i++)
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                width: 56,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: (i == index)
                                      ? Colors.black
                                      : const Color.fromARGB(255, 56, 57, 97),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const Positioned(
                        bottom: 80,
                        left: 60,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            OutlinedText(
                              text: "Alice,",
                              fontSize: 48,
                              textColor: Colors.white,
                              borderColor: Colors.black,
                              offset: Offset(-5, 5),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            OutlinedText(
                              text: "25",
                              fontSize: 48,
                              textColor: Color.fromARGB(255, 250, 255, 0),
                              borderColor: Colors.black,
                              offset: Offset(-5, 5),
                            ),
                          ],
                        ),
                      ),
                      const Positioned(
                        bottom: 48,
                        left: 60,
                        child: OutlinedText(
                          text: "Student.",
                          fontSize: 36,
                          textColor: Colors.white,
                          borderColor: Colors.black,
                          offset: Offset(-5, 5),
                        ),
                      ),
                      Positioned(
                        top: 20,
                        left: 40,
                        child: Image.asset(
                          'assets/start_image.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: SizedBox(
                          height: 120,
                          width: 120,
                          child: Stack(
                            children: [
                              Image.asset(
                                'assets/Side_btn.png',
                              ),
                              const Align(
                                alignment: Alignment(0.26, 0.26),
                                child: Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.black,
                                  size: 80,
                                ),
                              ),
                              const Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: 80,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  statBar()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Stack statBar() {
    return Stack(
      fit: StackFit.loose,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 32,
            ),
            Center(
              child: Container(
                width: 350,
                decoration: BoxDecoration(
                  color: bColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.only(
                    left: 24, right: 24, top: 32, bottom: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/green_diamond.png',
                          height: 24,
                          fit: BoxFit.fill,
                        ),
                        const Text(
                          "You performed in 2 quests today",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/green_diamond.png',
                          height: 24,
                          fit: BoxFit.fill,
                        ),
                        const Text(
                          "You have 3 matches we are proud!",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const Align(
          alignment: Alignment.topCenter,
          child: OutlinedText(
            text: "Stats",
            fontSize: 40,
            textColor: Color.fromARGB(255, 255, 255, 0),
            borderColor: Colors.black,
            offset: Offset(-5, 5),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 24,
          child: Image.asset(
            'assets/green_heart.png',
            fit: BoxFit.fill,
          ),
        ),
      ],
    );
  }
}

class ProfilePainter extends CustomPainter {
  ProfilePainter({super.repaint});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = bColor
      ..strokeWidth = 1.5;

    Offset start = Offset(size.width / 4, 0);
    Offset end = Offset(size.width / 4, size.height);

    canvas.drawLine(start, end, paint);
    canvas.drawLine(
        Offset(size.width / 2, 0), Offset(size.width / 2, size.height), paint);
    canvas.drawLine(Offset(3 * size.width / 4, 0),
        Offset(3 * size.width / 4, size.height), paint);

    for (int i = 1; i <= 6; i++) {
      canvas.drawLine(Offset(0, i * size.height / 7),
          Offset(size.width, i * size.height / 7), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
