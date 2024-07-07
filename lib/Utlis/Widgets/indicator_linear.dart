import 'dart:math';

import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:play_dates/Utlis/Colors/theme_color.dart';

class IndicatorLinear extends StatelessWidget {
  const IndicatorLinear({
    super.key,
    required this.percent,
    this.backgroundColor,
    this.padding,
    this.width,
    this.animation,
  });

  final double percent;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final double? width;
  final bool? animation;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return LinearPercentIndicator(
      padding:
          padding ?? const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      width: width ?? w,
      percent: min(percent, 1),
      barRadius: Radius.zero,
      animation: animation ?? true,
      lineHeight: 70.0,
      progressColor: primColor,
      backgroundColor: backgroundColor ?? pColor,
    );
  }
}
