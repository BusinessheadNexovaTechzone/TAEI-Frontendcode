// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:taei_gov/src/report_dashboard/controller/entry_dashboard_controller.dart';

// import '../../../utils/common/space.dart';
// import '../../../utils/common/start_end_date_picker.dart';
// import '../../../utils/helpers/no_data_widget.dart';
// import '../../../utils/helpers/page_loader.dart';

// class EntryDashboardScreen extends StatefulWidget {
//   @override
//   State<EntryDashboardScreen> createState() => _EntryDashboardScreenState();
// }

// class _EntryDashboardScreenState extends State<EntryDashboardScreen> {
//   final controller = Get.put(EntryDashboardController());

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   Future<void> fetchData() async {
//     controller.fromDate.value = DateTime.now().subtract(Duration(days: 6));
//     controller.toDate.value = DateTime.now();
//     await Future.delayed(Duration.zero);
//     controller.getData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return pageLoader();
//         }

//         /// Get list safely
//         final dataList = controller.entryData.value?.data ?? [];

//         if (dataList.isEmpty) {
//           return Column(
//             children: [
//               CommonDateRangePicker(
//                 startDate: controller.fromDate.value,
//                 endDate: controller.toDate.value,
//                 onApply: () async {
//                   await controller.getData();
//                 },
//                 onDateSelected: (start, end) {
//                   controller.fromDate.value = start;
//                   controller.toDate.value = end;
//                 },
//               ),
//               const SizedBox(height: 200),
//               noDataWidget(msg: "No Records Found"),
//             ],
//           );
//         }

//         /// Extract table headers
//         final keys = dataList.first.toJson().keys.toList();

//         /// -------------------- COMPUTE TOTALS --------------------
//         final Map<String, num> columnTotals = {};
//         for (var key in keys) {
//           num total = 0;

//           for (var item in dataList) {
//             final rawValue = item.toJson()[key];

//             /// Convert to string safely
//             final value = rawValue?.toString().trim() ?? "";

//             /// Try to parse only numeric values
//             final parsed = num.tryParse(value);

//             if (parsed != null) {
//               total += parsed;
//             }
//           }

//           columnTotals[key] = total;
//         }

//         return LayoutBuilder(
//           builder: (context, constraints) {
//             final bool isDesktop = constraints.maxWidth > 700;

//             return SingleChildScrollView(
//               child: Padding(
//                 padding: EdgeInsets.all(isDesktop ? 30 : 12),
//                 child: Column(
//                   children: [
//                     /// Date Range Picker
//                     CommonDateRangePicker(
//                       startDate: controller.fromDate.value,
//                       endDate: controller.toDate.value,
//                       onApply: () async {
//                         await controller.getData();
//                       },
//                       onDateSelected: (start, end) {
//                         controller.fromDate.value = start;
//                         controller.toDate.value = end;
//                       },
//                     ),

//                     Space(height: 20),

//                     Text(
//                       "Entry Dashboard",
//                       style: TextStyle(
//                         fontSize: isDesktop ? 24 : 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),

//                     Space(height: 20),

//                     Container(
//                       margin: EdgeInsets.all(isDesktop ? 20 : 10),
//                       padding: EdgeInsets.all(isDesktop ? 20 : 10),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(14),
//                         boxShadow: const [
//                           BoxShadow(
//                             color: Colors.black12,
//                             blurRadius: 4,
//                             offset: Offset(0, 2),
//                           )
//                         ],
//                       ),
//                       child: SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: DataTable(
//                           dataRowMinHeight: 48,
//                           dataRowMaxHeight: 55,
//                           headingRowHeight: 55,
//                           headingRowColor: WidgetStateProperty.all(
//                             Colors.orange.shade100,
//                           ),
//                           border: TableBorder.all(
//                             color: Colors.grey.shade300,
//                           ),
//                           columnSpacing: isDesktop ? 40 : 20,

//                           /// ------------------ TABLE COLUMNS ------------------
//                           columns: keys.map<DataColumn>((key) {
//                             return DataColumn(
//                               label: Text(
//                                 key.replaceAll("_", " ").toUpperCase(),
//                                 style: TextStyle(
//                                   fontSize: isDesktop ? 15 : 13,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             );
//                           }).toList(),

//                           /// ------------------ TABLE ROWS ------------------
//                           rows: [
//                             /// Actual data rows
//                             ...dataList.map<DataRow>((item) {
//                               final map = item.toJson();

//                               return DataRow(
//                                 cells: keys.map<DataCell>((key) {
//                                   return DataCell(
//                                     Text(
//                                       map[key]?.toString() ?? "-",
//                                       style: TextStyle(
//                                         fontSize: isDesktop ? 14 : 12,
//                                       ),
//                                     ),
//                                   );
//                                 }).toList(),
//                               );
//                             }).toList(),

//                             /// ------------------ TOTAL ROW ------------------
//                             DataRow(
//                               color: WidgetStateProperty.all(
//                                 Colors.yellow.shade200,
//                               ),
//                               cells: keys.map<DataCell>((key) {
//                                 final totalValue = columnTotals[key];

//                                 return DataCell(
//                                   Text(
//                                     totalValue == null || totalValue == 0
//                                         ? "-"

//                                         /// non-numeric
//                                         : totalValue.toString(),
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: isDesktop ? 15 : 13,
//                                     ),
//                                   ),
//                                 );
//                               }).toList(),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }
// }
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/src/directorate/controller/directorate_controller.dart';
import 'package:taei_gov/src/district/controller/district_controller.dart';
import 'package:taei_gov/src/institutional/controller/institutional_controller.dart';
import 'package:taei_gov/src/login/controller/login_controller.dart';
import 'package:taei_gov/src/report_dashboard/controller/entry_dashboard_controller.dart';
import 'package:taei_gov/src/report_dashboard/models/entry_dashboard_model.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/utils/common/DistrictListSearchDropdown.dart';
import 'package:taei_gov/utils/common/hospital_dropdown.dart';
import 'package:taei_gov/utils/helpers/excel_helper.dart';

import '../../../../utils/common/start_end_date_picker.dart';

import '../../../../utils/helpers/page_loader.dart';
import 'patient_entry_report.dart';

class EntryDashboardScreen extends StatefulWidget {
  @override
  State<EntryDashboardScreen> createState() => _EntryDashboardScreenState();
}

class _EntryDashboardScreenState extends State<EntryDashboardScreen> {
  final controller = Get.put(EntryDashboardController());
  final loginController = Get.find<LoginController>();

  final InstitutionalController institutionController =
      Get.put(InstitutionalController());
  final DistrictController districtController = Get.put(DistrictController());
  final DirectorateController directorateController =
      Get.put((DirectorateController()));

  @override
  void initState() {
    institutionController.selectedInstitutionIds.clear();
    directorateController.selectedDirectorateId.value = 0;
    districtController.selectedDistrictId.value =
        loginController.districtId.value.toString() == 0
            ? ""
            : loginController.districtId.value.toString();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await institutionController.getInstitutionListData();
      await districtController.getDistrictListData();
      await directorateController.getDirectorateListData();
      await controller.getData2(
        startDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        endDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        institutionId: institutionController.institutionIdPayload,
        districtId: districtController.selectedDistrictId.value,
        directorateId: directorateController.selectedDirectorateId.value,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Obx(() {
      if (institutionController.isLoading.value) {
        return pageLoader();
      }
      if (controller.isLoading.value) {
        return pageLoader();
      }

      return context.isDesktop
          ? Column(
              children: [
                loginController.isAdmin == true
                    ? Row(
                        spacing: 30,
                        children: [
                          Expanded(
                            child: DistrictListSearchDropdown(
                              title: 'District',
                              hint: 'Select District',
                              items: districtController.districtList.toList(),
                              selectedId: int.parse(
                                  districtController.selectedDistrictId.value),
                              onChanged: (district) async {
                                districtController.selectedDistrictId.value =
                                    district!.toString();

                                await institutionController
                                    .getInstitutionListData(
                                  districtId: districtController
                                      .selectedDistrictId.value,
                                );
                                directorateController.getDirectorateListData();
                                directorateController
                                    .selectedDirectorateId.value = 0;
                                institutionController.selectedInstitutionIds
                                    .clear();
                                await controller.getData2(
                                  startDate: DateFormat('yyyy-MM-dd')
                                      .format(DateTime.now()),
                                  endDate: DateFormat('yyyy-MM-dd')
                                      .format(DateTime.now()),
                                  institutionId: institutionController
                                      .institutionIdPayload,
                                  districtId: districtController
                                      .selectedDistrictId.value
                                      .toString(),
                                  directorateId: directorateController
                                      .selectedDirectorateId.value,
                                );

                                log("MY selectedDirectorateId ${directorateController.selectedDirectorateId}");
                                log("MY selectedINSId ${institutionController.selectedInstitutionIds}");
                              },
                            ),
                          ),
                          Expanded(
                            child: DirectorateListSearchDropdown(
                              title: 'Directorate',
                              hint: 'Select Directorate',
                              items: directorateController.directorateList
                                  .toList(),
                              selectedId: directorateController
                                  .selectedDirectorateId.value,
                              onChanged: (district) async {
                                directorateController
                                    .selectedDirectorateId.value = district!;
                                await institutionController
                                    .getInstitutionListData(
                                        districtId: districtController
                                            .selectedDistrictId.value,
                                        directorateId: directorateController
                                            .selectedDirectorateId.value);
                                institutionController.selectedInstitutionIds
                                    .clear();
                                await controller.getData2(
                                  startDate: DateFormat('yyyy-MM-dd')
                                      .format(DateTime.now()),
                                  endDate: DateFormat('yyyy-MM-dd')
                                      .format(DateTime.now()),
                                  institutionId: institutionController
                                      .institutionIdPayload,
                                  districtId: districtController
                                      .selectedDistrictId.value
                                      .toString(),
                                  directorateId: directorateController
                                      .selectedDirectorateId.value,
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
                loginController.isDistrictAdmin == true
                    ? DirectorateListSearchDropdown(
                        title: 'Directorate',
                        hint: 'Select Directorate',
                        items: directorateController.directorateList.toList(),
                        selectedId:
                            directorateController.selectedDirectorateId.value,
                        onChanged: (district) async {
                          directorateController.selectedDirectorateId.value =
                              district!;
                          log("MY direct ${directorateController.selectedDirectorateId.value}");
                          log("MY district ${districtController.selectedDistrictId.value}");
                          log("MY Institution ${institutionController.institutionIdPayload}");
                          await institutionController.getInstitutionListData(
                              districtId:
                                  districtController.selectedDistrictId.value,
                              directorateId: directorateController
                                  .selectedDirectorateId.value);
                          await controller.getData2(
                            startDate:
                                DateFormat('yyyy-MM-dd').format(DateTime.now()),
                            endDate:
                                DateFormat('yyyy-MM-dd').format(DateTime.now()),
                            institutionId:
                                institutionController.institutionIdPayload,
                            districtId: districtController
                                .selectedDistrictId.value
                                .toString(),
                            directorateId: directorateController
                                .selectedDirectorateId.value,
                          );
                        },
                      )
                    : SizedBox(),
                Row(
                  children: [
                    Expanded(
                      child: DashBoardCommonDateRangePicker(
                        startDate: controller.fromDate.value,
                        endDate: controller.toDate.value,
                        onApply: () async {
                          await controller.getData2(
                            startDate: DateFormat('yyyy-MM-dd')
                                .format(controller.fromDate.value!),
                            endDate: DateFormat('yyyy-MM-dd')
                                .format(controller.toDate.value!),
                            institutionId:
                                institutionController.institutionIdPayload,
                            districtId: districtController
                                .selectedDistrictId.value
                                .toString(),
                            directorateId: directorateController
                                .selectedDirectorateId.value,
                          );
                        },
                        onDateSelected: (start, end) {
                          controller.fromDate.value = start;
                          controller.toDate.value = end;
                        },
                      ),
                    ),
                    Expanded(
                      child: MultipleHospitalSelectDropdown(
                          selectedIds:
                              institutionController.selectedInstitutionIds,
                          items: institutionController.institutionList
                                  .map((e) => {
                                        "hospitalid": int.tryParse(
                                            e.hospitalId.toString() ?? ''),
                                        "hospitalname": e.hospitalName ?? "",
                                      })
                                  .toList() ??
                              [],
                          onChanged: (value) async {
                            // await institutionController
                            //     .getInstitutionListData();
                            institutionController.selectedInstitutionIds.value =
                                value!;
                            await controller.getData2(
                              startDate: DateFormat('yyyy-MM-dd')
                                  .format(DateTime.now()),
                              endDate: DateFormat('yyyy-MM-dd')
                                  .format(DateTime.now()),
                              institutionId:
                                  institutionController.institutionIdPayload,
                              districtId: districtController
                                  .selectedDistrictId.value
                                  .toString(),
                              directorateId: directorateController
                                  .selectedDirectorateId.value,
                            );
                          }),
                    ),
                  ],
                ),
                Expanded(child: Obx(() {
                  if (controller.isLoading.value) {
                    return pageLoader();
                  }

                  final dataList = controller.entryData.value?.data ?? [];

                  if (dataList.isEmpty) {
                    return const Center(child: Text("No data found"));
                  }

                  /// Extract table headers
                  final keys = dataList.first.toJson().keys.toList();

                  /// -------------------- COMPUTE TOTALS --------------------
                  final Map<String, num> columnTotals = {};

                  for (var key in keys) {
                    num total = 0;

                    for (var item in dataList) {
                      final rawValue = item.toJson()[key];
                      final value = rawValue?.toString().trim() ?? "";
                      final parsed = num.tryParse(value);

                      if (parsed != null) {
                        total += parsed;
                      }
                    }

                    columnTotals[key] = total;
                  }

                  return Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              ExcelDownloadHelper.downloadExcel(
                                  headers: keys,
                                  data:
                                      dataList.map((e) => e.toJson()).toList());
                            },
                            child: Text("Download")),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              /// LEFT — GRID PANEL
                              Expanded(
                                flex: 3,
                                child: ListView.separated(
                                  padding: const EdgeInsets.all(12),
                                  itemCount: dataList.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 4),
                                  itemBuilder: (context, index) {
                                    final item = dataList[index];
                                    final bool isSelected =
                                        controller.selectedIndex.value == index;

                                    return InkWell(
                                      onTap: () {
                                        controller.selectHospital(index, item);
                                      },
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withOpacity(0.08)
                                              : Colors.teal.shade100,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: isSelected
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                : Colors.grey.shade300,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            /// LEFT DETAILS
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  /// Hospital name
                                                  Text(
                                                    item.hospitalName ?? "—",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 6),

                                                  /// Meta info row
                                                  Row(
                                                    children: [
                                                      _InfoChip(
                                                        icon: Icons
                                                            .bar_chart_outlined,
                                                        label: "Total 108 : ",
                                                        value:
                                                            " ${item.total108 ?? 0}",
                                                      ),
                                                      const SizedBox(width: 12),
                                                      _InfoChip(
                                                        icon: Icons
                                                            .pending_actions,
                                                        label: "Pending 108 : ",
                                                        value:
                                                            "${item.pending108 ?? 0}",
                                                      ),
                                                    ],
                                                  ),

                                                  const SizedBox(height: 4),

                                                  /// Date
                                                  _InfoChip(
                                                    icon: Icons
                                                        .location_on_outlined,
                                                    label: "District : ",
                                                    value:
                                                        "${item.districtName ?? ''}",
                                                  ),
                                                ],
                                              ),
                                            ),

                                            /// RIGHT ARROW
                                            Icon(
                                              Icons.chevron_right,
                                              size: 26,
                                              color: isSelected
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                  : Colors.grey,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              /// RIGHT — DETAILS PANEL
                              Expanded(
                                flex: 2,
                                child: controller.selectedDatum.value == null
                                    ? const _EmptyDetailsState()
                                    : HospitalDetailsPanel(
                                        datum: controller.selectedDatum.value!,
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }))
              ],
            )
          : Column(
              children: [
                loginController.isAdmin == true
                    ? DistrictListSearchDropdown(
                        title: 'District OO',
                        hint: 'Select District',
                        items: districtController.districtList.toList(),
                        selectedId: int.parse(
                            districtController.selectedDistrictId.value),
                        onChanged: (district) async {
                          districtController.selectedDistrictId.value =
                              district!.toString();

                          await institutionController.getInstitutionListData(
                            districtId:
                                districtController.selectedDistrictId.value,
                          );
                          directorateController.getDirectorateListData();
                          directorateController.selectedDirectorateId.value = 0;
                          institutionController.selectedInstitutionIds.clear();
                          await controller.getData2(
                            startDate:
                                DateFormat('yyyy-MM-dd').format(DateTime.now()),
                            endDate:
                                DateFormat('yyyy-MM-dd').format(DateTime.now()),
                            institutionId:
                                institutionController.institutionIdPayload,
                            districtId: districtController
                                .selectedDistrictId.value
                                .toString(),
                            directorateId: directorateController
                                .selectedDirectorateId.value,
                          );

                          log("MY selectedDirectorateId ${directorateController.selectedDirectorateId}");
                          log("MY selectedINSId ${institutionController.selectedInstitutionIds}");
                        },
                      )
                    : SizedBox(),
                loginController.isAdmin == true ||
                        loginController.isDistrictAdmin == true
                    ? DirectorateListSearchDropdown(
                        title: 'Directorate',
                        hint: 'Select Directorate',
                        items: directorateController.directorateList.toList(),
                        selectedId:
                            directorateController.selectedDirectorateId.value,
                        onChanged: (district) async {
                          directorateController.selectedDirectorateId.value =
                              district!;
                          await institutionController.getInstitutionListData(
                              districtId:
                                  districtController.selectedDistrictId.value,
                              directorateId: directorateController
                                  .selectedDirectorateId.value);
                          await controller.getData2(
                            startDate:
                                DateFormat('yyyy-MM-dd').format(DateTime.now()),
                            endDate:
                                DateFormat('yyyy-MM-dd').format(DateTime.now()),
                            institutionId:
                                institutionController.institutionIdPayload,
                            districtId: districtController
                                .selectedDistrictId.value
                                .toString(),
                            directorateId: directorateController
                                .selectedDirectorateId.value,
                          );
                        },
                      )
                    : SizedBox(),
                DashBoardCommonDateRangePicker(
                  startDate: controller.fromDate.value,
                  endDate: controller.toDate.value,
                  onApply: () async {
                    await controller.getData2(
                      startDate: DateFormat('yyyy-MM-dd')
                          .format(controller.fromDate.value!),
                      endDate: DateFormat('yyyy-MM-dd')
                          .format(controller.toDate.value!),
                      institutionId: institutionController.institutionIdPayload,
                      districtId: districtController.selectedDistrictId.value
                          .toString(),
                      directorateId:
                          directorateController.selectedDirectorateId.value,
                    );
                  },
                  onDateSelected: (start, end) {
                    controller.fromDate.value = start;
                    controller.toDate.value = end;
                  },
                ),
                MultipleHospitalSelectDropdown(
                    selectedIds: institutionController.selectedInstitutionIds,
                    items: institutionController.institutionList
                            .map((e) => {
                                  "hospitalid": int.tryParse(
                                      e.hospitalId.toString() ?? ''),
                                  "hospitalname": e.hospitalName ?? "",
                                })
                            .toList() ??
                        [],
                    onChanged: (value) async {
                      // await institutionController
                      //     .getInstitutionListData();
                      institutionController.selectedInstitutionIds.value =
                          value!;
                      await controller.getData2(
                        startDate:
                            DateFormat('yyyy-MM-dd').format(DateTime.now()),
                        endDate:
                            DateFormat('yyyy-MM-dd').format(DateTime.now()),
                        institutionId:
                            institutionController.institutionIdPayload,
                        districtId: districtController.selectedDistrictId.value
                            .toString(),
                        directorateId:
                            directorateController.selectedDirectorateId.value,
                      );
                    }),
                Obx(() {
                  if (controller.isLoading.value) {
                    return pageLoader();
                  }

                  final dataList = controller.entryData.value?.data ?? [];

                  /// Extract table headers
                  final keys = dataList.first.toJson().keys.toList();

                  /// -------------------- COMPUTE TOTALS --------------------
                  final Map<String, num> columnTotals = {};

                  for (var key in keys) {
                    num total = 0;

                    for (var item in dataList) {
                      final rawValue = item.toJson()[key];
                      final value = rawValue?.toString().trim() ?? "";
                      final parsed = num.tryParse(value);

                      if (parsed != null) {
                        total += parsed;
                      }
                    }

                    columnTotals[key] = total;
                  }

                  return SizedBox(
                    height: 550,
                    child: Column(
                      children: [
                        /// 🔹 TOP SUMMARY CARD
                        Container(
                          margin: const EdgeInsets.all(12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              colors: [
                                Colors.teal.shade400,
                                Colors.teal.shade700,
                              ],
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Hospitals",
                                style: TextStyle(color: Colors.white70),
                              ),
                              Text(
                                dataList.length.toString(),
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// 🔹 DOWNLOAD BUTTON (Compact)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                ExcelDownloadHelper.downloadExcel(
                                  headers: keys,
                                  data:
                                      dataList.map((e) => e.toJson()).toList(),
                                );
                              },
                              icon: const Icon(Icons.download),
                              label: const Text("Download"),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        /// 🔹 LIST
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(12),
                            itemCount: dataList.length,
                            itemBuilder: (context, index) {
                              final item = dataList[index];

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                    onTap: () {
                                      _showHospitalDetails(context, item);
                                    },
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(18),
                                        onTap: () {
                                          _showHospitalDetails(context, item);
                                        },
                                        child: Ink(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.teal.shade50,
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            border: Border.all(
                                                color: Colors.grey.shade200),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.04),
                                                blurRadius: 8,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              /// 🔹 Top Row (Hospital Name + Arrow)
                                              Row(
                                                children: [
                                                  const Icon(
                                                      Icons.local_hospital,
                                                      size: 18,
                                                      color: Colors.teal),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      item.hospitalName ?? "—",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                  const Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 14,
                                                    color: Colors.grey,
                                                  )
                                                ],
                                              ),

                                              const SizedBox(height: 12),

                                              /// 🔹 Stats (Using Wrap for mobile safety)
                                              Wrap(
                                                spacing: 12,
                                                runSpacing: 8,
                                                children: [
                                                  _MiniStat(
                                                    label: "Total 108",
                                                    value: item.total108
                                                            ?.toString() ??
                                                        "0",
                                                    color: Colors.blue,
                                                  ),
                                                  _MiniStat(
                                                    label: "Pending",
                                                    value: item.pending108
                                                            ?.toString() ??
                                                        "0",
                                                    color: Colors.orange,
                                                  ),
                                                ],
                                              ),

                                              const SizedBox(height: 10),

                                              /// 🔹 District
                                              Row(
                                                children: [
                                                  const Icon(
                                                      Icons
                                                          .location_on_outlined,
                                                      size: 14,
                                                      color: Colors.grey),
                                                  const SizedBox(width: 4),
                                                  Expanded(
                                                    child: Text(
                                                      item.districtName ?? "",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors
                                                            .grey.shade600,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                })
              ],
            );
    }));
  }

  // for Mobile
  void _showHospitalDetails(BuildContext context, EntryDashboardData item) {
    showDialog(
      context: context,
      builder: (_) {
        return HospitalDetailsPanel(datum: item);
      },
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoChip(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: Color(0xff22577A),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          maxLines: 1,
          style: TextStyle(
            overflow: TextOverflow.ellipsis,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xff22577A),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          maxLines: 1,
          value,
          style: TextStyle(
            overflow: TextOverflow.ellipsis,
            fontSize: 12,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class _EmptyDetailsState extends StatelessWidget {
  const _EmptyDetailsState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Select a hospital to view details",
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}

class HospitalDetailsPanel extends StatelessWidget {
  final EntryDashboardData datum;

  const HospitalDetailsPanel({super.key, required this.datum});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    final items = [
      _Item(
        title: "Triage",
        active: '',
        total: datum.triage,
        icon: Icons.local_hospital,
        color: Colors.red,
      ),
      _Item(
        title: "EMO",
        active: '',
        total: datum.emo,
        icon: Icons.medical_services_outlined,
        color: Colors.pinkAccent,
      ),
      _Item(
        title: "Trauma",
        active: datum.trauma,
        total: datum.totalTrauma,
        icon: Icons.healing,
        color: primary,
      ),
      _Item(
        title: "Burns",
        active: datum.burns,
        total: datum.totalBurns,
        icon: Icons.local_fire_department,
        color: Colors.deepOrange,
      ),
      _Item(
        title: "Poisoning",
        active: datum.poisoning,
        total: datum.totalPoisoning,
        icon: Icons.science,
        color: Colors.purple,
      ),
      _Item(
        title: "Bites / Stings",
        active: datum.bitesStings,
        total: datum.totalBitesStings,
        icon: Icons.bug_report,
        color: Colors.green,
      ),
      _Item(
        title: "Hanging",
        active: datum.hanging,
        total: datum.totalHanging,
        icon: Icons.report,
        color: Colors.brown,
      ),
      _Item(
        title: "Drowning",
        active: datum.drowning,
        total: datum.totalDrowning,
        icon: Icons.water,
        color: Colors.blue,
      ),
      _Item(
        title: "Stroke",
        active: datum.stroke,
        total: datum.totalStroke,
        icon: Icons.favorite,
        color: Colors.redAccent,
      ),
      _Item(
        title: "STEMI",
        active: datum.stemi,
        total: datum.totalStemi,
        icon: Icons.monitor_heart,
        color: Colors.pink,
      ),
      _Item(
        title: "PREM",
        active: datum.prem,
        total: datum.totalPrem,
        icon: Icons.emergency,
        color: Colors.indigo,
      ),
    ];

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: primary.withOpacity(0.1),
                child: Icon(Icons.local_hospital, color: primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      datum.hospitalName ?? "-",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Case summary",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          Divider(color: Colors.grey.shade300),
          const SizedBox(height: 4),

          /// LIST VIEW (CLEAN)
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 1, color: Colors.grey.shade200),
              itemBuilder: (context, index) {
                final item = items[index];
                return _listRow(item);
              },
            ),
          ),

          const SizedBox(height: 8),

          /// CTA
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.arrow_forward),
              label: const Text("View Full Report"),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Get.to(
                  () => PatientReportScreen(
                    hospitalid: datum.hospitalid ?? 0,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// LIST ROW
  Widget _listRow(_Item item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// ICON
          CircleAvatar(
            radius: 18,
            backgroundColor: item.color.withOpacity(0.15),
            child: Icon(item.icon, size: 18, color: item.color),
          ),

          const SizedBox(width: 12),

          /// TITLE + COUNTS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _badge(
                      "Active",
                      item.active,
                      item.color,
                    ),
                    const SizedBox(width: 8),
                    _badge(
                      "Total",
                      item.total,
                      Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// ARROW
          Icon(
            Icons.chevron_right,
            size: 22,
            color: Colors.grey.shade400,
          ),
        ],
      ),
    );
  }

  Widget _badge(String label, String? value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              fontSize: 11,
              color: color,
            ),
          ),
          Text(
            value ?? "0",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// For Mobile
///
class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// MODEL FOR CLEAN CODE
class _Item {
  final String title;
  final String? active;
  final String? total;
  final IconData icon;
  final Color color;

  _Item({
    required this.title,
    required this.active,
    required this.total,
    required this.icon,
    required this.color,
  });
}
