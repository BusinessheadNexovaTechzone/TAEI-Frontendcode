import 'package:flutter/material.dart';

class DetailsPageWidget {
  static Widget title(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static Widget buildSectionView(Map<String, dynamic> data) {
    if (data.values.every((v) => v == null)) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.green[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(
            child: Text(
              "No Data Available",
              style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 26),
            ),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(12),
          children:
              data.entries.map((e) => buildRowCard(e.key, e.value)).toList(),
        ),
      ),
    );
  }

  static Widget buildListView(
    List<dynamic>? data, {
    required Widget Function(Map<String, dynamic>) itemBuilder,
  }) {
    if (data == null || data.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.cyan.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(
            child: Text(
              "No data available",
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 100,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index] as Map<String, dynamic>;
          return itemBuilder(item);
        },
      ),
    );
  }

  static Widget buildInfoRow(
    String key,
    dynamic value, {
    required TextStyle keyStyle,
    required TextStyle valueStyle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Text(key, style: keyStyle)),
        const SizedBox(width: 4),
        const Text(":", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value?.toString() ?? "-",
            style: valueStyle,
          ),
        ),
      ],
    );
  }

  static Widget buildRowCard(String key, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: buildInfoRow(
        key,
        value,
        keyStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
        valueStyle: const TextStyle(fontSize: 15),
      ),
    );
  }
}
