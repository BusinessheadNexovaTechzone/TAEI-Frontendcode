import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class HospitalDropdown extends StatelessWidget {
  final String? title;
  final String? hint;
  final List<Map<String, dynamic>> items;
  final int? selectedId;
  final ValueChanged<int?> onChanged;
  final InputBorder? border;

  const HospitalDropdown({
    super.key,
    this.title,
    this.hint,
    required this.items,
    this.selectedId,
    required this.onChanged,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final bool singleItem = items.length == 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title?.isNotEmpty == true)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              title!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

        /// 🟢 ONLY ONE HOSPITAL → SHOW CARD
        if (singleItem) _singleHospitalCard(items.first),

        /// 🔵 MULTIPLE → SHOW DROPDOWN
        if (!singleItem) _dropdown(),
      ],
    );
  }

  /// 🟢 Unique design for single hospital
  Widget _singleHospitalCard(Map<String, dynamic> item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_hospital, color: Colors.blue),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              item['name'] ?? item['hospitalname'] ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔵 Your EXISTING dropdown (unchanged)
  ///Old UI
//   Widget _dropdown() {
//     return InkWell(
//       onTap: () => _openSearchSheet(Get.context!),
//       child: InputDecorator(
//         decoration: InputDecoration(
//           hintText: hint ?? 'Select Hospital',
//           filled: true,
//           fillColor: Colors.white,
//           suffixIcon: const Icon(Icons.arrow_drop_down),
//           contentPadding:
//               const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
//           border: border ??
//               OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//         ),
//         child: Text(
//           _selectedHospitalName() ?? hint ?? 'Select Hospital',
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//           style: TextStyle(
//             color: selectedId == null ? Colors.grey : Colors.black,
//             fontSize: 15,
//           ),
//         ),
//       ),
//     );
//   }

  /// New UI
  Widget _dropdown() {
    return Builder(
      builder: (ctx) {
        return GestureDetector(
          onTap: () => _showSearchDropdown(ctx),
          child: InputDecorator(
            decoration: InputDecoration(
                hintText: hint ?? 'Select Hospital',
                filled: true,
                fillColor: Colors.white,
                suffixIcon: const Icon(Icons.arrow_drop_down),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                      width: 1,
                    )),
                border: border ??
                    OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    )),
            child: Text(_selectedHospitalName() ?? hint ?? ''),
          ),
        );
      },
    );
  }

  void _showSearchDropdown(BuildContext context) {
    final overlay = Overlay.of(context);
    final searchController = TextEditingController();
    List<Map<String, dynamic>> filteredItems = List.from(items);

    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    OverlayEntry? entry;

    entry = OverlayEntry(
      builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => entry?.remove(),
          child: Stack(
            children: [
              Positioned(
                left: offset.dx,
                top: offset.dy + size.height + 6,
                width: size.width,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 320),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /// 🔍 Search
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: 'Search hospital',
                              prefixIcon: const Icon(Icons.search),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: (value) {
                              filteredItems = items.where((item) {
                                final name = (item['hospitalname'] ?? '')
                                    .toString()
                                    .toLowerCase();
                                return name.contains(value.toLowerCase());
                              }).toList();
                              entry?.markNeedsBuild();
                            },
                          ),
                        ),

                        /// 🏥 List
                        Flexible(
                          child: filteredItems.isEmpty
                              ? _emptyState()
                              : ListView.builder(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  itemCount: filteredItems.length,
                                  itemBuilder: (_, index) {
                                    final item = filteredItems[index];
                                    final isSelected =
                                        item['hospitalid'] == selectedId;

                                    return ListTile(
                                      dense: true,
                                      leading: const Icon(Icons.local_hospital,
                                          color: Colors.teal),
                                      title: Text(
                                        item['hospitalname'] ?? '',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      trailing: isSelected
                                          ? const Icon(Icons.check,
                                              color: Colors.teal)
                                          : null,
                                      onTap: () {
                                        onChanged(item['hospitalid']);
                                        entry?.remove();
                                      },
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    overlay.insert(entry);
  }

  /*void _openSearchSheet(BuildContext context) {
    final searchController = TextEditingController();
    List<Map<String, dynamic>> filteredItems = List.from(items);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),
                  const Text(
                    'Select Hospital',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  /// 🔍 Search box
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search hospital name...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          filteredItems = items.where((item) {
                            final name =
                                (item['hospitalname'] ?? item['name'] ?? '')
                                    .toString()
                                    .toLowerCase();
                            return name.contains(value.toLowerCase());
                          }).toList();
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// 🏥 Hospital list
                  Flexible(
                    child: ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (_, index) {
                        final item = filteredItems[index];
                        return ListTile(
                          leading: const Icon(Icons.local_hospital,
                              color: Colors.blue),
                          title: Text(
                            item['hospitalname'] ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            onChanged(item['hospitalid']);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }*/

  void _openSearchSheet(BuildContext context) {
    final searchController = TextEditingController();
    List<Map<String, dynamic>> filteredItems = List.from(items);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  /// ⬆ Drag Handle
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// 🏥 Title
                  const Text(
                    'Select Hospital',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// 🔍 Search
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search hospital name',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          filteredItems = items.where((item) {
                            final name = (item['hospitalname'] ?? '')
                                .toString()
                                .toLowerCase();
                            return name.contains(value.toLowerCase());
                          }).toList();
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// 🏥 Hospital List
                  Expanded(
                    child: filteredItems.isEmpty
                        ? _emptyState()
                        : ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: filteredItems.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (_, index) {
                              final item = filteredItems[index];
                              final isSelected =
                                  item['hospitalid'] == selectedId;

                              return InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                  onChanged(item['hospitalid']);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.teal
                                          : Colors.grey.shade300,
                                    ),
                                    color: isSelected
                                        ? Colors.teal.withOpacity(0.08)
                                        : Colors.white,
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 18,
                                        backgroundColor: Colors.teal.shade100,
                                        child: const Icon(
                                          Icons.local_hospital,
                                          size: 18,
                                          color: Colors.teal,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          item['hospitalname'] ?? '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      if (isSelected)
                                        const Icon(Icons.check_circle,
                                            color: Colors.teal),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _emptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.search_off, size: 60, color: Colors.grey.shade400),
        const SizedBox(height: 12),
        const Text(
          'No hospitals found',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          'Try searching with a different name',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  String? _selectedHospitalName() {
    final selected = items.firstWhere(
      (e) => (e['hospitalid'] ?? e['id']) == selectedId,
      orElse: () => {},
    );
    return selected['hospitalname'];
  }
}

/// New Multiple Hospitals Select Dropdown ///////
///

class MultipleHospitalSelectDropdown extends StatefulWidget {
  final String? title;
  final String? hint;
  final List<Map<String, dynamic>> items;
  final Set<int> selectedIds;
  final ValueChanged<Set<int>> onChanged;
  final InputBorder? border;

  const MultipleHospitalSelectDropdown({
    super.key,
    this.title,
    this.hint,
    required this.items,
    required this.selectedIds,
    required this.onChanged,
    this.border,
  });

  @override
  State<MultipleHospitalSelectDropdown> createState() =>
      _MultipleHospitalSelectDropdownState();
}

class _MultipleHospitalSelectDropdownState
    extends State<MultipleHospitalSelectDropdown> {
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title?.isNotEmpty == true)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              widget.title!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        GestureDetector(
          onTap: () {
            _safeSetState(() => _isOpen = false);
            _showSearchDropdown(context);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade400),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.local_hospital, color: Colors.teal, size: 20),
                const SizedBox(width: 8),

                /// 🏷 Selected chips
                Expanded(child: _buildSelectedChips()),

                const SizedBox(width: 6),

                /// ⬇⬆ Arrow
                AnimatedRotation(
                  turns: _isOpen ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(Icons.keyboard_arrow_down),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 🏷 Chips view
  Widget _buildSelectedChips() {
    if (widget.selectedIds.isEmpty) {
      return Text(
        widget.hint ?? 'Select Hospital',
        style: const TextStyle(color: Colors.grey),
      );
    }

    final selectedItems = widget.items
        .where((e) => widget.selectedIds.contains(e['hospitalid']))
        .toList();

    final visible = selectedItems.take(1).toList();
    final remaining = selectedItems.length - visible.length;

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        ...visible.map(
          (e) => Chip(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            backgroundColor: Colors.teal.withOpacity(0.10),
            label: Text(
              e['hospitalname'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        if (remaining > 0)
          Chip(
            label: Text('+$remaining more'),
            backgroundColor: Colors.grey.shade200,
          ),
      ],
    );
  }

  /// 🔽 Overlay dropdown
  void _showSearchDropdown(BuildContext context) {
    final overlay = Overlay.of(context);
    final searchController = TextEditingController();
    List<Map<String, dynamic>> filteredItems = List.from(widget.items);

    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    OverlayEntry? entry;

    entry = OverlayEntry(
      builder: (_) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            _safeSetState(() => _isOpen = false);
            entry?.remove();
          },
          child: Stack(
            children: [
              Positioned(
                left: offset.dx,
                top: offset.dy + size.height + 8,
                width: size.width,
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 380),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      children: [
                        /// 🔍 Search
                        TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: 'Search hospital',
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (value) {
                            filteredItems = widget.items.where((item) {
                              final name = (item['hospitalname'] ?? '')
                                  .toString()
                                  .toLowerCase();
                              return name.contains(value.toLowerCase());
                            }).toList();
                            entry?.markNeedsBuild();
                          },
                        ),

                        const SizedBox(height: 8),

                        /// ☑ Select All / Clear
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                widget.onChanged(
                                  widget.items
                                      .map((e) => e['hospitalid'] as int)
                                      .toSet(),
                                );
                                entry?.markNeedsBuild();
                              },
                              child: const Text('Select All'),
                            ),
                            TextButton(
                              onPressed: () {
                                widget.onChanged({});
                                entry?.markNeedsBuild();
                              },
                              child: const Text('Clear'),
                            ),
                          ],
                        ),

                        const Divider(),

                        /// 🏥 Hospital list
                        Expanded(
                          child: filteredItems.isEmpty
                              ? _emptyState()
                              : ListView.builder(
                                  itemCount: filteredItems.length,
                                  itemBuilder: (_, index) {
                                    final item = filteredItems[index];
                                    final id = item['hospitalid'] as int;
                                    final isSelected =
                                        widget.selectedIds.contains(id);

                                    return CheckboxListTile(
                                      dense: true,
                                      value: isSelected,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      title: Text(item['hospitalname']),
                                      activeColor: Colors.teal,
                                      onChanged: (checked) {
                                        final updated =
                                            Set<int>.from(widget.selectedIds);
                                        checked == true
                                            ? updated.add(id)
                                            : updated.remove(id);
                                        widget.onChanged(updated);
                                        entry?.markNeedsBuild();
                                      },
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    overlay.insert(entry);
  }

  void _safeSetState(VoidCallback fn) {
    if (!mounted) return;
    setState(fn);
  }

  Widget _emptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.search_off, size: 50, color: Colors.grey.shade400),
        const SizedBox(height: 8),
        const Text(
          'No hospitals found',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
