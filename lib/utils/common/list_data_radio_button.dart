import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taei_gov/src/emo_user/model/emo_lookup_model.dart';
import 'package:taei_gov/src/responsive.dart';

import 'model/ab_model.dart';

class CustomRadioList extends StatefulWidget {
  final String title; // Title for ExpansionTile
  final List<Ab> options;
  final ValueChanged<int> onChanged;
  final int? initialid; // optional initial selection
  final bool initiallyExpanded;

  const CustomRadioList({
    super.key,
    required this.title,
    required this.options,
    required this.onChanged,
    this.initialid,
    this.initiallyExpanded = false,
  });

  @override
  _CustomRadioListState createState() => _CustomRadioListState();
}

class _CustomRadioListState extends State<CustomRadioList> {
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialid;
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
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                    Radio<int>(
                      value: widget.options[index].id ?? 0, // index,
                      groupValue: selectedIndex,
                      onChanged: (value) {
                        setState(() => selectedIndex = value);
                        widget.onChanged(value!);
                      },
                    ),
                    Expanded(
                      child: Text(
                        widget.options[index].name ?? "",
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        maxLines: 2,
                        style: const TextStyle(fontSize: 14),
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

//////////////////// New List Data Radio Button
class NewCustomRadioList extends StatefulWidget {
  final String title; // Title for ExpansionTile
  final List<LooksUpItem> options; // Must have id + name
  final ValueChanged<int> onChanged; // Returns selected ID
  final int? initialId; // optional initial selected ID
  final bool initiallyExpanded;
  final bool isRequired;

  const NewCustomRadioList({
    super.key,
    required this.title,
    required this.options,
    required this.onChanged,
    this.initialId,
    this.isRequired = false,
    this.initiallyExpanded = false,
  });

  @override
  _NewCustomRadioListState createState() => _NewCustomRadioListState();
}

class _NewCustomRadioListState extends State<NewCustomRadioList> {
  int? selectedId;

  String get selectedName {
    final selected = widget.options.firstWhereOrNull((e) => e.id == selectedId);
    return selected?.name ?? 'Select Type';
  }

  @override
  void initState() {
    super.initState();
    selectedId = widget.initialId;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      children: [
        // Align(
        //     alignment: Alignment.topLeft,
        //     child: Text(
        //       widget.title.toString(),
        //       style: TextStyle(
        //         color: widget.isRequired ? Colors.red : Colors.black,
        //         fontWeight: FontWeight.bold,
        //       ),
        //     )),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
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
        ),
        Container(
          // margin: const EdgeInsets.symmetric(vertical: 0, horizontal: ),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: selectedId == null
                            ? FontWeight.normal
                            : FontWeight.w600,
                        color: selectedId == null ? Colors.grey : Colors.black,
                      ),
                    ),
                  ),
                  if (selectedId != null)
                    const Icon(Icons.check_circle,
                        color: Colors.green, size: 18),
                ],
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
                    final option = widget.options[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          Radio<int>(
                            value: option.id ?? 0,
                            groupValue: selectedId,
                            onChanged: (value) {
                              setState(() => selectedId = value);
                              widget.onChanged(value!); // return ID only
                            },
                          ),
                          Expanded(
                            child: Text(
                              option.name ?? "",
                              softWrap: true,
                              maxLines: 2,
                              style: const TextStyle(fontSize: 14),
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
}

// class CustomRadioList extends StatefulWidget {
//   final String title;
//   final List<String> options;
//   final ValueChanged<int> onChanged;
//   final int? initialIndex; // <-- Add this property
//
//   const CustomRadioList({
//     Key? key,
//     required this.title,
//     required this.options,
//     required this.onChanged,
//     this.initialIndex, // <-- Optional initial index
//   }) : super(key: key);
//
//   @override
//   _CustomRadioListState createState() => _CustomRadioListState();
// }
//
// class _CustomRadioListState extends State<CustomRadioList> {
//   int? selectedIndex;
//
//   @override
//   void initState() {
//     super.initState();
//     selectedIndex = widget.initialIndex; // <-- Set initial selection
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
//           physics: NeverScrollableScrollPhysics(),
//           crossAxisSpacing: 18,
//
//           childAspectRatio: 3,
//           // adjust this for vertical compression
//           children: List.generate(widget.options.length, (index) {
//             return Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//               child: Row(
//                 children: [
//                   Radio<int>(
//                     value: index,
//                     groupValue: selectedIndex,
//                     onChanged: (value) {
//                       setState(() => selectedIndex = value);
//                       widget.onChanged(value!);
//                     },
//                   ),
//                   Expanded(
//                     child: Text(
//                       widget.options[index],
//                       softWrap: true,
//                       overflow: TextOverflow.visible,
//                       maxLines: 5, // adjust if needed
//                       style: const TextStyle(fontSize: 14),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }),
//         )
//
//         // Wrap(
//         //   spacing: 20,
//         //   runSpacing: 8,
//         //   children: List.generate(widget.options.length, (index) {
//         //     return Row(
//         //       mainAxisSize: MainAxisSize.min,
//         //       children: [
//         //         Radio<int>(
//         //           value: index,
//         //           groupValue: selectedIndex,
//         //           onChanged: (value) {
//         //             setState(() => selectedIndex = value);
//         //             widget.onChanged(value!);
//         //           },
//         //         ),
//         //         Text(widget.options[index]),
//         //       ],
//         //     );
//         //   }),
//         // ),
//       ],
//     );
//   }
// }

/*class CustomRadioList extends StatefulWidget {
  final String title;
  final List<String> options;
  final ValueChanged<int> onChanged;

  const CustomRadioList({
    Key? key,
    required this.title,
    required this.options,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomRadioListState createState() => _CustomRadioListState();
}

class _CustomRadioListState extends State<CustomRadioList> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 20, // horizontal gap
          runSpacing: 8, // vertical gap if it wraps
          children: List.generate(widget.options.length, (index) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<int>(
                  value: index,
                  groupValue: selectedIndex,
                  onChanged: (value) {
                    setState(() => selectedIndex = value);
                    widget.onChanged(value!);
                  },
                ),
                Text(widget.options[index]),
              ],
            );
          }),
        ),
      ],
    );
  }
}*/
