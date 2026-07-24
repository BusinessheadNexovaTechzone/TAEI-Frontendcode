import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../src/hospital/model/hospital_model.dart';

class HospitalSearchDropdown extends StatelessWidget {
  final String title;
  final String hint;
  final List<Hospital> hospitals;
  final int? selectedHospitalId;
  final Function(Hospital hospital) onSelected;

  const HospitalSearchDropdown({
    super.key,
    required this.title,
    required this.hint,
    required this.hospitals,
    required this.onSelected,
    this.selectedHospitalId,
  });

  @override
  Widget build(BuildContext context) {
    final selectedHospital = hospitals.firstWhereOrNull(
      (e) => e.hospitalid == selectedHospitalId,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 6),
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _openHospitalDialog(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedHospital?.hospitalname ?? hint,
                    style: TextStyle(
                      color:
                          selectedHospital == null ? Colors.grey : Colors.black,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _openHospitalDialog(BuildContext context) {
    final searchController = TextEditingController();
    final filteredList = hospitals.obs;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 500, // 👈 hard limit
                maxHeight: 500,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Search Field
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search hospital',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey.shade300,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      filteredList.value = hospitals
                          .where((e) =>
                              e.hospitalname
                                  ?.toLowerCase()
                                  .contains(value.toLowerCase()) ??
                              false)
                          .toList();
                    },
                  ),
                  const SizedBox(height: 12),

                  // List
                  Flexible(
                    child: Obx(
                      () => ListView.separated(
                        shrinkWrap: true,
                        itemCount: filteredList.length,
                        separatorBuilder: (_, __) => SizedBox(),
                        itemBuilder: (_, index) {
                          final hospital = filteredList[index];
                          return ListTile(
                            title: Row(
                              children: [
                                Icon(
                                  Icons.local_hospital,
                                  color: Colors.green.shade600,
                                ),
                                Expanded(
                                  child: Text(
                                    hospital.hospitalname ?? '',
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: hospital.districtname != null
                                ? Text(
                                    hospital.districtname!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.blueGrey,
                                    ),
                                  )
                                : null,
                            trailing: hospital.hospitalid == selectedHospitalId
                                ? const Icon(Icons.check, color: Colors.green)
                                : null,
                            onTap: () {
                              onSelected(hospital);
                              Get.back();
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
