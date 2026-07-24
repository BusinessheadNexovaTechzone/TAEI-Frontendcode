import 'dart:async';
import 'package:data_table_2/data_table_2.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/src/login/controller/login_controller.dart';
import 'package:taei_gov/src/nurse_triage/controller/nurse_triage_controller.dart';
import 'package:taei_gov/src/nurse_triage/views/add_accident.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:flutter/material.dart';
import 'package:taei_gov/utils/common/appbar.dart';
import 'package:taei_gov/utils/common/space.dart';
import 'package:taei_gov/utils/common/start_end_date_picker.dart';
import 'package:taei_gov/widgets/CommonSearchBar.dart';
import '../models/create_triage_model.dart';

class TriageCaseListPage extends StatefulWidget {
  final bool isFromHome;

  const TriageCaseListPage({super.key, this.isFromHome = false});

  @override
  State<TriageCaseListPage> createState() => _TriageCaseListPageState();
}

class _TriageCaseListPageState extends State<TriageCaseListPage> {
  final NurseTriageController controller = Get.put(NurseTriageController());
  LoginController loginController = Get.find();
  bool _blink = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getTriage108CaseList(
        hospitalName: loginController
                .userDetails.value?.user?.hospital?.hospitalname108
                .toString() ??
            '',
        startDate: DateFormat('MM/dd/yyyy').format(DateTime.now()),
        endDate: DateFormat('MM/dd/yyyy').format(DateTime.now()),
        pageNumber: 1,
        pageSize: 20,
      );
      controller.fetchDashboard(
          startDate: DateFormat('yyyy-MM-dd 00:00:00').format(DateTime.now()),
          endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()));
    });
  }

  // show 10 per page

  Color? getRowColor(int? statusid) {
    if (statusid == null) return null;

    if (!_blink) return Colors.white; // blink to white

    switch (statusid) {
      case 1:
        return Colors.red[100];
      case 2:
        return Colors.orange[100];
      case 3:
        return Colors.green[100];
      default:
        return null;
    }
  }

  final List<List<Color>> gradients = [
    [Colors.blue, Colors.blueAccent],
    [Colors.green, Colors.lightGreen],
    [Colors.red, Colors.orange],
    [Colors.purple, Colors.deepPurple],
    [Colors.teal, Colors.cyan],
    [Colors.pink, Colors.pinkAccent],
    [Colors.indigo, Colors.blueGrey],
  ];

  @override
  Widget build(BuildContext context) {
    debugPrint("ED Line List: ${controller.triage108CaseList.length}");

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: widget.isFromHome
            ? null
            : CommonAppBar(title: "Triage 108 Line List"),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: context.isDesktop
                ? EdgeInsets.only(right: 20.0, left: 20, top: 10, bottom: 10)
                : EdgeInsets.all(8.0),
            child: Column(
              children: [
                CommonDateRangePicker(
                  startDate: controller.startDate.value,
                  endDate: controller.endDate.value,
                  onApply: () async {
                    controller.isLoading(true);
                    await controller.getTriage108CaseList(
                      hospitalName: loginController.userDetails.value?.user
                              ?.hospital?.hospitalname108
                              .toString() ??
                          '',
                      startDate: controller.transitStartDate.value,
                      endDate: controller.transitEndDate.value,
                    );
                    await controller.fetchDashboard(
                      startDate: controller.startDate.toString(),
                      endDate: controller.endDate.toString(),
                    );
                    controller.isLoading(false);
                  },
                  onDateSelected: (start, end) {
                    controller.startDate.value = start;
                    controller.endDate.value = end;
                    controller.transitStartDate.value =
                        DateFormat('MM/dd/yyyy').format(start);
                    controller.transitEndDate.value =
                        DateFormat('MM/dd/yyyy').format(end);
                    //////////////////////////////////////////////
                    // transitController.transitStartDate.value =
                    //     DateFormat('MM/dd/yyyy').format(start);
                    // transitController.transitEndDate.value =
                    //     DateFormat('MM/dd/yyyy').format(end);
                    print('Start: ${controller.startDate.value}');
                    print('End:   ${controller.endDate.value}');
                    print('TransitStart: ${controller.transitStartDate.value}');
                    print('TransitEnd:   ${controller.transitEndDate.value}');
                  },
                ),
                Space(
                  height: 10,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GridView.builder(
                          shrinkWrap: true,
                          // 🔹 Makes it take only as much height as needed
                          physics: const NeverScrollableScrollPhysics(),
                          // 🔹 Prevents scroll conflict with main scroll
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: context.isDesktop ? 7 : 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: context.isDesktop ? 2 : 1.5,
                          ),
                          itemCount: controller.dataMap.length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 6,
                                    offset: Offset(2, 4),
                                  ),
                                ],
                                gradient: LinearGradient(
                                  colors: gradients[index % gradients.length],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      controller.dataMap.keys.elementAt(index),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      controller.dataMap.values
                                          .elementAt(index),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        Space(
                          height: 10,
                        ),
                        NewCommonSearchField(
                          initialValue: controller.searchText.value,
                          onChanged: (value) {
                            controller.searchText.value = value;
                          },
                        ),
                        Space(
                          height: 10,
                        ),
                        SizedBox(
                          height: 500,
                          child: Container(
                            // margin: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                )
                              ],
                            ),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: DataTable2(
                                  headingRowColor: MaterialStateProperty.all(
                                      Colors.blueGrey.shade50),
                                  headingRowHeight: 56,
                                  dataRowHeight: 56,
                                  columnSpacing: 20,
                                  horizontalMargin: 12,
                                  minWidth: 1200,
                                  // ensures horizontal scroll
                                  fixedTopRows: 1,
                                  // ✅ keeps header sticky
                                  border: TableBorder.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  columns: const [
                                    DataColumn2(
                                        size: ColumnSize.S,
                                        label: Text("S.No.",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    DataColumn2(
                                        size: ColumnSize.L,
                                        label: Text("Case ID",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    DataColumn2(
                                        size: ColumnSize.L,
                                        label: Text("Patient Name",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    DataColumn2(
                                        size: ColumnSize.L,
                                        label: Text("Create / Entry",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    DataColumn2(
                                        size: ColumnSize.L,
                                        label: Text("District Name",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    DataColumn2(
                                        size: ColumnSize.L,
                                        label: Text("Base Location",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    DataColumn2(
                                        size: ColumnSize.L,
                                        label: Text("Vehicle No.",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    DataColumn2(
                                        size: ColumnSize.L,
                                        label: Text("CallType",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    DataColumn2(
                                        size: ColumnSize.L,
                                        label: Text("Chief Complaint",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    DataColumn2(
                                        size: ColumnSize.L,
                                        label: Text("Source Hospital",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    DataColumn2(
                                        size: ColumnSize.L,
                                        label: Text("Hospital Name",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                  ],
                                  rows: controller.filteredTriage108CaseList
                                      .map((caseListData) {
                                    return DataRow(
                                      // color: MaterialStateProperty.all(
                                      //   getRowColor(int.tryParse(transitCare
                                      //           .isCritical
                                      //           .toString()) ??
                                      //       0),
                                      // ),
                                      // color: MaterialStateProperty.all(Colors.white),
                                      color: MaterialStateProperty.all(
                                          caseListData.triageId != null
                                              ? Colors.green
                                              : Colors.white),
                                      // //color: MaterialStateProperty ,
                                      cells: [
                                        DataCell(
                                          Text(
                                            (((controller.mycurrentPage.value -
                                                            1) *
                                                        controller.rowsPerPage
                                                            .value) +
                                                    (controller
                                                            .triage108CaseList
                                                            .indexOf(
                                                                caseListData) +
                                                        1))
                                                .toString(),
                                          ),
                                        ),
                                        // DataCell(
                                        //   Text(
                                        //     (((controller.mycurrentPage.value -
                                        //                     1) *
                                        //                 controller.rowsPerPage
                                        //                     .value) +
                                        //             (controller
                                        //                     .triage108CaseList
                                        //                     .indexOf(
                                        //                         caseListData) +
                                        //                 1))
                                        //         .toString(),
                                        //   ),
                                        // ),
                                        DataCell(Text(
                                            caseListData.caseId.toString(),
                                            overflow: TextOverflow.ellipsis)),
                                        DataCell(Text(
                                            caseListData.patientName ?? "-",
                                            overflow: TextOverflow.ellipsis)),
                                        DataCell(Center(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              if (caseListData.triageId ==
                                                  null) {
                                                controller.createTriageModel(
                                                    TriageModel(
                                                        triage: Triage(),
                                                        triageBy108:
                                                            TriageBy108(),
                                                        triageDtls:
                                                            TriageDtls()));
                                                final triage108 = controller
                                                        .createTriageModel
                                                        .value
                                                        ?.triageBy108 ??
                                                    TriageBy108();
                                                final triage = controller
                                                        .createTriageModel
                                                        .value
                                                        ?.triage ??
                                                    Triage();

                                                triage.nameOfPatient =
                                                    caseListData.patientName;
                                                triage.ageYear =
                                                    caseListData.age;

                                                triage108.callId = caseListData
                                                    .caseId
                                                    ?.toString();
                                                triage108.districtName =
                                                    caseListData.districtName;
                                                triage108.taluk =
                                                    caseListData.talukName;
                                                triage108.cityName =
                                                    caseListData.cityName;
                                                triage108.baseLocation =
                                                    caseListData.baseLocation;
                                                triage108.vehicleNumber =
                                                    caseListData.vehicleNumber;
                                                triage108
                                                        .vehicleAssignedDateTime =
                                                    caseListData
                                                        .vehicleAssignedTime
                                                        .toString();
                                                triage108.chiefComplaint =
                                                    caseListData.chiefComplaint;
                                                triage108.emergencyType =
                                                    caseListData.emergencyType;
                                                triage108.emergencySubType =
                                                    caseListData
                                                        .emergencySubType;
                                                triage108.temperature =
                                                    caseListData.temperature
                                                        .toString();
                                                triage108.pulse = caseListData
                                                    .spo2
                                                    .toString();
                                                triage108.rr =
                                                    caseListData.rr.toString();
                                                triage108.bpSbp = caseListData
                                                    .bpSbp
                                                    .toString();
                                                triage108.bpDbp = caseListData
                                                    .bpDbp
                                                    .toString();

                                                triage108.pupilLeft =
                                                    caseListData.pupilSizeLeft;
                                                triage108.pupilRight =
                                                    caseListData.pupilSizeRight;
                                                triage108.loc =
                                                    caseListData.loc;
                                                triage108.conditionOfPatient =
                                                    caseListData.isCritical == 1
                                                        ? "Critical"
                                                        : "Normal";
                                                controller.createTriageModel
                                                    .value?.triage = triage;
                                                controller
                                                    .createTriageModel
                                                    .value
                                                    ?.triageBy108 = triage108;
                                                controller.currentIndex.value =
                                                    0;
                                                Get.to(AddAccident(
                                                  is108: true,
                                                  id: caseListData.caseId
                                                      .toString(),
                                                  isUpdate: false,
                                                  triageBy108: triage108,
                                                ));

                                                print(
                                                    "TEST 1081${controller.createTriageModel.value?.triageBy108?.rr}");
                                              } else {
                                                controller.currentIndex.value =
                                                    0;
                                                Get.to(AddAccident(
                                                  id: caseListData.triageId
                                                      .toString(),
                                                  isUpdate: true,
                                                ));
                                              }
                                            },
                                            child: caseListData.triageId == null
                                                ? Text('Triage')
                                                : Icon(Icons.edit),
                                          ),
                                        )),
                                        DataCell(Text(
                                            caseListData.districtName ?? "-",
                                            overflow: TextOverflow.ellipsis)),
                                        DataCell(Text(
                                            caseListData.baseLocation ?? "-",
                                            overflow: TextOverflow.ellipsis)),
                                        DataCell(Text(
                                            caseListData.vehicleNumber ?? "-",
                                            overflow: TextOverflow.ellipsis)),
                                        DataCell(Text(
                                            caseListData.callType ?? "-",
                                            overflow: TextOverflow.ellipsis)),
                                        DataCell(Text(
                                            caseListData.chiefComplaint ?? "-",
                                            overflow: TextOverflow.ellipsis)),
                                        DataCell(Text(
                                            caseListData.sourceHospital ?? "-",
                                            overflow: TextOverflow.ellipsis)),
                                        DataCell(Text(
                                            caseListData.hospitalName ?? "-",
                                            overflow: TextOverflow.ellipsis)),
                                      ],
                                    );
                                  }).toList(),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: controller.mycurrentPage.value > 1
                              ? () async {
                                  await controller.getTriage108CaseList(
                                    hospitalName: loginController
                                            .userDetails
                                            .value
                                            ?.user
                                            ?.hospital
                                            ?.hospitalname108
                                            .toString() ??
                                        '',
                                    startDate: controller.transitStartDate.value
                                        .toString(),
                                    endDate: controller.transitEndDate.value
                                        .toString(),
                                    pageNumber:
                                        controller.mycurrentPage.value - 1,
                                    pageSize: controller.rowsPerPage.value,
                                  );
                                  controller.fetchTriageDashboard(
                                      startDate:
                                          controller.transitStartDate.value,
                                      endDate: controller.transitEndDate.value);
                                }
                              : null,
                        ),
                        Text(
                          'Page ${controller.mycurrentPage.value} of ${controller.mytotalPages.value}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: controller.mycurrentPage.value <
                                  controller.mytotalPages.value
                              ? () async {
                                  await controller.getTriage108CaseList(
                                    hospitalName: loginController
                                            .userDetails
                                            .value
                                            ?.user
                                            ?.hospital
                                            ?.hospitalname108
                                            .toString() ??
                                        '',
                                    startDate:
                                        controller.transitStartDate.toString(),
                                    endDate:
                                        controller.transitEndDate.toString(),
                                    pageNumber:
                                        controller.mycurrentPage.value + 1,
                                    pageSize: controller.rowsPerPage.value,
                                  );
                                  controller.fetchTriageDashboard(
                                      startDate:
                                          controller.transitStartDate.value,
                                      endDate: controller.transitEndDate.value);
                                }
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
