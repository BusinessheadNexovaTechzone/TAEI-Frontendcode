import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/src/dashboards/taei_report/model/report_type_model.dart';
import 'package:taei_gov/src/directorate/controller/directorate_controller.dart';
import 'package:taei_gov/src/district/controller/district_controller.dart';
import 'package:taei_gov/src/institutional/controller/institutional_controller.dart';
import 'package:taei_gov/src/login/controller/login_controller.dart';
import 'package:taei_gov/src/report_dashboard/controller/report_dashboard_controller.dart';
import 'package:taei_gov/src/report_dashboard/views/burns_report.dart';
import 'package:taei_gov/src/report_dashboard/views/poison_report.dart';
import 'package:taei_gov/src/report_dashboard/views/prem_report.dart';
import 'package:taei_gov/src/report_dashboard/views/stroke_report.dart';
import 'package:taei_gov/src/report_dashboard/views/trauma_report.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/utils/common/DistrictListSearchDropdown.dart';
import 'package:taei_gov/utils/common/appbar.dart';
import 'package:taei_gov/utils/common/hospital_dropdown.dart';
import 'package:taei_gov/utils/common/start_end_date_picker.dart';
import 'package:taei_gov/utils/helpers/excel_helper.dart';

import '../../../utils/common/error_dialog.dart';
import '../../../utils/helpers/space.dart';
import 'byte_report.dart';
import 'stemi_report.dart';

class ReportDashboard extends StatefulWidget {
  final bool from;

  const ReportDashboard({Key? key, this.from = false}) : super(key: key);

  @override
  State<ReportDashboard> createState() => _ReportDashboardState();
}

class _ReportDashboardState extends State<ReportDashboard> {
  final LoginController loginController = Get.find();
  final ReportDashboardController controller =
      Get.put(ReportDashboardController());
  final InstitutionalController institutionController =
      Get.put(InstitutionalController());
  final DistrictController districtController = Get.put(DistrictController());
  final DirectorateController directorateController =
      Get.put((DirectorateController()));

  final List<ReportTypeModel> reportTypes = [
    //{"id": 3, "name": "Trauma", "icon": Icons.health_and_safety},
    //     {"id": 4, "name": "Burns", "icon": Icons.local_fire_department},
    //     {"id": 5, "name": "Poisoning", "icon": Icons.science_outlined},
    //     {"id": 6, "name": "Bytes & Stings", "icon": Icons.browse_gallery_outlined},
    //     {"id": 8, "name": "Stroke", "icon": Icons.bloodtype},
    //     {"id": 9, "name": "Prem", "icon": Icons.child_friendly},
    //     {"id": 10, "name": "Stemi", "icon": Icons.monitor_heart},
    ReportTypeModel(id: 3, title: "Trauma", icon: Icons.health_and_safety),
    ReportTypeModel(id: 4, title: "Burns", icon: Icons.local_fire_department),
    ReportTypeModel(id: 5, title: "Poisoning", icon: Icons.science_outlined),
    ReportTypeModel(
        id: 6, title: "Bytes & Stings", icon: Icons.browse_gallery_outlined),
    ReportTypeModel(id: 8, title: "Stroke", icon: Icons.bloodtype),
    ReportTypeModel(id: 9, title: "Prem", icon: Icons.child_friendly),
    ReportTypeModel(id: 10, title: "STEMI", icon: Icons.monitor_heart),
  ];

  final List<Map<String, dynamic>> pillars = const [
    {"id": 3, "name": "Trauma", "icon": Icons.health_and_safety},
    {"id": 4, "name": "Burns", "icon": Icons.local_fire_department},
    {"id": 5, "name": "Poisoning", "icon": Icons.science_outlined},
    {"id": 6, "name": "Bytes & Stings", "icon": Icons.browse_gallery_outlined},
    {"id": 8, "name": "Stroke", "icon": Icons.bloodtype},
    {"id": 9, "name": "Prem", "icon": Icons.child_friendly},
    {"id": 10, "name": "Stemi", "icon": Icons.monitor_heart},
  ];

