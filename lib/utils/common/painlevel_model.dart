import 'dart:ui';

class PainLevel {
  final double min;
  final double max;
  final String label;
  final Color color;
  final String imagePath;

  PainLevel({
    required this.min,
    required this.max,
    required this.label,
    required this.color,
    required this.imagePath,
  });

  bool matches(double value) => value >= min && value <= max;
}
