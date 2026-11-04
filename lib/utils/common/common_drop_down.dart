import 'package:flutter/material.dart';

class TitleDropdown<T> extends StatelessWidget {
  final String? title;
  final String? hint;
  final List<T> items;
  final T? selectedItem;
  final ValueChanged<T?>? onChanged;
  final InputBorder? border;
  final bool isEditable;
  final bool filled;
  final Color? fillColor;
  final bool highlight;

  const TitleDropdown({
    super.key,
    this.title,
    this.hint,
    required this.items,
    this.selectedItem,
    this.onChanged,
    this.border,
    this.isEditable = true,
    this.filled = false,
    this.fillColor,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Theme(
          data: Theme.of(context).copyWith(
            disabledColor: Theme.of(context).colorScheme.onSurface,
          ),
          child: DropdownButtonFormField<T>(
            value: selectedItem,
            isExpanded: true,
            decoration: InputDecoration(
              hintText: hint,
              filled: filled || highlight,
              fillColor: fillColor ??
                  (highlight ? const Color(0xFFFFF3CD) : null),
              hintStyle: const TextStyle(overflow: TextOverflow.ellipsis),
              errorBorder: border != null
                  ? border!.copyWith(
                      borderSide: const BorderSide(color: Colors.red),
                    )
                  : OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
              enabledBorder: border ??
                  OutlineInputBorder(
                    borderSide: BorderSide(
                      color: highlight
                          ? const Color(0xFFE6C653)
                          : const Color(0xFFCED4DA),
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
              focusedBorder: border ??
                  OutlineInputBorder(
                    borderSide: BorderSide(
                      color: highlight
                          ? const Color(0xFFE6C653)
                          : const Color(0xFFCED4DA),
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
              border: border ??
                  OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
            ),
            items: items.isEmpty
                ? []
                : items.map((T item) {
                    return DropdownMenuItem<T>(
                      value: item,
                      child: Text(
                        item.toString(),
                        style: const TextStyle(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    );
                  }).toList(),
            onChanged: isEditable ? onChanged : null,
            validator: (value) {
              if (items.isEmpty) {
                return 'No items available';
              }
              if (value == null) {
                return 'Please select an option';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}

class NewTitleDropdown extends StatelessWidget {
  final String? title;
  final String? hint;
  final List<Map<String, dynamic>> items;
  final int? selectedId;
  final ValueChanged<int?> onChanged;
  final InputBorder? border;
  final bool isValidation;
  final bool isRequired;
  final bool? valid;
  final bool isEditable;
  final bool highlight;
  final String? fallbackLabel;
  const NewTitleDropdown({
    super.key,
    this.title,
    this.hint,
    required this.items,
    this.selectedId,
    required this.onChanged,
    this.border,
    this.isRequired = false,
    this.isValidation = true,
    this.valid,
    this.isEditable = true,
    this.highlight = false,
    this.fallbackLabel,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ prevent dropdown crash and retain exact imported ABHA values when a
    // lookup match is not available in the current dropdown list.
    final resolvedFallbackLabel = fallbackLabel?.trim();
    final dropdownItems = <Map<String, dynamic>>[
      if (resolvedFallbackLabel != null && resolvedFallbackLabel.isNotEmpty)
        {'id': -1, 'name': resolvedFallbackLabel},
      ...items,
    ];
    final validSelectedId = dropdownItems.any(
      (e) => (e['id'] ?? e['hospitalid']) == selectedId,
    )
        ? selectedId
        : (resolvedFallbackLabel != null && resolvedFallbackLabel.isNotEmpty
            ? -1
            : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null && title!.isNotEmpty)
          // Text(
          //   title!,
          //   style: TextStyle(
          //       fontWeight: FontWeight.bold,
          //       color: isRequired ? Colors.red : Colors.black),
          // ),
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title!,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                if (isRequired)
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
        Theme(
          data: Theme.of(context).copyWith(
            disabledColor: Theme.of(context).colorScheme.onSurface,
          ),
          child: DropdownButtonFormField<int>(
            value: validSelectedId,
            isExpanded: true,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(overflow: TextOverflow.ellipsis),
              filled: highlight,
              fillColor: highlight ? const Color(0xFFFFF3CD) : null,
              border: border ??
                  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: highlight
                          ? const Color(0xFFE6C653)
                          : const Color(0xFFCED4DA),
                    ),
                  ),
              enabledBorder: border ??
                  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: highlight
                          ? const Color(0xFFE6C653)
                          : const Color(0xFFCED4DA),
                    ),
                  ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: highlight ? const Color(0xFFE6C653) : Colors.red,
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            items: dropdownItems.map((item) {
              final int? value = item['id'] ?? item['hospitalid'];
              final String label = item['name'] ?? item['hospitalname'] ?? '';

              return DropdownMenuItem<int>(
                value: value,
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              );
            }).toList(),
            onChanged: isEditable
                ? (value) {
                    if (value == -1) return;
                    onChanged(value);
                  }
                : null,
          ),
        ),
      ],
    );
  }
}
