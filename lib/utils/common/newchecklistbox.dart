import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taei_gov/src/responsive.dart';

import '../../src/emo_user/model/emo_lookup_model.dart';

class NewCustomCheckboxList extends StatefulWidget {
  final String title;
  final List<LooksUpItem> options;
  final ValueChanged<List<int>> onChanged; // returns selected IDs
  final List<int>? initialIds;
  final bool initiallyExpanded;

  const NewCustomCheckboxList({
    super.key,
    required this.title,
    required this.options,
    required this.onChanged,
    this.initialIds,
    this.initiallyExpanded = false,
  });

  @override
  _NewCustomCheckboxListState createState() => _NewCustomCheckboxListState();
}

class _NewCustomCheckboxListState extends State<NewCustomCheckboxList> {
  late List<int> selectedIds;

  @override
  void initState() {
    super.initState();
    selectedIds = widget.initialIds ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      children: [
        Align(
            alignment: Alignment.topLeft,
            child: Text(
              widget.title.toString(),
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            )),
        Container(
          // margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ExpansionTile(
            shape: const RoundedRectangleBorder(),
            title: Text("Select", style: const TextStyle()),
            initiallyExpanded: widget.initiallyExpanded,
            childrenPadding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            children: [
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: context.isDesktop ? 90 : 18,
                childAspectRatio: context.isDesktop ? 10 : 3,
                children: widget.options.map((option) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        Checkbox(
                          value: selectedIds.contains(option.id),
                          onChanged: (checked) {
                            setState(() {
                              if (checked == true) {
                                selectedIds.add(option.id!);
                              } else {
                                selectedIds.remove(option.id);
                              }
                            });
                            widget.onChanged(selectedIds);
                          },
                        ),
                        Expanded(
                            child: Text(option.name ?? "",
                                maxLines: 2,
                                style: const TextStyle(fontSize: 14))),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
