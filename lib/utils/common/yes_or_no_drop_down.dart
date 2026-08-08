import 'package:flutter/material.dart';

class YesNoDropdown extends StatelessWidget {
  final String title;
  final String? value; // expects "Yes" / "No" or null
  final Function(String?) onChanged;
  final bool isEditable;

  const YesNoDropdown({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.isEditable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
          value: value != "Yes" && value != "No" ? null : value,
          onChanged: isEditable ? onChanged : null,
          validator: (val) {
            if (val != "Yes" && val != "No") {
              return "Please select Yes or No";
            }
            return null;
          },
          items: const [
            DropdownMenuItem<String>(
              value: null,
              child: Text("-- Choose --"),
            ),
            DropdownMenuItem<String>(
              value: "Yes",
              child: Text("Yes"),
            ),
            DropdownMenuItem<String>(
              value: "No",
              child: Text("No"),
            ),
          ],
        ),
      ],
    );
  }
}
