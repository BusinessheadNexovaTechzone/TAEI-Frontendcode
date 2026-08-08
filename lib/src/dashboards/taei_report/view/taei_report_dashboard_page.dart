import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/src/dashboards/taei_report/controller/taei_report_dashboard_controller.dart';
import 'package:taei_gov/src/dashboards/taei_report/model/report_type_model.dart';
import 'package:taei_gov/src/directorate/controller/directorate_controller.dart';
import 'package:taei_gov/src/district/controller/district_controller.dart';
import 'package:taei_gov/src/institutional/controller/institutional_controller.dart';
import 'package:taei_gov/src/login/controller/login_controller.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/utils/common/DistrictListSearchDropdown.dart';
import 'package:taei_gov/utils/common/appbar.dart';
import 'package:taei_gov/utils/common/hospital_dropdown.dart';
import 'package:taei_gov/utils/common/start_end_date_picker.dart';

class TAEIReportDashboardPage extends StatefulWidget {
  final bool from;

  const TAEIReportDashboardPage({super.key, this.from = false});

  @override
  State<TAEIReportDashboardPage> createState() =>
      _TAEIReportDashboardPageState();
}

class _TAEIReportDashboardPageState extends State<TAEIReportDashboardPage> {
  final LoginController loginController = Get.find();
  final TAEIReportDashboardController taeiReportDashboardController =
      Get.put(TAEIReportDashboardController());
  final InstitutionalController institutionController =
      Get.put(InstitutionalController());
  final DistrictController districtController = Get.put(DistrictController());
  final DirectorateController directorateController =
      Get.put((DirectorateController()));

  final List<ReportTypeModel> reportTypes = [
    ReportTypeModel(
        id: 21, title: "Triage EMO Report", icon: Icons.local_hospital),
    ReportTypeModel(id: 1, title: "Trauma", icon: Icons.healing),
    ReportTypeModel(id: 3, title: "Burns", icon: Icons.whatshot),
    ReportTypeModel(id: 5, title: "Poison", icon: Icons.science),
    ReportTypeModel(id: 6, title: "Bites & Stings", icon: Icons.bug_report),
    ReportTypeModel(id: 7, title: "Hanging", icon: Icons.air),
    ReportTypeModel(id: 8, title: "Drowning", icon: Icons.water),
    ReportTypeModel(id: 9, title: "Prem", icon: Icons.child_friendly),
    ReportTypeModel(id: 10, title: "Stroke", icon: Icons.favorite),
    ReportTypeModel(id: 11, title: "STEMI", icon: Icons.monitor_heart),
    ReportTypeModel(id: 0, title: "Full Data", icon: Icons.dataset),
    ReportTypeModel(
        id: 20, title: "Hospital Wise Entry Count", icon: Icons.bar_chart),
  ];

