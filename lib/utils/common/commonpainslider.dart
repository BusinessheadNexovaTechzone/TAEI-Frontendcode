import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:taei_gov/utils/common/painlevel_model.dart';

class CommonPainSlider extends StatefulWidget {
  final double initialValue;
  final ValueChanged<double>? onChanged;

  const CommonPainSlider({
    super.key,
    this.initialValue = 0.0,
    this.onChanged,
  });

  @override
  State<CommonPainSlider> createState() => _CommonPainSliderState();
}

class _CommonPainSliderState extends State<CommonPainSlider> {
  late double _value;

  //PainLevel(min: 0.0, max: 0.9, ...),
  // PainLevel(min: 0.9, max: 2.9, ...),
  // PainLevel(min: 2.9, max: 4.9, ...),
  // PainLevel(min: 4.9, max: 6.9, ...),
  // PainLevel(min: 6.9, max: 8.9, ...),
  // PainLevel(min: 8.9, max: 10.0, ...),

  final List<PainLevel> painLevels = [
    PainLevel(
      min: 0.0,
      max: 0.9,
      label: "No Pain",
      color: Colors.green,
      imagePath: 'assets/emojis/no pain.png',
    ),
    PainLevel(
      min: 0.9,
      max: 2.9,
      label: "Mild",
      color: Colors.greenAccent,
      imagePath: 'assets/emojis/mild.png',
    ),
    PainLevel(
      min: 2.9,
      max: 4.9,
      label: "Moderate",
      color: Colors.greenAccent,
      imagePath: 'assets/emojis/moderate.png',
    ),
    PainLevel(
      min: 4.9,
      max: 6.9,
      label: "Severe",
      color: Colors.yellow.shade700,
      imagePath: 'assets/emojis/severe.png',
    ),
    PainLevel(
      min: 6.9,
      max: 8.9,
      label: "Very Severe",
      color: Colors.orange,
      imagePath: 'assets/emojis/very_severe.png',
    ),
    PainLevel(
      min: 8.9,
      max: 10.0,
      label: "Extreme",
      color: Colors.red,
      imagePath: 'assets/emojis/worst_pain_passible.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  PainLevel get currentPain => painLevels.firstWhere((p) => p.matches(_value));

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Pain Level",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        SfSlider(
          min: 0.0,
          max: 10.0,
          value: _value,
          interval: 1,
          inactiveColor: Colors.grey,
          stepSize: 1,
          //activeColor: currentPain.color,
          showTicks: true,
          showLabels: true,
          enableTooltip: true,
          minorTicksPerInterval: 0,
          onChanged: (dynamic value) {
            setState(() {
              _value = value;
            });
            widget.onChanged?.call(value);
            if (kDebugMode) {
              print("Pain value: $value");
            }
          },
        ),
        const SizedBox(height: 20),
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                currentPain.imagePath,
                height: 60,
              ),
              const SizedBox(height: 20),
              Text(
                currentPain.label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: currentPain.color,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
