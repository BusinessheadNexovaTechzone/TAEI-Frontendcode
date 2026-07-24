import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AVPULineChart extends StatelessWidget {
  final String title;
  final int alert;
  final int verbal;
  final int pain;
  final int unresponsive;

  const AVPULineChart({
    super.key,
    required this.title,
    required this.alert,
    required this.verbal,
    required this.pain,
    required this.unresponsive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        AspectRatio(
          aspectRatio: 1.5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: LineChart(
              curve: Curves.decelerate,
              LineChartData(
                minX: 0,
                maxX: 3,
                minY: 0,
                maxY: [
                      alert.toDouble(),
                      verbal.toDouble(),
                      pain.toDouble(),
                      unresponsive.toDouble(),
                    ].reduce((a, b) => a > b ? a : b) +
                    5,
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(fontWeight: FontWeight.bold);
                        switch (value.toInt()) {
                          case 0:
                            return Text('Alert', style: style);
                          case 1:
                            return Text('Verbal', style: style);
                          case 2:
                            return Text('Pain', style: style);
                          case 3:
                            return Text('Unresp.', style: style);
                          default:
                            return const Text('');
                        }
                      },
                      interval: 1,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, interval: 10),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(show: true),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.black26),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(0, alert.toDouble()),
                      FlSpot(1, verbal.toDouble()),
                      FlSpot(2, pain.toDouble()),
                      FlSpot(3, unresponsive.toDouble()),
                    ],
                    isCurved: true,
                    color: Colors.deepPurple,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.deepPurple.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