  Color _getReportColor(int id) {
    switch (id) {
      case 21:
        return Colors.indigo;
      case 1:
        return Colors.red;
      case 3:
        return Colors.deepOrange;
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
    taeiReportDashboardController.StartDate.value = DateTime.now();
    taeiReportDashboardController.EndDate.value = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await institutionController.getInstitutionListData();
      await districtController.getDistrictListData();
      await directorateController.getDirectorateListData();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffe1e9f4),
        appBar: widget.from
            ? CommonAppBar(
                title: 'Institutional Dashboard',
              )
            : null,
        body: Obx(() {
          return Column(children: [
            context.isDesktop
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
                                    items: districtController.districtList
                                        .toList(),
                                    selectedId: int.parse(districtController
                                        .selectedDistrictId.value),
                                    onChanged: (district) async {
                                      districtController.selectedDistrictId
                                          .value = district!.toString();

                                      await institutionController
                                          .getInstitutionListData(
                                        districtId: districtController
                                            .selectedDistrictId.value,
                                      );
                                      directorateController
                                          .getDirectorateListData();
                                      directorateController
                                          .selectedDirectorateId.value = 0;
                                      institutionController
                                          .selectedInstitutionIds
                                          .clear();

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
                                          .selectedDirectorateId
                                          .value = district!;
                                      await institutionController
                                          .getInstitutionListData(
                                              districtId: districtController
                                                  .selectedDistrictId.value,
                                              directorateId:
                                                  directorateController
                                                      .selectedDirectorateId
                                                      .value);
                                      institutionController
                                          .selectedInstitutionIds
                                          .clear();
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
                              },
                            )
                          : SizedBox(),
                      Row(
                        children: [
                          Expanded(
                            child: TAEIDashBoardCommonDateRangePicker(
                              startDate:
                                  taeiReportDashboardController.StartDate.value,
                              endDate:
                                  taeiReportDashboardController.EndDate.value,
                              onApply: () async {},
                              onDateSelected: (start, end) {
                                taeiReportDashboardController.StartDate.value =
                                    start;
                                taeiReportDashboardController.EndDate.value =
                                    end;
                              },
                            ),
                          ),
                          Expanded(
                            child: MultipleHospitalSelectDropdown(
                                selectedIds: institutionController
                                    .selectedInstitutionIds,
                                items: institutionController.institutionList
                                        .map((e) => {
                                              "hospitalid": int.tryParse(
                                                  e.hospitalId.toString() ??
                                                      ''),
                                              "hospitalname":
                                                  e.hospitalName ?? "",
                                            })
                                        .toList() ??
                                    [],
                                onChanged: (value) async {
                                  // await institutionController
                                  //     .getInstitutionListData();
                                  institutionController
                                      .selectedInstitutionIds.value = value!;
                                }),
                          ),
                        ],
                      ),
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
                              },
                            )
                          : SizedBox(),
                      TAEIDashBoardCommonDateRangePicker(
                        startDate:
                            taeiReportDashboardController.StartDate.value,
                        endDate: taeiReportDashboardController.EndDate.value,
                        onApply: () async {},
                        onDateSelected: (start, end) {
                          taeiReportDashboardController.StartDate.value = start;
                          taeiReportDashboardController.EndDate.value = end;
                        },
                      ),
                      MultipleHospitalSelectDropdown(
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
                          }),
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
                      onTap: () => _onReportClick(report),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: _getReportColor(report.id).withOpacity(0.90),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    report.title,
                                    maxLines: 2,
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: report.id == 0
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                  const SizedBox(height: 4),

                                  // OPTIONAL SUB TEXT
                                  Text(
                                    report.id == 0
                                        ? "Restricted to 5 days only"
                                        : "Tap to download report",
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
          ]);
        }));
  }

  void _onReportClick(
    ReportTypeModel report,
  ) {
    final DateTime? start = taeiReportDashboardController.StartDate.value;
    final DateTime? end = taeiReportDashboardController.EndDate.value;

    // 🔴 Safety check
    if (start == null || end == null) {
      Get.snackbar(
        "Date Required",
        "Please select start and end date",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final days = taeiReportDashboardController.EndDate.value!
            .difference(taeiReportDashboardController.StartDate.value!)
            .inDays +
        1;

    // 🔴 Validation only for Full Data
    if (report.id == 0 && days > 5) {
      _showDateErrorDialog();
      return;
    }

    // ✅ API call
    taeiReportDashboardController.getTAEIReportDashboard(
      startDate: start.toString(),
      endDate: end.toString(),
      reportType: report.id,
      institutionId: institutionController.institutionIdPayload,
      directorateId:
          directorateController.selectedDirectorateId.value.toString(),
      districtId: districtController.selectedDistrictId.value.toString(),
    );
  }

  void _showDateErrorDialog() {
    Get.dialog(
      Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: Get.width > 500 ? 420 : Get.width * 0.9,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔴 Warning Icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    size: 30,
                    color: Colors.red.shade600,
                  ),
                ),

                const SizedBox(height: 16),

                // Title
                const Text(
                  "Date Range Limit",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 10),

                // Description
                const Text(
                  "Full Data report can be generated for a maximum of 5 days only.\n\nPlease adjust the selected date range.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 20),

                // Action Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "OK, Got It",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
