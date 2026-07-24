import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_animate/animate.dart';
import 'package:flutter_animate/effects/effects.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/src/directorate/controller/directorate_controller.dart';
import 'package:taei_gov/src/district/controller/district_controller.dart';
import 'package:taei_gov/src/institutional/controller/institutional_controller.dart';

import 'package:taei_gov/src/kpidashborad/view/burns_daashboard.dart';
import 'package:taei_gov/src/kpidashborad/view/poisoning_kpi_dashboard_page.dart';
import 'package:taei_gov/src/kpidashborad/view/prem_dashboard.dart';
import 'package:taei_gov/src/kpidashborad/view/scriptdashboard.dart';
import 'package:taei_gov/src/kpidashborad/view/stemi_kpi.dart';
import 'package:taei_gov/src/kpidashborad/view/taei_dashboard.dart';
import 'package:taei_gov/src/kpidashborad/view/trauma_dashboard.dart';
import 'package:taei_gov/src/login/controller/login_controller.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/utils/common/DistrictListSearchDropdown.dart';
import 'package:taei_gov/utils/common/appbar.dart';
import 'package:taei_gov/utils/common/hospital_dropdown.dart';
import 'package:taei_gov/utils/common/space.dart';
import 'package:taei_gov/utils/common/start_end_date_picker.dart';

import '../../report_dashboard/views/entry_report/patient_entry_report.dart';
import '../commondatepickertest.dart';
import '../controller/controlller.dart';

class kpiDashboard extends StatefulWidget {
  final bool from;

  const kpiDashboard({Key? key, this.from = false}) : super(key: key);

  @override
  State<kpiDashboard> createState() => _kpiDashboardState();
}