  Color _getReportColor(int id) {
    switch (id) {
      case 21:
        return Colors.indigo;
      case 1:
        return Colors.red;
      case 3:
        return Colors.deepOrange;
      case 4:
        return Colors.red;
      case 5:
        return Colors.purple;
      case 6:
        return Colors.green;
      case 7:
        return Colors.blueGrey;
      case 8:
        return Colors.blue;
      case 9:
        return Colors.teal;
      case 10:
        return Colors.pink;
      case 11:
        return Colors.deepPurple;
      case 0:
        return Colors.black87; // Full Data (restricted)
      case 20:
        return Colors.cyan;
      default:
        return Colors.grey;
    }
  }

  @override
  void initState() {
    institutionController.selectedInstitutionIds.clear();
    directorateController.selectedDirectorateId.value = 0;
    districtController.selectedDistrictId.value =
        loginController.districtId.value.toString() == 0
            ? ""
            : loginController.districtId.value.toString();
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller.fromDate.value = DateTime.now();
      controller.toDate.value = DateTime.now();
      await institutionController.getInstitutionListData();
      await districtController.getDistrictListData();
      await directorateController.getDirectorateListData();
      // await controller.getData(
      //   startDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      //   endDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      //   reportType: controller.reportType.value,
      //   institutionId: institutionController.institutionId.value,
      // );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe1e9f4),
      appBar: widget.from
          ? CommonAppBar(
              title: 'TAEI Report',
            )
          : null,
      body: Obx(() {
        if (institutionController.isLoading.value ||
            controller.isDataLoading.value) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return context.isDesktop
            ? Column(children: [
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
                                await controller.getData(
                                  startDate:
                                      controller.fromDate.value.toString(),
                                  endDate: controller.toDate.value.toString(),
                                  reportType: controller.reportType.value,
                                  institutionId: institutionController
                                      .institutionIdPayload,
                                  districtId: districtController
                                      .selectedDistrictId.value,
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
                                await controller.getData(
                                  startDate:
                                      controller.fromDate.value.toString(),
                                  endDate: controller.toDate.value.toString(),
                                  reportType: controller.reportType.value,
                                  institutionId: institutionController
                                      .institutionIdPayload,
                                  districtId: districtController
                                      .selectedDistrictId.value,
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
                          await controller.getData(
                            startDate: controller.fromDate.value.toString(),
                            endDate: controller.toDate.value.toString(),
                            reportType: controller.reportType.value,
                            institutionId:
                                institutionController.institutionIdPayload,
                            districtId:
                                districtController.selectedDistrictId.value,
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
                          await controller.getData(
                            startDate: controller.fromDate.value.toString(),
                            endDate: controller.toDate.value.toString(),
                            reportType: controller.reportType.value,
                            institutionId:
                                institutionController.institutionIdPayload,
                            districtId:
                                districtController.selectedDistrictId.value,
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
                            await controller.getData(
                                startDate: DateFormat('yyyy-MM-dd')
                                    .format(DateTime.now()),
                                endDate: DateFormat('yyyy-MM-dd')
                                    .format(DateTime.now()),
                                reportType: controller.reportType.value,
                                institutionId:
                                    institutionController.institutionIdPayload);
                          }),
                    )
                  ],
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: context.isDesktop ? 3 : 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: context.isDesktop ? 4 : 1.5,
                    ),
                    padding: const EdgeInsets.all(12),
                    itemCount: reportTypes.length,
                    itemBuilder: (context, index) {
                      final report = reportTypes[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () async {
                            log("Report Type ${report.id}");
                            await controller.getData(
                              startDate: controller.fromDate.value.toString(),
                              endDate: controller.toDate.value.toString(),
                              reportType: report.id,
                              institutionId:
                                  institutionController.institutionIdPayload,
                            );
                            final dataList = controller.selectedReportData;

                            if (dataList.isEmpty) {
                              CommonErrorDialog.show(Get.context!,
                                  message: 'No data found to download');
                              return;
                            }

                            log("Report Type 33 ${report.id}");

                            /// Convert model list → map list
                            final List<Map<String, dynamic>> excelData =
                                dataList
                                    .map((e) =>
                                        e.toJson() as Map<String, dynamic>)
                                    .toList();

                            /// --------- Compute Headers Dynamically ----------
                            final keys = dataList.first.toJson().keys.toList();

                            /// --------- Compute Totals (Optional) ----------

                            final Map<String, num> columnTotals = {};

                            for (var key in keys) {
                              num total = 0;

                              for (var item in dataList) {
                                final rawValue = item.toJson()[key];
                                final parsed =
                                    num.tryParse(rawValue?.toString() ?? '');
                                if (parsed != null) total += parsed;
                              }

                              columnTotals[key] = total;
                            }

                            /// --------- Download Excel ----------
                            ExcelDownloadHelper.downloadExcel(
                              headers: keys,
                              data: excelData,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color:
                                  _getReportColor(report.id).withOpacity(0.90),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ICON
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    // color:
                                    //     _getReportColor(report.id).withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    report.icon,
                                    color: _getReportColor(report.id),
                                  ),
                                ),

                                const SizedBox(width: 14),

                                // TEXT AREA
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        report.title,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      ),
                                      const SizedBox(height: 4),

                                      // OPTIONAL SUB TEXT
                                      Text(
                                        "Tap to download report",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // DOWNLOAD
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.download_for_offline_rounded,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ])
            : Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Column(children: [
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
                            directorateController.selectedDirectorateId.value =
                                0;
                            institutionController.selectedInstitutionIds
                                .clear();
                            await controller.getData(
                              startDate: controller.fromDate.value.toString(),
                              endDate: controller.toDate.value.toString(),
                              reportType: controller.reportType.value,
                              institutionId:
                                  institutionController.institutionIdPayload,
                              districtId:
                                  districtController.selectedDistrictId.value,
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
                            await controller.getData(
                              startDate: controller.fromDate.value.toString(),
                              endDate: controller.toDate.value.toString(),
                              reportType: controller.reportType.value,
                              institutionId:
                                  institutionController.institutionIdPayload,
                              districtId:
                                  districtController.selectedDistrictId.value,
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
                      await controller.getData(
                        startDate: controller.fromDate.value.toString(),
                        endDate: controller.toDate.value.toString(),
                        reportType: controller.reportType.value,
                        institutionId:
                            institutionController.institutionIdPayload,
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
                        // await institutionController.getInstitutionListData();
                        institutionController.selectedInstitutionIds.value =
                            value!;
                        await controller.getData(
                            startDate:
                                DateFormat('yyyy-MM-dd').format(DateTime.now()),
                            endDate:
                                DateFormat('yyyy-MM-dd').format(DateTime.now()),
                            reportType: controller.reportType.value,
                            institutionId:
                                institutionController.institutionIdPayload);
                      }),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: context.isDesktop ? 3 : 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: context.isDesktop ? 4 : 1.5,
                      ),
                      padding: const EdgeInsets.all(12),
                      itemCount: reportTypes.length,
                      itemBuilder: (context, index) {
                        final report = reportTypes[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () async {
                              log("Report Type ${report.id}");
                              await controller.getData(
                                startDate: controller.fromDate.value.toString(),
                                endDate: controller.toDate.value.toString(),
                                reportType: report.id,
                                institutionId:
                                    institutionController.institutionIdPayload,
                              );
                              final dataList = controller.selectedReportData;

                              if (dataList.isEmpty) {
                                CommonErrorDialog.show(Get.context!,
                                    message: 'No data found to download');
                                return;
                              }

                              log("Report Type 33 ${report.id}");

                              /// Convert model list → map list
                              final List<Map<String, dynamic>> excelData =
                                  dataList
                                      .map((e) =>
                                          e.toJson() as Map<String, dynamic>)
                                      .toList();

                              /// --------- Compute Headers Dynamically ----------
                              final keys =
                                  dataList.first.toJson().keys.toList();

                              /// --------- Compute Totals (Optional) ----------

                              final Map<String, num> columnTotals = {};

                              for (var key in keys) {
                                num total = 0;

                                for (var item in dataList) {
                                  final rawValue = item.toJson()[key];
                                  final parsed =
                                      num.tryParse(rawValue?.toString() ?? '');
                                  if (parsed != null) total += parsed;
                                }

                                columnTotals[key] = total;
                              }

                              /// --------- Download Excel ----------
                              ExcelDownloadHelper.downloadExcel(
                                headers: keys,
                                data: excelData,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: _getReportColor(report.id)
                                    .withOpacity(0.90),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // ICON
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      // color:
                                      //     _getReportColor(report.id).withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      report.icon,
                                      color: _getReportColor(report.id),
                                    ),
                                  ),

                                  const SizedBox(width: 14),

                                  // TEXT AREA
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          report.title,
                                          maxLines: 2,
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black),
                                        ),
                                        const SizedBox(height: 4),

                                        // OPTIONAL SUB TEXT
                                        Text(
                                          "Tap to download report",
                                          maxLines: 2,
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // DOWNLOAD
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.download_for_offline_rounded,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ]),
              );
      }),
    );
  }
}

