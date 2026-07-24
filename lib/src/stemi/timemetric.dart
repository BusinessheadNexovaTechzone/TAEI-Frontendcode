import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeMetricInput extends StatelessWidget {
  final String label;
  dynamic? initialValue;
  final ValueChanged<int?> onChanged;

   TimeMetricInput({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(
        text: initialValue != null ? initialValue.toString() : '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextFormField(
          readOnly: true,
          controller: controller,
          // keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            suffixText: "min/hr",
            hintText: "Enter time in minutes",
            border: OutlineInputBorder(),
          ),
          onChanged: (val) => onChanged(int.tryParse(val)),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
