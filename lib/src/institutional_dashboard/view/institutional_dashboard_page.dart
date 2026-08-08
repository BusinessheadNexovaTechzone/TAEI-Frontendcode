import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/src/directorate/controller/directorate_controller.dart';
import 'package:taei_gov/src/district/controller/district_controller.dart';
import 'package:taei_gov/src/institutional/controller/institutional_controller.dart';
import 'package:taei_gov/src/institutional_dashboard/controller/institutional_dashboard_controller.dart';
import 'package:taei_gov/src/institutional_dashboard/view/In_hospital_institutional_dashboard_page.dart';
import 'package:taei_gov/src/institutional_dashboard/view/burns_institutional_dashboard_page.dart';
import 'package:taei_gov/src/institutional_dashboard/view/poisoning_institutional_dashboard_page.dart';
import 'package:taei_gov/src/institutional_dashboard/view/pre_hospital_institutional_dashboard_page.dart';
import 'package:taei_gov/src/institutional_dashboard/view/prem_institutional_dashboard_page.dart';
import 'package:taei_gov/src/institutional_dashboard/view/script_institutional_dashboard_page.dart';
import 'package:taei_gov/src/institutional_dashboard/view/stemi_institutional_dashboard_page.dart';
import 'package:taei_gov/src/institutional_dashboard/view/trauma_institutional_dashboard_page.dart';
import 'package:taei_gov/src/login/controller/login_controller.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/utils/common/DistrictListSearchDropdown.dart';
import 'package:taei_gov/utils/common/appbar.dart';
import 'package:taei_gov/utils/common/common_drop_down.dart';
import 'package:taei_gov/utils/common/hospital_dropdown.dart';
import 'package:taei_gov/utils/common/start_end_date_picker.dart';

import '../../../utils/helpers/space.dart';

class InstitutionalDashboardPage extends StatefulWidget {
  final bool from;

  const InstitutionalDashboardPage({Key? key, this.from = false})
      : super(key: key);

  @override
  State<InstitutionalDashboardPage> createState() =>
      _InstitutionalDashboardPageState();
}

