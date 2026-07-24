import 'package:flutter/material.dart';

class InjuryDropdownList extends StatefulWidget {
  final String title; // Title shown on ExpansionTile
  final List<TitleDropdownItem> listData;
  final bool initiallyExpanded;

  const InjuryDropdownList({
    super.key,
    required this.title,
    required this.listData,
    this.initiallyExpanded = false,
  });

  @override
  State<InjuryDropdownList> createState() => _InjuryDropdownListState();
}

class _InjuryDropdownListState extends State<InjuryDropdownList> {
  @override
  Widget build(BuildContext context) {
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
        tilePadding: const EdgeInsets.symmetric(horizontal: 12),
        initiallyExpanded: widget.initiallyExpanded,
        childrenPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.listData.length,
            itemBuilder: (context, index) {
              final item = widget.listData[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        item.title,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: DropdownButtonFormField<dynamic>(
                        value: item.selectedValue,
                        items: item.options
                            .map((opt) => DropdownMenuItem(
                                  value: opt,
                                  child: Text(opt.toString()),
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            item.selectedValue = val;
                          });
                          item.onChanged(val);
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class TitleDropdownItem {
  final String title;
  final List<dynamic> options;
  dynamic selectedValue;
  final ValueChanged<dynamic> onChanged;

  TitleDropdownItem({
    required this.title,
    required this.options,
    this.selectedValue,
    required this.onChanged,
  });
}
