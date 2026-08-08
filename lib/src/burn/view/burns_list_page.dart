import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/src/burn/controller/burn_controller.dart';
import 'package:taei_gov/src/burn/models/create_burn_model.dart';
import 'package:taei_gov/src/burn/view/burn_form.dart';
import 'package:taei_gov/src/burn/view/burns_details_page.dart';
import 'package:taei_gov/src/emo_user/controller/emo_controller.dart';
import 'package:taei_gov/src/emo_user/model/emo_model.dart';
import 'package:taei_gov/src/emo_user/view/emo_form.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/src/stemi/form_page.dart';
import 'package:taei_gov/src/triage_emo_pillars_view/triage_emo_pillars_view_page.dart';
import 'package:taei_gov/utils/common/common_button.dart';
import 'package:taei_gov/utils/common/space.dart';
import 'package:taei_gov/utils/common/start_end_date_picker.dart';
import 'package:taei_gov/utils/common/table_common_button.dart';
import 'package:taei_gov/widgets/CommonSearchBar.dart';

class BurnListPage extends StatefulWidget {
  final bool appBar;

  const BurnListPage({super.key, this.appBar = true});

  @override
  State<BurnListPage> createState() => _BurnListPageState();
}

class _BurnListPageState extends State<BurnListPage> {
  BurnController burnController = Get.put(BurnController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      burnController.isLoading(true);
      await burnController.getBurnList(
        startDate: DateFormat('yyyy-MM-dd 00:00:00')
            .format(DateTime.now().subtract(Duration(days: 7))),
        endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
        dischargeStatus: "2",
      );
      await burnController.getBurnsDashboard(
        startDate: DateFormat('yyyy-MM-dd 00:00:00')
            .format(DateTime.now().subtract(Duration(days: 7))),
        endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
      );
      burnController.isLoading(false);
    });
  }

  final List<List<Color>> gradientColors = [
    [Colors.purple, Colors.deepPurpleAccent],
    [Colors.orange, Colors.deepOrangeAccent],
    [Colors.green, Colors.lightGreen],
    [Colors.blue, Colors.lightBlueAccent],
    [Colors.red, Colors.pinkAccent],
    [Colors.teal, Colors.cyan],
    [Colors.indigo, Colors.blueAccent],
  ];

  @override
  Widget build(BuildContext context) {
    if (burnController.burnCaseList.isNotEmpty) {
      // print('emoListData: ${burnController.burnCaseList.emoListData.first.memory}');
    } else {
      print('emoListData is empty');
    }
    return Scaffold(
        appBar: widget.appBar
            ? AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Get.back(),
                ),
                backgroundColor: Colors.redAccent,
                title: context.isDesktop
                    ? Center(child: Text('Burn'))
                    : Text('Burn'),
              )
            : null,
        body: Obx(
          () => burnController.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  padding: context.isDesktop
                      ? EdgeInsets.only(left: 30, right: 30, top: 8)
                      : EdgeInsets.all(10),
                  child: Column(
                    spacing: 15,
                    children: [
                      CommonDateRangePicker(
                        startDate: burnController.burnsStartDate.value,
                        endDate: burnController.burnsEndDate.value,
                        onApply: () async {
                          burnController.isLoading(true);
                          await burnController.getBurnList(
                            startDate: burnController.burnsStartDate.toString(),
                            endDate: burnController.burnsEndDate.toString(),
                            dischargeStatus: "2",
                          );
                          await burnController.getBurnsDashboard(
                            startDate: burnController.burnsStartDate.toString(),
                            endDate: burnController.burnsEndDate.toString(),
                          );
                          burnController.searchText.value = "";
                          burnController.isLoading(false);
                        },
                        onDateSelected: (start, end) {
                          burnController.burnsStartDate.value = start;
                          burnController.burnsEndDate.value = end;
                        },
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
                                  crossAxisSpacing: context.isDesktop ? 10 : 12,
                                  mainAxisSpacing: context.isDesktop ? 10 : 12,
                                  childAspectRatio:
                                      context.isDesktop ? 1.9 : 1.5,
                                ),
                                itemCount: burnController.burnsDataMap.length,
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
                                        colors: gradientColors[
                                            index % gradientColors.length],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            burnController.burnsDataMap.keys
                                                .elementAt(index),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            burnController.burnsDataMap.values
                                                .elementAt(index)
                                                .toString(),
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
                                initialValue: burnController.searchText.value,
                                onChanged: (value) {
                                  burnController.searchText.value = value;
                                  burnController.getBurnList(
                                    startDate: burnController.burnsStartDate
                                        .toString(),
                                    endDate:
                                        burnController.burnsEndDate.toString(),
                                    patientName:
                                        burnController.searchText.value,
                                    dischargeStatus: "2",
                                  );
                                },
                              ),
                              Space(
                                height: 10,
                              ),
                              Container(
                                width: double.infinity,
                                height: 500,
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
                                    minWidth: 1600,
                                    // ensures horizontal scroll
                                    fixedTopRows: 1,
                                    // ✅ keeps header sticky
                                    border: TableBorder.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    columns: const [
                                      DataColumn2(
                                          size: ColumnSize.S,
                                          label: Text("S.NO",
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn2(
                                          size: ColumnSize.L,
                                          label: Text("TAEI ID",
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn2(
                                          size: ColumnSize.L,
                                          label: Text("Patient Name",
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn2(
                                          size: ColumnSize.L,
                                          label: Text("Create",
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn2(
                                          label: Text("Mode of Arrival",
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn2(
                                          label: Text("Scene Or IFT",
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn2(
                                          label: Text("Emergency Category",
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn2(
                                          label: Text("Presenting Complaint",
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn2(
                                          label: Text("Source Hospital",
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn2(
                                          label: Text("Destination Hospital",
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn2(
                                          label: Text("Triage Flag",
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn2(
                                          label: Text("View",
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    ],

                                    rows: burnController.burnCaseList
                                        .map<DataRow>((emo) {
                                      // Row color based on statusid
                                      Color? rowColor;
                                      switch (emo.triageFlag) {
                                        case 'Red':
                                          rowColor = Colors.red;
                                          break;
                                        case 'Yellow':
                                          rowColor = Colors.yellow;
                                          break;
                                        case 'Green':
                                          rowColor = Colors.green;
                                          break;
                                        case 'Black':
                                          rowColor = Colors.grey.shade700;
                                          break;
                                        default:
                                          rowColor = null;
                                      }

                                      return DataRow(
                                        color:
                                            MaterialStateProperty.all(rowColor),
                                        cells: [
                                          DataCell(
                                            Text(
                                              (((burnController.burnsCurrentPage
                                                                  .value -
                                                              1) *
                                                          burnController
                                                              .burnsLimit) +
                                                      (burnController
                                                              .burnCaseList
                                                              .indexOf(emo) ??
                                                          0) +
                                                      1)
                                                  .toString(),
                                            ),
                                          ),
                                          DataCell(Text(
                                              emo.triageId?.toString() ?? "-")),
                                          DataCell(
                                              Text(emo.nameOfPatient ?? "-")),
                                          DataCell(TableCommonButton(
                                              compact: false,
                                              color: emo.burnsId != null
                                                  ? Colors.green.shade700
                                                  : Colors.redAccent.shade700,
                                              label: emo.burnsId != null
                                                  ? "Update"
                                                  : "Burns",
                                              icon: emo.burnsId != null
                                                  ? Icons.edit
                                                  : Icons.add_business_rounded,
                                              onTap: () {
                                                if (emo.burnsId == null) {
                                                  burnController
                                                      .burnFormData(BurnsModel(
                                                    burns: Burns(),
                                                    burnsOutcome:
                                                        BurnsOutcome(),
                                                    burnsValues: BurnsValues(),
                                                    burnsTbsa: BurnsTbsa(),
                                                    burnsSurgeryElective: [
                                                      BurnsSurgeryElective()
                                                    ],
                                                  ));
                                                  burnController
                                                      .currentIndex.value = 0;
                                                  burnController.dischargeStatus
                                                      .value = "";
                                                  Get.to(BurnForm(
                                                    burnId:
                                                        emo.burnsId.toString(),
                                                    triageId:
                                                        emo.triageId.toString(),
                                                    isUpdate: false,
                                                  ));
                                                } else {
                                                  burnController
                                                      .burnFormData(BurnsModel(
                                                    burns: Burns(),
                                                    burnsOutcome:
                                                        BurnsOutcome(),
                                                    burnsValues: BurnsValues(),
                                                    burnsTbsa: BurnsTbsa(),
                                                    burnsSurgeryElective: [
                                                      BurnsSurgeryElective()
                                                    ],
                                                  ));
                                                  burnController
                                                      .currentIndex.value = 0;
                                                  burnController.dischargeStatus
                                                      .value = "";
                                                  Get.to(BurnForm(
                                                    burnId:
                                                        emo.burnsId.toString(),
                                                    triageId:
                                                        emo.triageId.toString(),
                                                    isUpdate: true,
                                                  ));
                                                }
                                              })),
                                          DataCell(
                                              Text(emo.modeOfArrival ?? "-")),
                                          DataCell(Text(emo.sceneIft ?? "-")),
                                          DataCell(Text(
                                              emo.emergencyCategory ?? "-")),
                                          DataCell(Text(
                                              emo.presentingComplaint ?? "-")),
                                          DataCell(
                                              Text(emo.sourceHospital ?? "-")),
                                          DataCell(Text(
                                              emo.destinationHospital ?? "-")),
                                          DataCell(Text(emo.triageFlag ?? "-")),
                                          DataCell(TableCommonButton(
                                            compact: false,
                                            label: "View",
                                            onTap: () {
                                              Get.to(
                                                TriageEmoPillarsViewPage(
                                                  from: 'Burns',
                                                  triageId:
                                                      emo.triageId.toString(),
                                                  pillarId:
                                                      emo.burnsId.toString(),
                                                ),
                                              );
                                            },
                                          )),
                                        ],
                                      );
                                    }).toList(),
                                  ),
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
                                onPressed:
                                    burnController.burnsCurrentPage.value > 1
                                        ? () async {
                                            await burnController.getBurnList(
                                              startDate: burnController
                                                  .burnsStartDate.value
                                                  .toString(),
                                              endDate: burnController
                                                  .burnsEndDate.value
                                                  .toString(),
                                              pageNumber: burnController
                                                      .burnsCurrentPage.value -
                                                  1,
                                              patientName: burnController
                                                  .searchText.value,
                                              dischargeStatus: "2",
                                            );
                                          }
                                        : null,
                              ),
                              Text(
                                'Page ${burnController.burnsCurrentPage.value} of ${burnController.burnsTotalPages.value}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: const Icon(Icons.chevron_right),
                                onPressed: burnController
                                            .burnsCurrentPage.value <
                                        burnController.burnsTotalPages.value
                                    ? () async {
                                        await burnController.getBurnList(
                                          startDate: burnController
                                              .burnsStartDate.value
                                              .toString(),
                                          endDate: burnController
                                              .burnsEndDate.value
                                              .toString(),
                                          pageNumber: burnController
                                                  .burnsCurrentPage.value +
                                              1,
                                          patientName:
                                              burnController.searchText.value,
                                          dischargeStatus: "2",
                                        );
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
        ));
  }
}
