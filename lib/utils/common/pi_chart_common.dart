import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:taei_gov/src/institutional_dashboard/model/in_hospital_institutional_dashboard_model.dart';

class GenderPieChart extends StatefulWidget {
  final List<GenderWise>? genderWise;
  final String title;

  const GenderPieChart({
    super.key,
    required this.genderWise,
    required this.title,
  });

  @override
  State<GenderPieChart> createState() => _GenderPieChartState();
}

class _GenderPieChartState extends State<GenderPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final data = _normalizedGenderData();
    final total = data.fold<int>(0, (sum, e) => sum + e.count);

    if (total == 0) {
      return const Center(child: Text("No gender data available"));
    }

    return Column(
      children: [
        Text(
          widget.title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 0.9,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (event, response) {
                        setState(() {
                          touchedIndex =
                              response?.touchedSection?.touchedSectionIndex ??
                                  -1;
                        });
                      },
                    ),
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    sections: _buildSections(data, total),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...data.map((e) => legendItem(e.label, e.color, e.count)),
                  const SizedBox(height: 8),
                  Text(
                    "Total: $total",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// -------------------------------
  /// Normalize backend gender data
  /// -------------------------------
  List<_GenderChartItem> _normalizedGenderData() {
    final list = <_GenderChartItem>[];

    for (final g in widget.genderWise ?? []) {
      final label =
          (g.gender == null || g.gender!.isEmpty) ? "Other" : g.gender!;

      list.add(
        _GenderChartItem(
          label: label,
          count: g.totalCount ?? 0,
          color: _genderColor(label),
          icon: _genderIcon(label),
        ),
      );
    }
    return list;
  }

  /// -------------------------------
  /// Pie sections
  /// -------------------------------
  List<PieChartSectionData> _buildSections(
      List<_GenderChartItem> data, int total) {
    return List.generate(data.length, (i) {
      final isTouched = i == touchedIndex;
      final percentage = total == 0 ? 0 : (data[i].count / total) * 100;

      return PieChartSectionData(
        color: data[i].color,
        value: data[i].count.toDouble(),
        title: "${percentage.toStringAsFixed(1)}%",
        radius: isTouched ? 80 : 70,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [Shadow(color: Colors.black, blurRadius: 2)],
        ),
        badgePositionPercentageOffset: .99,
      );
    });
  }

  /// -------------------------------
  /// Legend
  /// -------------------------------
  Widget legendItem(String label, Color color, int count) {
    return Row(
      children: [
        Container(width: 14, height: 14, color: color),
        const SizedBox(width: 6),
        Text("$label: $count", style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  /// -------------------------------
  /// Color mapping
  /// -------------------------------
  Color _genderColor(String gender) {
    switch (gender.toLowerCase()) {
      case 'male':
        return Colors.blue;
      case 'female':
        return Colors.pink;
      case 'transgender':
        return Colors.purple;
      default:
        return Colors.orange;
    }
  }

  /// -------------------------------
  /// Icon mapping
  /// -------------------------------
  String _genderIcon(String gender) {
    switch (gender.toLowerCase()) {
      case 'male':
        return 'assets/dashboard/man.png';
      case 'female':
        return 'assets/dashboard/woman.png';
      case 'transgender':
        return 'assets/dashboard/transgender.png';
      default:
        return 'assets/dashboard/other.png';
    }
  }
}

class _GenderChartItem {
  final String label;
  final int count;
  final Color color;
  final String icon;

  _GenderChartItem({
    required this.label,
    required this.count,
    required this.color,
    required this.icon,
  });
}
