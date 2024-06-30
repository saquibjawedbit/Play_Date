import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:play_dates/Utlis/Colors/theme_color.dart';

class IndicatorLinear extends StatelessWidget {
  const IndicatorLinear({
    super.key,
    required this.percent,
    this.backgroundColor,
    this.padding,
  });

  final double percent;
  final Color? backgroundColor;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return LinearPercentIndicator(
      padding:
          padding ?? const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      width: width,
      percent: percent,
      barRadius: Radius.zero,
      animation: true,
      lineHeight: 70.0,
      progressColor: primColor,
      backgroundColor: backgroundColor ?? pColor,
    );
  }
}
