import 'dart:async';
import 'package:data_table_2/data_table_2.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/src/hospital/controller/hospital_controller.dart';
import 'package:taei_gov/src/institutional/controller/institutional_controller.dart';
import 'package:taei_gov/src/login/controller/login_controller.dart';
import 'package:taei_gov/src/nurse_triage/controller/nurse_triage_controller.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/src/transit_care/controller/transit_care_controller.dart';
import 'package:flutter/material.dart';
import 'package:taei_gov/src/transit_care/view/transit_care_details_page.dart';
import 'package:taei_gov/utils/common/appbar.dart';
import 'package:taei_gov/utils/common/search_dropdown.dart';
import 'package:taei_gov/utils/common/space.dart';
import 'package:taei_gov/utils/common/start_end_date_picker.dart';

class StateTransitCarePage extends StatefulWidget {
  final bool isFromHome;

  const StateTransitCarePage({super.key, this.isFromHome = false});

  @override
  State<StateTransitCarePage> createState() => _StateTransitCarePageState();
}

class _StateTransitCarePageState extends State<StateTransitCarePage> {
  final NurseTriageController transitController =
      Get.put(NurseTriageController());
  LoginController loginController = Get.find();
  HospitalController hospitalController = Get.put(HospitalController());
  InstitutionalController institutionalController =
      Get.put(InstitutionalController());