class _InstitutionalDashboardPageState
    extends State<InstitutionalDashboardPage> {
  final LoginController loginController = Get.find();
  final InstitutionalDashboardController controller =
      Get.put(InstitutionalDashboardController());
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
      await await controller.getInstitutionalDashboard(
        startDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        endDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        reportType: controller.selectedPillar.value,
        institutionId: institutionController.institutionIdPayload,
        districtId: districtController.selectedDistrictId.value,
        directorateId: directorateController.selectedDirectorateId.value,
      );
    });
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
        if (institutionController.isLoading.value == true) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.isDesktop ? 40 : 0,
            vertical: context.isDesktop ? 24 : 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // StylishPillarDropdown(
              //   selectedPillar: controller.selectedPillar,
              //   onChanged: (value) {
              //     controller.selectedPillar.value = value;
              //   },
              // ),
              !context.isDesktop
                  ? Column(
                      children: [
                        /*HospitalDropdown(
                            selectedId:
                                institutionController.institutionId.value,
                            items: institutionController.institutionList
                                    .map((e) => {
                                          "hospitalid": int.tryParse(
                                              e.hospitalId.toString() ?? ''),
                                          "hospitalname": e.hospitalName ?? "",
                                        })
                                    .toList() ??
                                [],
                            onChanged: (value) async {
                              await institutionController
                                  .getInstitutionListData();
                              institutionController.institutionId.value =
                                  value!;
                              final today = DateTime.now();
                              final normalizedToday =
                                  DateTime(today.year, today.month, today.day);

                              controller.StartDate.value = normalizedToday;
                              controller.EndDate.value = normalizedToday;
                              await controller.getInstitutionalDashboard(
                                startDate: DateFormat('yyyy-MM-dd')
                                    .format(normalizedToday),
                                endDate: DateFormat('yyyy-MM-dd')
                                    .format(normalizedToday),
                                reportType: controller.selectedPillar.value,
                                institutionId:
                                    institutionController.institutionIdPayload,
                              );
                              log("Test Institution Id i: ${institutionController.institutionId.value.toString()}");
                            }),*/
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
                                  await controller.getInstitutionalDashboard(
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
                                  await controller.getInstitutionalDashboard(
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
                        Obx(
                          () => DashBoardCommonDateRangePicker(
                            key: ValueKey(
                              "${controller.StartDate.value}-${controller.EndDate.value}",
                            ),
                            startDate: controller.StartDate.value,
                            endDate: controller.EndDate.value,
                            onApply: () async {
                              await controller.getInstitutionalDashboard(
                                startDate:
                                    controller.StartDate.value.toString(),
                                endDate: controller.EndDate.value.toString(),
                                reportType: controller.selectedPillar.value,
                                institutionId:
                                    institutionController.institutionIdPayload,
                                districtId:
                                    districtController.selectedDistrictId.value,
                                directorateId: directorateController
                                    .selectedDirectorateId.value,
                              );
                            },
                            onDateSelected: (start, end) {
                              controller.StartDate.value = start;
                              controller.EndDate.value = end;
                            },
                          ),
                        ),
                        Space(
                          height: 10,
                        ),
                        PillarChipSelector(
                          selectedPillar: controller.selectedPillar,
                          onChanged: (value) async {
                            controller.selectedPillar.value = value;
                            await controller.getInstitutionalDashboard(
                              startDate: controller.StartDate.value.toString(),
                              endDate: controller.EndDate.value.toString(),
                              reportType: controller.selectedPillar.value,
                              institutionId:
                                  institutionController.institutionIdPayload,
                              districtId:
                                  districtController.selectedDistrictId.value,
                              directorateId: directorateController
                                  .selectedDirectorateId.value,
                            );
                          },
                        ),
                        Space(
                          height: 10,
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        /////
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
                                        await controller
                                            .getInstitutionalDashboard(
                                          startDate: controller.StartDate.value
                                              .toString(),
                                          endDate: controller.EndDate.value
                                              .toString(),
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
                                        await controller
                                            .getInstitutionalDashboard(
                                          startDate: controller.StartDate.value
                                              .toString(),
                                          endDate: controller.EndDate.value
                                              .toString(),
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
                                  await controller.getInstitutionalDashboard(
                                    startDate:
                                        controller.StartDate.value.toString(),
                                    endDate:
                                        controller.EndDate.value.toString(),
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
                          height: 16,
                        ),
                        MultipleHospitalSelectDropdown(
                            selectedIds:
                                institutionController.selectedInstitutionIds,
                            items: institutionController.institutionList
                                .map((e) => {
                                      "hospitalid":
                                          int.tryParse(e.hospitalId.toString()),
                                      "hospitalname": e.hospitalName ?? "",
                                    })
                                .toList(),
                            onChanged: (value) async {
                              institutionController
                                  .selectedInstitutionIds.value = value;
                              final today = DateTime.now();
                              final normalizedToday =
                                  DateTime(today.year, today.month, today.day);

                              controller.StartDate.value = normalizedToday;
                              controller.EndDate.value = normalizedToday;
                              await controller.getInstitutionalDashboard(
                                startDate:
                                    controller.StartDate.value.toString(),
                                endDate: controller.EndDate.value.toString(),
                                reportType: controller.selectedPillar.value,
                                institutionId:
                                    institutionController.institutionIdPayload,
                                districtId:
                                    districtController.selectedDistrictId.value,
                                directorateId: directorateController
                                    .selectedDirectorateId.value,
                              );
                              // await institutionController
                              //     .getInstitutionListData();
                              log("Test Institution Id i: ${institutionController.institutionId.value.toString()}");
                              log("Test New Institution Id i: ${institutionController.institutionIdPayload.toString()}");
                            }),
                        ////

                        Row(
                          children: [
                            Expanded(
                              child: DashBoardCommonDateRangePicker(
                                startDate: controller.StartDate.value,
                                endDate: controller.EndDate.value,
                                onApply: () async {
                                  await controller.getInstitutionalDashboard(
                                    startDate:
                                        controller.StartDate.value.toString(),
                                    endDate:
                                        controller.EndDate.value.toString(),
                                    reportType: controller.selectedPillar.value,
                                    institutionId: institutionController
                                        .institutionIdPayload,
                                    districtId: districtController
                                        .selectedDistrictId.value,
                                    directorateId: directorateController
                                        .selectedDirectorateId.value,
                                  );
                                },
                                onDateSelected: (start, end) {
                                  controller.StartDate.value = start;
                                  controller.EndDate.value = end;
                                },
                              ),
                            ),
                            Space(
                              height: 10,
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
                                    institutionController
                                        .selectedInstitutionIds.value = value!;
                                    final today = DateTime.now();
                                    final normalizedToday = DateTime(
                                        today.year, today.month, today.day);

                                    controller.StartDate.value =
                                        normalizedToday;
                                    controller.EndDate.value = normalizedToday;
                                    await controller.getInstitutionalDashboard(
                                      startDate:
                                          controller.StartDate.value.toString(),
                                      endDate:
                                          controller.EndDate.value.toString(),
                                      reportType:
                                          controller.selectedPillar.value,
                                      institutionId: institutionController
                                          .institutionIdPayload,
                                      districtId: districtController
                                          .selectedDistrictId.value,
                                      directorateId: directorateController
                                          .selectedDirectorateId.value,
                                    );
                                    // await institutionController
                                    //     .getInstitutionListData();
                                    log("Test Institution Id i: ${institutionController.institutionId.value.toString()}");
                                    log("Test New Institution Id i: ${institutionController.institutionIdPayload.toString()}");
                                  }),
                            ),
                          ],
                        ),
                        Space(
                          height: 10,
                        ),
                        PillarChipSelector(
                          selectedPillar: controller.selectedPillar,
                          onChanged: (value) async {
                            controller.selectedPillar.value = value;
                            await controller.getInstitutionalDashboard(
                              startDate: controller.StartDate.value.toString(),
                              endDate: controller.EndDate.value.toString(),
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
                    ),
              // --- Conditional content section ---
              Expanded(
                child: Obx(() {
                  if (controller.selectedPillar.value == 20) {
                    return PreHospitalInstitutionalDashboardPage();
                  } else if (controller.selectedPillar.value == 21) {
                    return InHospitalInstitutionalDashboardPage();
                  }
                  if (controller.selectedPillar.value == 3) {
                    return TraumaInstitutionalDashboardPage();
                  } else if (controller.selectedPillar.value == 4) {
                    return BurnsInstitutionalDashboardPage();
                  } else if (controller.selectedPillar.value == 5) {
                    return PoisoningInstitutionalDashboardPage();
                  } else if (controller.selectedPillar.value == 8) {
                    return ScriptInstitutionalDashboardPage();
                  } else if (controller.selectedPillar.value == 9) {
                    return PremInstitutionalDashboardPage();
                  } else if (controller.selectedPillar.value == 10) {
                    return STEMIInstitutionalDashboardPage();
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

class PillarChipSelector extends StatelessWidget {
  final RxInt selectedPillar;
  final Function(int) onChanged;

  PillarChipSelector({
    super.key,
    required this.selectedPillar,
    required this.onChanged,
  });

  final List<Map<String, dynamic>> pillars = const [
    {"id": 20, "name": "Pre-Hospital", "icon": Icons.local_hospital},
    {"id": 21, "name": "In-Hospital", "icon": Icons.local_hospital},
    {"id": 3, "name": "Trauma", "icon": Icons.health_and_safety},
    {"id": 4, "name": "Burns", "icon": Icons.local_fire_department},
    {"id": 5, "name": "Poisoning", "icon": Icons.science_outlined},
    {"id": 8, "name": "Stroke", "icon": Icons.bloodtype_outlined},
    {"id": 9, "name": "Prem", "icon": Icons.child_friendly},
    {"id": 10, "name": "STEMI", "icon": Icons.monitor_heart},
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

/*class PillarGlassChips extends StatelessWidget {
  final RxInt selectedPillar;
  final Function(int) onChanged;

  PillarGlassChips({
    required this.selectedPillar,
    required this.onChanged,
  });

  final pillars = const [
    {"id": 3, "name": "Trauma", "icon": Icons.health_and_safety},
    {"id": 4, "name": "Burns", "icon": Icons.local_fire_department},
    {"id": 5, "name": "Poisoning", "icon": Icons.science_outlined},
    {"id": 8, "name": "Stroke", "icon": Icons.bloodtype},
    {"id": 9, "name": "Prem", "icon": Icons.child_friendly},
    {"id": 10, "name": "Stemi", "icon": Icons.monitor_heart},
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SizedBox(
        height: 60,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: pillars.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (_, index) {
            final p = pillars[index];
            final isSelected = selectedPillar.value == p["id"];

            return GestureDetector(
              onTap: () => onChanged(p["id"] as int),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected ? Colors.blueAccent : Colors.white60,
                    width: 2,
                  ),
                  color: Colors.white.withOpacity(0.2),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.25),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(p["icon"] as IconData,
                        size: 22,
                        color: isSelected ? Colors.blueAccent : Colors.black87),
                    const SizedBox(width: 10),
                    Text(
                      p["name"] as String,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.blueAccent : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}

////////// Stylish Pillar Dropdown /////////////////
class StylishPillarDropdown extends StatelessWidget {
  final RxInt selectedPillar;
  final Function(int) onChanged;

  const StylishPillarDropdown({
    super.key,
    required this.selectedPillar,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(() {
        return GestureDetector(
          onTapDown: (details) =>
              _showDropdownMenu(context, details.globalPosition),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.blueAccent.withOpacity(0.4),
                width: 1.4,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.1),
                  blurRadius: 15,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.category_rounded,
                  color: Colors.blueAccent.shade400,
                  size: 26,
                ),
                const SizedBox(width: 12),
                Text(
                  _getPillarName(selectedPillar.value),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: selectedPillar.value == 0
                        ? Colors.black38
                        : Colors.black87,
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.blueAccent,
                  size: 28,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void _showDropdownMenu(BuildContext context, Offset offset) {
    final pillars = [
      {"id": 3, "name": "Trauma", "icon": Icons.health_and_safety},
      {"id": 4, "name": "Burns", "icon": Icons.local_fire_department},
      {"id": 5, "name": "Poisoning", "icon": Icons.science_outlined},
      {"id": 8, "name": "Stroke", "icon": Icons.bloodtype},
      {"id": 9, "name": "Prem", "icon": Icons.child_friendly},
      {"id": 10, "name": "Stemi", "icon": Icons.monitor_heart},
    ];

    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => Positioned(
        left: offset.dx - 100,
        top: offset.dy + 10,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 230,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.blueAccent.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
              // backdropFilter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: pillars.length,
              itemBuilder: (context, index) {
                final pillar = pillars[index];
                final isSelected = selectedPillar.value == pillar["id"];

                return InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    onChanged(pillar["id"] as int);
                    entry.remove();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.blueAccent.withOpacity(0.08)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          pillar["icon"] as IconData,
                          color:
                              isSelected ? Colors.blueAccent : Colors.black54,
                          size: 22,
                        ),
                        const SizedBox(width: 14),
                        Text(
                          pillar["name"] as String,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                            color:
                                isSelected ? Colors.blueAccent : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
  }

  String _getPillarName(int id) {
    switch (id) {
      case 3:
        return "Trauma";
      case 4:
        return "Burns";
      case 5:
        return "Poisoning";
      case 8:
        return "Stroke";
      case 9:
        return "Prem";
      case 10:
        return "Stemi";
      default:
        return "Select Pillar";
    }
  }
}*/
