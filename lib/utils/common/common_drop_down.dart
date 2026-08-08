import 'package:flutter/material.dart';

class TitleDropdown<T> extends StatelessWidget {
  final String? title;
  final String? hint;
  final List<T> items;
  final T? selectedItem;
  final ValueChanged<T?> onChanged;
  final InputBorder? border;

  const TitleDropdown({
    super.key,
    this.title,
    this.hint,
    required this.items,
    this.selectedItem,
    required this.onChanged,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: selectedItem,
          isExpanded: true,
          decoration: InputDecoration(
            hintText: hint,
            // enabledBorder: border,
            // focusedBorder: border,
            hintStyle: const TextStyle(overflow: TextOverflow.ellipsis),
            errorBorder: border != null
                ? border!.copyWith(
                    borderSide: BorderSide(color: Colors.red),
                  )
                : OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
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
          onChanged: onChanged,
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
  const NewTitleDropdown({
    super.key,
    this.title,
    this.hint,
    required this.items,
    this.selectedId,
    required this.onChanged,
    this.border,
    this.isRequired = false,
    this.isValidation = true,this. valid,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ prevent dropdown crash
    final validSelectedId = items.any(
      (e) => (e['id'] ?? e['hospitalid']) == selectedId,
    )
        ? selectedId
        : null;

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
        DropdownButtonFormField<int>(
          value: validSelectedId,
          isExpanded: true,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(overflow: TextOverflow.ellipsis),
            border: border ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
            enabledBorder: border ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          items: items.map((item) {
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
          onChanged: onChanged,
          // validator: valid! ? (!isValidation
          //     ? null
          //     : (value) {
          //         if (items.isEmpty) {
          //           return 'No items available';
          //         }
          //         if (value == null) {
          //           return 'Please select an option';
          //         }
          //         return null;
          //       }):null,
        ),
      ],
    );
  }
}
