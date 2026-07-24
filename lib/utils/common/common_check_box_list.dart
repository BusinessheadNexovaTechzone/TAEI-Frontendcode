import 'package:flutter/material.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/utils/common/space.dart';

class CompactCheckboxGroup extends StatefulWidget {
  final String title;
  final List<String> options;
  final Function(List<String> selectedItems, String? otherText) onChanged;
  final List<int>? initialSelected;

  const CompactCheckboxGroup({
    super.key,
    required this.title,
    required this.options,
    required this.onChanged,
    this.initialSelected,
  });

  @override
  State<CompactCheckboxGroup> createState() => _CompactCheckboxGroupState();
}

class _CompactCheckboxGroupState extends State<CompactCheckboxGroup> {
  final Set<String> selectedItems = {};
  final TextEditingController othersController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialSelected != null) {
      for (var index in widget.initialSelected!) {
        selectedItems.add(widget.options[index]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final showOtherField = selectedItems.contains("Others - Specify");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: widget.options.map((option) {
            final isSelected = selectedItems.contains(option);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedItems.remove(option);
                    if (option == "Others - Specify") {
                      othersController.clear();
                    }
                  } else {
                    selectedItems.add(option);
                  }
                  widget.onChanged(
                    selectedItems.toList(),
                    showOtherField ? othersController.text : null,
                  );
                });
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: isSelected,
                    onChanged: (_) {
                      setState(() {
                        if (isSelected) {
                          selectedItems.remove(option);
                          if (option == "Others - Specify") {
                            othersController.clear();
                          }
                        } else {
                          selectedItems.add(option);
                        }
                        widget.onChanged(
                          selectedItems.toList(),
                          showOtherField ? othersController.text : null,
                        );
                      });
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity:
                        const VisualDensity(horizontal: -4, vertical: -4),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 300,
                    ),
                    child: Text(
                      option,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 14,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            );
          }).toList(),
        ),
        if (showOtherField)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextFormField(
              controller: othersController,
              decoration: const InputDecoration(
                labelText: "Please specify",
                border: OutlineInputBorder(),
              ),
              onChanged: (_) {
                widget.onChanged(
                  selectedItems.toList(),
                  othersController.text,
                );
              },
            ),
          ),
      ],
    );
  }
}

////// new list

// class CustomCheckboxList extends StatefulWidget {
//   final String title;
//   final List<String> options;
//   final List<int> initialSelectedIndexes; // e.g. [1, 2, 3]
//   final ValueChanged<List<int>> onChanged; // Returns updated list of indexes
//
//   const CustomCheckboxList({
//     Key? key,
//     required this.title,
//     required this.options,
//     this.initialSelectedIndexes = const [],
//     required this.onChanged,
//   }) : super(key: key);
//
//   @override
//   _CustomCheckboxListState createState() => _CustomCheckboxListState();
// }
//
// class _CustomCheckboxListState extends State<CustomCheckboxList> {
//   late List<int> selectedIndexes;
//
//   @override
//   void initState() {
//     super.initState();
//     selectedIndexes = List.from(widget.initialSelectedIndexes);
//   }
//
//   void toggleSelection(int index) {
//     setState(() {
//       if (selectedIndexes.contains(index)) {
//         selectedIndexes.remove(index);
//       } else {
//         selectedIndexes.add(index);
//       }
//     });
//     widget.onChanged(selectedIndexes);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           widget.title,
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 8),
//         GridView.count(
//           crossAxisCount: 2,
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           crossAxisSpacing: 18,
//           childAspectRatio: 3,
//           children: List.generate(widget.options.length, (index) {
//             return Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//               child: Row(
//                 children: [
//                   Checkbox(
//                     value: selectedIndexes.contains(index + 1),
//                     // +1 if API uses 1-based indexing
//                     onChanged: (value) => toggleSelection(index + 1),
//                   ),
//                   Expanded(
//                     child: Text(
//                       widget.options[index],
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }),
//         ),
//       ],
//     );
//   }
// }

///////////////// New Checkbox List

class CustomCheckboxList extends StatefulWidget {
  final String title; // Title shown on ExpansionTile
  final List<String> options;
  final List<int> initialSelectedIndexes; // e.g. [1, 2, 3]
  final ValueChanged<List<int>> onChanged; // Returns updated list of indexes
  final bool initiallyExpanded;

  const CustomCheckboxList({
    super.key,
    required this.title,
    required this.options,
    this.initialSelectedIndexes = const [],
    required this.onChanged,
    this.initiallyExpanded = false,
  });

  @override
  _CustomCheckboxListState createState() => _CustomCheckboxListState();
}

class _CustomCheckboxListState extends State<CustomCheckboxList> {
  late List<int> selectedIndexes;

  @override
  void initState() {
    super.initState();
    selectedIndexes = List.from(widget.initialSelectedIndexes);
  }

