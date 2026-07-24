import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PresentingComplaintsChart extends StatelessWidget {
  final String title;
  final int medicalEmergency;
  final int surgicalEmergency;

  const PresentingComplaintsChart({
    super.key,
    required this.title,
    required this.medicalEmergency,
    required this.surgicalEmergency,
  });

  @override
  Widget build(BuildContext context) {
    final data = [
      _ChartData('Medical Emergency', medicalEmergency),
      _ChartData('Surgical Emergency', surgicalEmergency),
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 250,
          child: SfCircularChart(
            legend: Legend(isVisible: true),
            series: <DoughnutSeries<_ChartData, String>>[
              DoughnutSeries<_ChartData, String>(
                dataSource: data,
                xValueMapper: (_ChartData data, _) => data.category,
                yValueMapper: (_ChartData data, _) => data.count,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class _ChartData {
  final String category;
  final int count;

  _ChartData(this.category, this.count);
}