  // final TransitCareController transitController =
  //     Get.put(TransitCareController());
  bool _blink = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Blink every 800ms
    WidgetsBinding.instance.addPostFrameCallback((_) {
      hospitalController.getHospitalListData();
      institutionalController.getInstitutionListData();
      transitController.getTriage108CaseList(
          hospitalName: loginController
                  .userDetails.value?.user?.hospital?.hospitalname108
                  .toString() ??
              institutionalController.selectedTransitCareHospital.value ??
              '',
          startDate: DateFormat('MM/dd/yyyy').format(DateTime.now()),
          endDate: DateFormat('MM/dd/yyyy').format(DateTime.now()),
          pageNumber: 1,
          pageSize: 20);
      transitController.fetchDashboard(
          startDate: DateFormat('yyyy-MM-dd 00:00:00').format(DateTime.now()),
          endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()));
    });

    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      setState(() {
        _blink = !_blink;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // show 10 per page

  Color? getRowColor(bool? statusid) {
    if (statusid == null) return null;
    if (!_blink) return Colors.white;
    if (statusid) {
      return Colors.red;
    }
    return Colors.white;
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
    return Scaffold(
      appBar:
          widget.isFromHome ? null : CommonAppBar(title: "Transit Care List"),
      body: Obx(() {
        if (transitController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Get only the visible page data

        return Padding(
          padding: context.isDesktop ? EdgeInsets.all(10) : EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonDateRangePicker(
                startDate: transitController.startDate.value,
                endDate: transitController.endDate.value,
                onApply: () async {
                  transitController.isLoading(true);
                  await transitController.getTriage108CaseList(
                    hospitalName: loginController
                            .userDetails.value?.user?.hospital?.hospitalname108
                            .toString() ??
                        '',
                    startDate: transitController.transitStartDate.value,
                    endDate: transitController.transitEndDate.value,
                  );
                  await transitController.fetchDashboard(
                    startDate: transitController.startDate.toString(),
                    endDate: transitController.endDate.toString(),
                  );
                  transitController.isLoading(false);
                },
                onDateSelected: (start, end) {
                  transitController.startDate.value = start;
                  transitController.endDate.value = end;
                  transitController.transitStartDate.value =
                      DateFormat('MM/dd/yyyy').format(start);
                  transitController.transitEndDate.value =
                      DateFormat('MM/dd/yyyy').format(end);
                  //////////////////////////////////////////////
                  // transitController.transitStartDate.value =
                  //     DateFormat('MM/dd/yyyy').format(start);
                  // transitController.transitEndDate.value =
                  //     DateFormat('MM/dd/yyyy').format(end);
                  print('Start: ${transitController.startDate.value}');
                  print('End:   ${transitController.endDate.value}');
                  print(
                      'TransitStart: ${transitController.transitStartDate.value}');
                  print(
                      'TransitEnd:   ${transitController.transitEndDate.value}');
                },
              ),
              Space(
                height: 30,
              ),
              SizedBox(
                width: 500,
                child: SearchableDropdown(
                  items: institutionalController.transitCareHospital108List,
                  label: "Select Hospital (108)",
                  onSelected: (value) async {
                    institutionalController.selectedTransitCareHospital.value =
                        value;
                    transitController.isLoading(true);
                    await transitController.getTriage108CaseList(
                      hospitalName: value,
                      startDate: transitController.transitStartDate.value,
                      endDate: transitController.transitEndDate.value,
                      pageNumber: 1,
                      pageSize: 20,
                    );
                    await transitController.fetchDashboard(
                      startDate: transitController.startDate.toString(),
                      endDate: transitController.endDate.toString(),
                    );
                    transitController.isLoading(false);
                  },
                  selectedValue:
                      institutionalController.selectedTransitCareHospital.value,
                ),
              ),

              Space(
                height: 30,
              ),

              /// --- Your GridView Section ---
              GridView.builder(
                shrinkWrap: true,
                // 🔹 Makes it take only as much height as needed
                physics: const NeverScrollableScrollPhysics(),
                // 🔹 Prevents scroll conflict with main scroll
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: context.isDesktop ? 7 : 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: context.isDesktop ? 2 : 1.5,
                ),
                itemCount: transitController.dataMap.length,
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
                            transitController.dataMap.keys.elementAt(index),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            transitController.dataMap.values.elementAt(index),
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
                height: 20,
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
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
                  child: Column(
                    children: [
                      /// Data Table
                      Expanded(
                        flex: 2,
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
                                  Colors.blueGrey.shade50,
                                ),
                                headingRowHeight: 56,
                                dataRowHeight: 56,
                                columnSpacing: 10,
                                horizontalMargin: 12,
                                minWidth: 1100,
                                fixedTopRows: 1,
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
                                      label: Text("View",
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
                                rows: transitController
                                    .filteredTriage108CaseList
                                    .map((transitCare) {
                                  return DataRow(
                                    color: MaterialStateProperty.all(
                                      transitCare.triageId == null
                                          ? getRowColor(transitCare.isCritical)
                                          : Colors.green,
                                    ),
                                    cells: [
                                      DataCell(
                                        Text(
                                          (((transitController.mycurrentPage
                                                              .value -
                                                          1) *
                                                      transitController
                                                          .rowsPerPage.value) +
                                                  (transitController
                                                          .triage108CaseList
                                                          .indexOf(
                                                              transitCare) +
                                                      1))
                                              .toString(),
                                        ),
                                      ),
                                      DataCell(Text(
                                          transitCare.caseId.toString(),
                                          overflow: TextOverflow.ellipsis)),
                                      DataCell(Text(
                                          transitCare.patientName ?? "-",
                                          overflow: TextOverflow.ellipsis)),
                                      DataCell(
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            Get.to(() => CaseDetailsViewPage(
                                                caseData: transitCare));
                                          },
                                          icon: const Icon(Icons.visibility,
                                              size: 18),
                                          label: const Text('View'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blueGrey,
                                            foregroundColor: Colors.white,
                                          ),
                                        ),
                                      ),
                                      DataCell(Text(
                                          transitCare.districtName ?? "-",
                                          overflow: TextOverflow.ellipsis)),
                                      DataCell(Text(
                                          transitCare.baseLocation ?? "-",
                                          overflow: TextOverflow.ellipsis)),
                                      DataCell(Text(
                                          transitCare.vehicleNumber ?? "-",
                                          overflow: TextOverflow.ellipsis)),
                                      DataCell(Text(transitCare.callType ?? "-",
                                          overflow: TextOverflow.ellipsis)),
                                      DataCell(Text(
                                          transitCare.chiefComplaint ?? "-",
                                          overflow: TextOverflow.ellipsis)),
                                      DataCell(Text(
                                          transitCare.sourceHospital ?? "-",
                                          overflow: TextOverflow.ellipsis)),
                                      DataCell(Text(
                                          transitCare.hospitalName ?? "-",
                                          overflow: TextOverflow.ellipsis)),
                                    ],
                                  );
                                }).toList(),
                              )),
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
                                onPressed:
                                    transitController.mycurrentPage.value > 1
                                        ? () async {
                                            await transitController
                                                .getTriage108CaseList(
                                              hospitalName: loginController
                                                      .userDetails
                                                      .value
                                                      ?.user
                                                      ?.hospital
                                                      ?.hospitalname108
                                                      .toString() ??
                                                  '',
                                              startDate: transitController
                                                  .transitStartDate.value,
                                              endDate: transitController
                                                  .transitEndDate.value,
                                              pageNumber: transitController
                                                      .mycurrentPage.value -
                                                  1,
                                              pageSize: transitController
                                                  .rowsPerPage.value,
                                            );
                                            transitController
                                                .fetchTriageDashboard(
                                                    startDate: transitController
                                                        .transitStartDate.value,
                                                    endDate: transitController
                                                        .transitEndDate.value);
                                          }
                                        : null,
                              ),
                              Text(
                                'Page ${transitController.mycurrentPage.value} of ${transitController.mytotalPages.value}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: const Icon(Icons.chevron_right),
                                onPressed: transitController
                                            .mycurrentPage.value <
                                        transitController.mytotalPages.value
                                    ? () async {
                                        await transitController
                                            .getTriage108CaseList(
                                          hospitalName: loginController
                                                  .userDetails
                                                  .value
                                                  ?.user
                                                  ?.hospital
                                                  ?.hospitalname108
                                                  .toString() ??
                                              '',
                                          startDate: transitController
                                              .transitStartDate.value,
                                          endDate: transitController
                                              .transitEndDate.value,
                                          pageNumber: transitController
                                                  .mycurrentPage.value +
                                              1,
                                          pageSize: transitController
                                              .rowsPerPage.value,
                                        );
                                        transitController.fetchTriageDashboard(
                                            startDate: transitController
                                                .transitStartDate.value,
                                            endDate: transitController
                                                .transitEndDate.value);
                                      }
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