  void toggleSelection(int index) {
    if (selectedIndexes.contains(index)) {
      selectedIndexes.remove(index);
    } else {
      selectedIndexes.add(index);
    }

    // Delay setState until after build finishes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });

    widget.onChanged(selectedIndexes);
  }

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
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 18,
            childAspectRatio: 3,
            children: List.generate(widget.options.length, (index) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Checkbox(
                      value: selectedIndexes.contains(index + 1),
                      // +1 if API uses 1-based indexing
                      onChanged: (value) => toggleSelection(index + 1),
                    ),
                    Expanded(
                      child: Text(
                        widget.options[index],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class NewCheckboxList<T> extends StatefulWidget {
  final String title;
  final List<T> options;
  final List<int> initialSelectedIndexes;
  final ValueChanged<List<int>> onChanged;
  final bool initiallyExpanded;
  final bool isRequired;

  const NewCheckboxList({
    super.key,
    required this.title,
    required this.options,
    this.initialSelectedIndexes = const [],
    required this.onChanged,
    this.isRequired = false,
    this.initiallyExpanded = false,
  });

  @override
  _NewCheckboxListState createState() => _NewCheckboxListState();
}

class _NewCheckboxListState extends State<NewCheckboxList> {
  late List<int> selectedIndexes;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    selectedIndexes = List.from(widget.initialSelectedIndexes);
  }

  void toggleSelection(int id) {
    setState(() {
      if (selectedIndexes.contains(id)) {
        selectedIndexes.remove(id);
      } else {
        selectedIndexes.add(id);
      }
    });
    widget.onChanged(selectedIndexes);
  }

  @override
  Widget build(BuildContext context) {
    final selectedItems = widget.options
        .where((e) => selectedIndexes.contains(e.id))
        .map((e) => e.name ?? "")
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(widget.title,
        //     style: TextStyle(
        //         fontSize: 16,
        //         fontWeight: FontWeight.bold,
        //         color: widget.isRequired ? Colors.red : Colors.black)),
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              if (widget.isRequired)
                const Text(
                  ' *',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.teal.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.teal, width: 1.2),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 12),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (selectedItems.isNotEmpty)
                    Text(
                      '${selectedItems.length} selected',
                      style: const TextStyle(
                          fontSize: 13,
                          color: Colors.teal,
                          fontWeight: FontWeight.w500),
                    ),
                ],
              ),
              initiallyExpanded: widget.initiallyExpanded,
              onExpansionChanged: (expanded) {
                setState(() => _isExpanded = expanded);
              },
              childrenPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              children: [
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 18,
                  childAspectRatio: context.isDesktop ? 10 : 3,
                  children: List.generate(widget.options.length, (index) {
                    final item = widget.options[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          Checkbox(
                            value: selectedIndexes.contains(item.id),
                            onChanged: (_) => toggleSelection(item.id),
                          ),
                          Expanded(
                            child: Text(
                              item.name ?? "",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Show selected chips below tile only when collapsed
        if (!_isExpanded && selectedItems.isNotEmpty) ...[
          Wrap(
            spacing: 4,
            children: selectedItems.map((name) {
              return Chip(
                label: Text(
                  name,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w500),
                ),
                backgroundColor: Colors.teal.withOpacity(0.15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.teal)),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

/// My New Checkbox List

/*class NewCheckboxList<T> extends StatefulWidget {
  final String title; // Title shown on ExpansionTile
  final List<T> options;
  final List<int> initialSelectedIndexes; // e.g. [1, 2, 3]
  final ValueChanged<List<int>> onChanged; // Returns updated list of indexes
  final bool initiallyExpanded;

  const NewCheckboxList({
    super.key,
    required this.title,
    required this.options,
    this.initialSelectedIndexes = const [],
    required this.onChanged,
    this.initiallyExpanded = false,
  });

  @override
  _NewCheckboxListState createState() => _NewCheckboxListState();
}

class _NewCheckboxListState extends State<NewCheckboxList> {
  late List<int> selectedIndexes;

  @override
  void initState() {
    super.initState();
    selectedIndexes = List.from(widget.initialSelectedIndexes);
  }

  void toggleSelection(int id) {
    if (selectedIndexes.contains(id)) {
      selectedIndexes.remove(id);
    } else {
      selectedIndexes.add(id);
    }

    // Delay setState until after build finishes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });

    widget.onChanged(selectedIndexes);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Space(
          height: 8,
        ),
        Container(
          // margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Text(
                'Select',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              tilePadding: const EdgeInsets.symmetric(horizontal: 12),
              initiallyExpanded: widget.initiallyExpanded,
              childrenPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              children: [
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 18,
                  childAspectRatio: context.isDesktop ? 10 : 3,
                  children: List.generate(widget.options.length, (index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          Checkbox(
                            value: selectedIndexes
                                .contains(widget.options[index].id),
                            onChanged: (value) => toggleSelection(index + 1),
                          ),
                          Expanded(
                            child: Text(
                              widget.options[index].name ?? "",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}*/
