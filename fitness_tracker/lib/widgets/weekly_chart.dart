import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Bar chart showing one value per day for the last 7 days.
/// [dailyValues] must have exactly 7 entries, oldest first, today last.
class WeeklyChart extends StatelessWidget {
  final List<double> dailyValues;
  final List<String> dayLabels;
  final Color color;
  final String unitSuffix;

  const WeeklyChart({
    super.key,
    required this.dailyValues,
    required this.dayLabels,
    required this.color,
    this.unitSuffix = '',
  });

  @override
  Widget build(BuildContext context) {
    final maxVal = dailyValues.isEmpty
        ? 1.0
        : dailyValues.reduce((a, b) => a > b ? a : b);
    final chartMax = maxVal <= 0 ? 1.0 : maxVal * 1.25;

    return SizedBox(
      height: 180,
      child: BarChart(
        BarChartData(
          maxY: chartMax,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${rod.toY.round()}$unitSuffix',
                  const TextStyle(color: Colors.white, fontSize: 12),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i < 0 || i >= dayLabels.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      dayLabels[i],
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(dailyValues.length, (i) {
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: dailyValues[i],
                  color: color,
                  width: 18,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
