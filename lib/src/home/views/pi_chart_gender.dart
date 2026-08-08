import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:taei_gov/src/institutional_dashboard/model/in_hospital_institutional_dashboard_model.dart';

class GenderPieChart extends StatelessWidget {
  final String title;
  final List<GenderWise>? genderWise;

  const GenderPieChart({
    super.key,
    required this.title,
    required this.genderWise,
  });

  @override
  Widget build(BuildContext context) {
    final data = genderWise ?? [];

    if (data.isEmpty) {
      return const Center(child: Text("No Data Available"));
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔹 Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 16),

            /// 🔹 Pie Chart
            SizedBox(
              height: 220,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 4,
                  centerSpaceRadius: 50,
                  sections: _buildSections(data),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// 🔹 Legends
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: data.map((e) {
                return _legendItem(
                  color: _genderColor(e.gender),
                  label: e.gender!,
                  value: e.totalCount!,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  /// 🎨 Pie Sections
  List<PieChartSectionData> _buildSections(List<GenderWise> data) {
    return data.map((e) {
      return PieChartSectionData(
        value: e.totalCount!.toDouble(),
        color: _genderColor(e.gender),
        radius: 60,
        title: "${e.totalCount}",
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  /// 🎨 Gender Colors (Unique & Clear)
  Color _genderColor(String? gender) {
    switch (gender) {
      case 'Male':
        return Colors.blue;
      case 'Female':
        return Colors.pink;
      case 'Transgender':
        return Colors.purple;
      case 'Unidentified':
        return Colors.grey;
      default:
        return Colors.orange;
    }
  }

  /// 🔖 Legend Widget
  Widget _legendItem({
    required Color color,
    required String label,
    required int value,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          "$label ($value)",
          style: const TextStyle(fontSize: 13),
        ),
      ],
    );
  }
}
