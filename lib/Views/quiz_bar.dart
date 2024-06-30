import 'package:flutter/material.dart';
import 'package:play_dates/Utlis/Colors/theme_color.dart';
import 'package:play_dates/Utlis/Widgets/indicator_linear.dart';

import '../Utlis/Widgets/triangular_conatiner.dart';

class QuizBar extends StatelessWidget {
  const QuizBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: sandColor,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Stack(
        children: [
          const Positioned(
            top: 10,
            child: IndicatorLinear(
              percent: 0.4,
              backgroundColor: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (int i = 0; i < 4; i++)
                TriangularConatiner(
                  color: const Color.fromARGB(255, 186, 252, 162),
                  text: (i + 1).toString(),
                ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      spreadRadius: 5,
                      offset: Offset(4, 2),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1718963892270-04300c864522?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                  ),
                  radius: 32,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
