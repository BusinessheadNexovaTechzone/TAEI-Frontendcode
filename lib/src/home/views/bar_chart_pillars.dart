import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PillarBarChart extends StatelessWidget {
  final String title;
  final Map<String, int> complaintData;

  const PillarBarChart({
    super.key,
    required this.title,
    required this.complaintData,
  });

  @override
  Widget build(BuildContext context) {
    final barGroups = _buildBarGroups();
    final barTitles = complaintData.keys.toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Bar Chart
          AspectRatio(
            aspectRatio: 1.3,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _calculateMaxY(),
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 10,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        return Text(value.toInt().toString());
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 60,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= barTitles.length) {
                          return const Text('');
                        }
                        return Text(
                          _shortenTitle(barTitles[index]),
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: barGroups,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.orange,
      Colors.green,
      Colors.purple,
      Colors.cyan,
    ];

    int index = 0;
    return complaintData.entries.map((entry) {
      final value = entry.value.toDouble();
      final color = colors[index % colors.length];

      final group = BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: value,
            width: 30,
            color: color,
            borderRadius: BorderRadius.circular(6),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: _calculateMaxY(),
              color: Colors.grey[200],
            ),
          ),
        ],
      );
      index++;
      return group;
    }).toList();
  }

  double _calculateMaxY() {
    final values = complaintData.values;
    if (values.isEmpty) return 10;
    final max = values.reduce((a, b) => a > b ? a : b);
    return (max + 10).toDouble(); // small buffer
  }

  String _shortenTitle(String text) {
    if (text.length > 14) {
      return '${text.substring(0, 12)}..';
    }
    return text;
  }
}
