import 'package:flutter/material.dart';

class NewCheckboxList1<T> extends StatefulWidget {
  final String title; // Title shown on ExpansionTile
  final List<T> options;
  final List<int> initialSelectedIds; // e.g., [1, 2, 3]
  final ValueChanged<List<int>> onChanged; // Returns updated list of IDs
  final bool initiallyExpanded;
  final int Function(T) idSelector; // Function to get ID from T
  final String Function(T) nameSelector; // Function to get display name

  const NewCheckboxList1({
    super.key,
    required this.title,
    required this.options,
    this.initialSelectedIds = const [],
    required this.onChanged,
    this.initiallyExpanded = false,
    required this.idSelector,
    required this.nameSelector,
  });

  @override
  _NewCheckboxList1State<T> createState() => _NewCheckboxList1State<T>();
}

class _NewCheckboxList1State<T> extends State<NewCheckboxList1<T>> {
  late List<int> selectedIds;

  @override
  void initState() {
    super.initState();
    selectedIds = List.from(widget.initialSelectedIds);
  }

  void toggleSelection(int id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
    setState(() {}); // Update UI
    widget.onChanged(selectedIds); // Return updated IDs
  }

  @override
  Widget build(BuildContext context) {
    if (widget.options.isEmpty) {
      return Text("${widget.title} not available", style: const TextStyle(color: Colors.grey));
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, width: 1.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ExpansionTile(
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        initiallyExpanded: widget.initiallyExpanded,
        childrenPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        children: [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 18,
            childAspectRatio: 3,
            children: widget.options.map((item) {
              final id = widget.idSelector(item);
              final name = widget.nameSelector(item);
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Checkbox(
                      value: selectedIds.contains(id),
                      onChanged: (_) => toggleSelection(id),
                    ),
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