class ReportPillarChipSelector extends StatelessWidget {
  final RxInt selectedPillar;
  final Function(int) onChanged;

  ReportPillarChipSelector({
    super.key,
    required this.selectedPillar,
    required this.onChanged,
  });

  final List<Map<String, dynamic>> pillars = const [
    {"id": 3, "name": "Trauma", "icon": Icons.health_and_safety},
    {"id": 4, "name": "Burns", "icon": Icons.local_fire_department},
    {"id": 5, "name": "Poisoning", "icon": Icons.science_outlined},
    {"id": 6, "name": "Bytes & Stings", "icon": Icons.browse_gallery_outlined},
    {"id": 8, "name": "Stroke", "icon": Icons.bloodtype},
    {"id": 9, "name": "Prem", "icon": Icons.child_friendly},
    {"id": 10, "name": "Stemi", "icon": Icons.monitor_heart},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: pillars.length,
        separatorBuilder: (_, __) => const SizedBox(width: 22),
        itemBuilder: (_, index) {
          final p = pillars[index];

          return Obx(() {
            final bool isSelected = selectedPillar.value == p["id"];

            return GestureDetector(
              onTap: () => onChanged(p["id"]),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blueAccent : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  // border: Border.all(
                  //   color: isSelected ? Colors.blueAccent : Colors.black,
                  //   width: 1.2,
                  // ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      p["icon"],
                      size: 20,
                      color: isSelected ? Colors.white : Colors.black54,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      p["name"],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }
}

class DownloadReportPillarChipSelector extends StatelessWidget {
  final RxInt selectedPillar;
  final Function(int) onChanged;
  final Function(int) onDownload; // 👈 NEW

  DownloadReportPillarChipSelector({
    super.key,
    required this.selectedPillar,
    required this.onChanged,
    required this.onDownload,
  });

  final List<Map<String, dynamic>> pillars = const [
    {"id": 3, "name": "Trauma", "icon": Icons.health_and_safety},
    {"id": 4, "name": "Burns", "icon": Icons.local_fire_department},
    {"id": 5, "name": "Poisoning", "icon": Icons.science_outlined},
    {"id": 6, "name": "Bytes & Stings", "icon": Icons.browse_gallery_outlined},
    {"id": 8, "name": "Stroke", "icon": Icons.bloodtype},
    {"id": 9, "name": "Prem", "icon": Icons.child_friendly},
    {"id": 10, "name": "Stemi", "icon": Icons.monitor_heart},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: pillars.length,
        separatorBuilder: (_, __) => const SizedBox(width: 22),
        itemBuilder: (_, index) {
          final p = pillars[index];

          return Obx(() {
            final bool isSelected = selectedPillar.value == p["id"];

            return GestureDetector(
              onTap: () => onChanged(p["id"]),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blueAccent : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  // border: Border.all(
                  //   color: isSelected ? Colors.blueAccent : Colors.black,
                  //   width: 1.2,
                  // ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      p["icon"],
                      size: 20,
                      color: isSelected ? Colors.white : Colors.black54,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      p["name"],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 8),

                    // ⬇️ DOWNLOAD ICON
                    GestureDetector(
                      onTap: () => onDownload(p["id"]),
                      child: Icon(
                        Icons.download,
                        size: 18,
                        color: isSelected ? Colors.white : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }
}
