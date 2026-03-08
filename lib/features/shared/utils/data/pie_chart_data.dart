import 'package:flutter/material.dart';
import 'package:cms_web/features/shared/utils/colorsconstants.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartData {
  final pieChartSelectionDatas = [
    PieChartSectionData(
        color: primaryColor, value: 9500, showTitle: false, radius: 20),
    PieChartSectionData(
        color: const Color(0xFF26E5FF),
        value: 450,
        showTitle: false,
        radius: 20),
    PieChartSectionData(
        color: const Color(0xFFFFCF26),
        value: 40,
        showTitle: false,
        radius: 20),
    PieChartSectionData(
        color: const Color(0xFFEE2727),
        value: 10,
        showTitle: false,
        radius: 20),
  ];
}