class _kpiDashboardState extends State<kpiDashboard> {
  final LoginController loginController = Get.find();
  final KpiDashboard controller = Get.put(KpiDashboard());
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await institutionController.getInstitutionListData();
      await districtController.getDistrictListData();
      await directorateController.getDirectorateListData();
      await controller.getKPIDashboard(
        startDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        endDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        reportType: controller.selectedPillar.value,
        institutionId: institutionController.institutionIdPayload,
        districtId: districtController.selectedDistrictId.value,
        directorateId: directorateController.selectedDirectorateId.value,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe1e9f4),
      appBar: widget.from
          ? CommonAppBar(
              title: 'KPI Dashboard',
            )
          : null,
      body: Obx(() {
        if (institutionController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.isDesktop ? 40 : 16,
            vertical: context.isDesktop ? 24 : 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                                        await controller.getKPIDashboard(
                                          startDate:
                                              controller.StartDate.toString(),
                                          endDate:
                                              controller.EndDate.toString(),
                                          reportType:
                                              controller.selectedPillar.value,
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
                                      items: directorateController
                                          .directorateList
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
                                        await controller.getKPIDashboard(
                                          startDate:
                                              controller.StartDate.toString(),
                                          endDate:
                                              controller.EndDate.toString(),
                                          reportType:
                                              controller.selectedPillar.value,
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
                                items: directorateController.directorateList
                                    .toList(),
                                selectedId: directorateController
                                    .selectedDirectorateId.value,
                                onChanged: (district) async {
                                  directorateController
                                      .selectedDirectorateId.value = district!;
                                  log("MY direct ${directorateController.selectedDirectorateId.value}");
                                  log("MY district ${districtController.selectedDistrictId.value}");
                                  log("MY Institution ${institutionController.institutionIdPayload}");
                                  await institutionController
                                      .getInstitutionListData(
                                          districtId: districtController
                                              .selectedDistrictId.value,
                                          directorateId: directorateController
                                              .selectedDirectorateId.value);
                                  await controller.getKPIDashboard(
                                    startDate: controller.StartDate.toString(),
                                    endDate: controller.EndDate.toString(),
                                    reportType: controller.selectedPillar.value,
                                    institutionId: institutionController
                                        .institutionIdPayload,
                                    districtId: districtController
                                        .selectedDistrictId.value,
                                    directorateId: directorateController
                                        .selectedDirectorateId.value,
                                  );
                                },
                              )
                            : SizedBox(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: DashBoardCommonDateRangePicker(
                                startDate: controller.StartDate.value,
                                endDate: controller.EndDate.value,
                                onApply: () async {
                                  controller.isLoading(true);
                                  await controller.getKPIDashboard(
                                    startDate: controller.StartDate.toString(),
                                    endDate: controller.EndDate.toString(),
                                    reportType: controller.selectedPillar.value,
                                    institutionId: institutionController
                                        .institutionIdPayload,
                                    districtId: districtController
                                        .selectedDistrictId.value,
                                    directorateId: directorateController
                                        .selectedDirectorateId.value,
                                  );
                                  controller.isLoading(false);
                                },
                                onDateSelected: (start, end) {
                                  log("Test Start Date: ${start.toString()}");
                                  log("Test End Date: ${end.toString()}");
                                  controller.StartDate.value = start;
                                  controller.EndDate.value = end;
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
                                    await controller.getKPIDashboard(
                                      startDate: DateFormat('yyyy-MM-dd')
                                          .format(DateTime.now()),
                                      endDate: DateFormat('yyyy-MM-dd')
                                          .format(DateTime.now()),
                                      reportType:
                                          controller.selectedPillar.value,
                                      institutionId: institutionController
                                          .institutionIdPayload,
                                      districtId: districtController
                                          .selectedDistrictId.value,
                                      directorateId: directorateController
                                          .selectedDirectorateId.value,
                                    );
                                  }),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        KpiPillarChipSelector(
                          selectedPillar: controller.selectedPillar,
                          onChanged: (value) async {
                            controller.selectedPillar.value = value;
                            await controller.getKPIDashboard(
                              startDate: controller.StartDate.toString(),
                              endDate: controller.EndDate.toString(),
                              reportType: controller.selectedPillar.value,
                              institutionId:
                                  institutionController.institutionIdPayload,
                              districtId:
                                  districtController.selectedDistrictId.value,
                              directorateId: directorateController
                                  .selectedDirectorateId.value,
                            );
                          },
                        )
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        loginController.isAdmin == true
                            ? DistrictListSearchDropdown(
                                title: 'District OO',
                                hint: 'Select District',
                                items: districtController.districtList.toList(),
                                selectedId: int.parse(districtController
                                    .selectedDistrictId.value),
                                onChanged: (district) async {
                                  districtController.selectedDistrictId.value =
                                      district!.toString();

                                  await institutionController
                                      .getInstitutionListData(
                                    districtId: districtController
                                        .selectedDistrictId.value,
                                  );
                                  directorateController
                                      .getDirectorateListData();
                                  directorateController
                                      .selectedDirectorateId.value = 0;
                                  institutionController.selectedInstitutionIds
                                      .clear();
                                  await controller.getKPIDashboard(
                                    startDate: controller.StartDate.toString(),
                                    endDate: controller.EndDate.toString(),
                                    reportType: controller.selectedPillar.value,
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
                                  await controller.getKPIDashboard(
                                    startDate: controller.StartDate.toString(),
                                    endDate: controller.EndDate.toString(),
                                    reportType: controller.selectedPillar.value,
                                    institutionId: institutionController
                                        .institutionIdPayload,
                                    districtId: districtController
                                        .selectedDistrictId.value,
                                    directorateId: directorateController
                                        .selectedDirectorateId.value,
                                  );
                                },
                              )
                            : SizedBox(),
                        Space(
                          height: 10,
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
                              institutionController
                                  .selectedInstitutionIds.value = value!;
                              await controller.getKPIDashboard(
                                startDate: DateFormat('yyyy-MM-dd')
                                    .format(DateTime.now()),
                                endDate: DateFormat('yyyy-MM-dd')
                                    .format(DateTime.now()),
                                reportType: controller.selectedPillar.value,
                                institutionId:
                                    institutionController.institutionIdPayload,
                                districtId:
                                    districtController.selectedDistrictId.value,
                                directorateId: directorateController
                                    .selectedDirectorateId.value,
                              );
                            }),
                        DashBoardCommonDateRangePicker(
                          startDate: controller.StartDate.value,
                          endDate: controller.EndDate.value,
                          onApply: () async {
                            controller.isLoading(true);
                            await controller.getKPIDashboard(
                              startDate: controller.StartDate.toString(),
                              endDate: controller.EndDate.toString(),
                              reportType: controller.selectedPillar.value,
                              institutionId:
                                  institutionController.institutionIdPayload,
                              districtId:
                                  districtController.selectedDistrictId.value,
                              directorateId: directorateController
                                  .selectedDirectorateId.value,
                            );
                            controller.isLoading(false);
                          },
                          onDateSelected: (start, end) {
                            log("Test Start Date: ${start.toString()}");
                            log("Test End Date: ${end.toString()}");
                            controller.StartDate.value = start;
                            controller.EndDate.value = end;
                          },
                        ),
                        Space(
                          height: 20,
                        ),
                        KpiPillarChipSelector(
                          selectedPillar: controller.selectedPillar,
                          onChanged: (value) {
                            controller.selectedPillar.value = value;
                          },
                        ),
                      ],
                    ),
              // const SizedBox(height: 20),
              Expanded(
                child: Obx(() {
                  if (controller.selectedPillar.value == 3) {
                    return TraumaDashboard().animate().fadeIn(duration: 400.ms);
                  } else if (controller.selectedPillar.value == 4) {
                    return BurnsDashboardUi()
                        .animate()
                        .fadeIn(duration: 400.ms);
                  } else if (controller.selectedPillar.value == 5) {
                    return PoisoningKpiDashboardPage()
                        .animate()
                        .fadeIn(duration: 400.ms);
                  } else if (controller.selectedPillar.value == 8) {
                    return StrokeDashboard().animate().fadeIn(duration: 400.ms);
                  } else if (controller.selectedPillar.value == 9) {
                    return PremDashboard().animate().fadeIn(duration: 400.ms);
                  } else if (controller.selectedPillar.value == 10) {
                    return StemiDashboardUi()
                        .animate()
                        .fadeIn(duration: 400.ms);
                  } else if (controller.selectedPillar.value == 0) {
                    return TaeiDashboardPage()
                        .animate()
                        .fadeIn(duration: 400.ms);
                  } else {
                    return Center(
                      child: Text(
                        "Select a pillar to view dashboard",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: context.isDesktop ? 18 : 14,
                        ),
                      ),
                    );
                  }
                }),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class KpiPillarChipSelector extends StatelessWidget {
  final RxInt selectedPillar;
  final Function(int) onChanged;

  KpiPillarChipSelector({
    super.key,
    required this.selectedPillar,
    required this.onChanged,
  });

  final List<Map<String, dynamic>> pillars = const [
    {"id": 0, "name": "taei", "icon": Icons.home_sharp},
    {"id": 3, "name": "Trauma", "icon": Icons.health_and_safety},
    {"id": 4, "name": "Burns", "icon": Icons.local_fire_department},
    {"id": 5, "name": "Poisoning", "icon": Icons.science_outlined},
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
