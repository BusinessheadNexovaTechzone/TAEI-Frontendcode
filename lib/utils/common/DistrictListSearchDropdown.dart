import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taei_gov/src/directorate/model/directorate_list_model.dart';
import 'package:taei_gov/src/district/model/district_list_model.dart';

class DistrictListSearchDropdown extends StatelessWidget {
  final String? title;
  final String? hint;
  final List<DistrictListModel> items;
  final int? selectedId;
  final ValueChanged<int?> onChanged;
  final InputBorder? border;

  const DistrictListSearchDropdown({
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
  Widget _singleHospitalCard(DistrictListModel item) {
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
              item.name ?? '',
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
            child: Text(_selectedDistrictName() ?? hint ?? ''),
          ),
        );
      },
    );
  }

  void _showSearchDropdown(BuildContext context) {
    final overlay = Overlay.of(context);
    final searchController = TextEditingController();
    List<DistrictListModel> filteredItems = List.from(items);

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
                              hintText: 'Search district',
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
                                final name =
                                    (item.name ?? '').toString().toLowerCase();
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
                                    final isSelected = item.id == selectedId;

                                    return ListTile(
                                      dense: true,
                                      leading: const Icon(Icons.local_hospital,
                                          color: Colors.teal),
                                      title: Text(
                                        item.name ?? '',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      trailing: isSelected
                                          ? const Icon(Icons.check,
                                              color: Colors.teal)
                                          : null,
                                      onTap: () {
                                        onChanged(item.id);
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

  void _openSearchSheet(BuildContext context) {
    final searchController = TextEditingController();
    List<DistrictListModel> filteredItems = List.from(items);

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
                    'Select District',
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
                        hintText: 'Search district name',
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
                            final name =
                                (item.name ?? '').toString().toLowerCase();
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
                              final isSelected = item.id == selectedId;

                              return InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                  onChanged(item.id);
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
                                          Icons.add_location_rounded,
                                          size: 18,
                                          color: Colors.teal,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          item.name ?? '',
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
          'No District found',
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

  String? _selectedDistrictName() {
    final selected = items.firstWhere(
      (e) => (e.id) == selectedId,
      orElse: () => DistrictListModel(),
    );
    return selected.name;
  }
}

///
/// ........... Directorate ................ ///
///
class DirectorateListSearchDropdown extends StatelessWidget {
  final String? title;
  final String? hint;
  final List<DirectorateListModel> items;
  final int? selectedId;
  final ValueChanged<int?> onChanged;
  final InputBorder? border;

  const DirectorateListSearchDropdown({
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
        if (singleItem) _singleDirectorateCard(items.first),

        /// 🔵 MULTIPLE → SHOW DROPDOWN
        if (!singleItem) _dropdown(),
      ],
    );
  }

  /// 🟢 Unique design for single hospital
  Widget _singleDirectorateCard(DirectorateListModel item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.person, color: Colors.blue),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              item.name ?? '',
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

  /// New UI
  Widget _dropdown() {
    return Builder(
      builder: (ctx) {
        return GestureDetector(
          onTap: () => _showSearchDropdown(ctx),
          child: InputDecorator(
            decoration: InputDecoration(
                hintText: hint ?? 'Select Directorate',
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
            child: Text(_selectedDirectorateName() ?? hint ?? ''),
          ),
        );
      },
    );
  }

  void _showSearchDropdown(BuildContext context) {
    final overlay = Overlay.of(context);
    final searchController = TextEditingController();
    List<DirectorateListModel> filteredItems = List.from(items);

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
                              hintText: 'Search Directorate',
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
                                final name =
                                    (item.name ?? '').toString().toLowerCase();
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
                                    final isSelected = item.id == selectedId;

                                    return ListTile(
                                      dense: true,
                                      leading: const Icon(Icons.local_hospital,
                                          color: Colors.teal),
                                      title: Text(
                                        item.name ?? '',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      trailing: isSelected
                                          ? const Icon(Icons.check,
                                              color: Colors.teal)
                                          : null,
                                      onTap: () {
                                        onChanged(item.id);
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

  void _openSearchSheet(BuildContext context) {
    final searchController = TextEditingController();
    List<DirectorateListModel> filteredItems = List.from(items);

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
                    'Select District',
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
                        hintText: 'Search district name',
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
                            final name =
                                (item.name ?? '').toString().toLowerCase();
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
                              final isSelected = item.id == selectedId;

                              return InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                  onChanged(item.id);
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
                                          Icons.person,
                                          size: 18,
                                          color: Colors.teal,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          item.name ?? '',
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
          'No Directorate found',
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

  String? _selectedDirectorateName() {
    final selected = items.firstWhere(
      (e) => (e.id) == selectedId,
      orElse: () => DirectorateListModel(),
    );
    return selected.name;
  }
}
