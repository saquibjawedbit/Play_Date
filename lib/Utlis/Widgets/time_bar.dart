import 'package:flutter/material.dart';
import 'package:play_dates/Utlis/Colors/theme_color.dart';

class TimeBar extends StatelessWidget {
  const TimeBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.info_outline_rounded,
              color: sbColor,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "01/04",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "00:00:05",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(
              Icons.access_time,
              color: sbColor,
            ),
          ],
        ),
      ],
    );
  }
}
