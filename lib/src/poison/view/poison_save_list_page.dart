import 'dart:developer';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/src/poison/controller/poison_controller.dart';
import 'package:taei_gov/src/poison/model/poisoning_model.dart';
import 'package:taei_gov/src/poison/view/poison_form.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/src/triage_emo_pillars_view/triage_emo_pillars_view_page.dart';
import 'package:taei_gov/utils/common/space.dart';
import 'package:taei_gov/utils/common/start_end_date_picker.dart';
import 'package:taei_gov/utils/common/table_common_button.dart';
import 'package:taei_gov/widgets/CommonSearchBar.dart';

class PoisonSaveListPage extends StatefulWidget {
  final bool appBar;

  const PoisonSaveListPage({super.key, this.appBar = true});

  @override
  State<PoisonSaveListPage> createState() => _PoisonSaveListPageState();
}

class _PoisonSaveListPageState extends State<PoisonSaveListPage> {
  final PoisonController poisonController = Get.put(PoisonController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      poisonController.isLoading(true);
      await poisonController.getPoisonList(
        startDate: DateFormat('yyyy-MM-dd 00:00:00')
            .format(DateTime.now().subtract(const Duration(days: 7))),
        endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
        dischargeStatus: "0",
      );
      // await poisonController.getPoisoningDashboard(
      //   startDate: DateFormat('yyyy-MM-dd 00:00:00')
      //       .format(DateTime.now().subtract(const Duration(days: 7))),
      //   endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
      // );
      poisonController.isLoading(false);
    });
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
      appBar: widget.appBar
          ? AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Get.back(),
              ),
              backgroundColor: Colors.redAccent,
              title: context.isDesktop
                  ? Center(child: Text('Poisoning'))
                  : Text('Poisoning'),
            )
          : null,
      body: Obx(() {
        if (poisonController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: context.isDesktop ? EdgeInsets.all(14) : EdgeInsets.all(8.0),
          child: Column(
            children: [
              CommonDateRangePicker(
                startDate: poisonController.poisoningStartDate.value,
                endDate: poisonController.poisoningEndDate.value,
                onApply: () async {
                  poisonController.isLoading(true);
                  await poisonController.getPoisonList(
                    startDate: poisonController.poisoningStartDate.toString(),
                    endDate: poisonController.poisoningEndDate.toString(),
                    dischargeStatus: "0",
                  );
                  // await poisonController.getPoisoningDashboard(
                  //   startDate: poisonController.poisoningStartDate.toString(),
                  //   endDate: poisonController.poisoningEndDate.toString(),
                  // );
                  poisonController.searchText.value = "";
                  poisonController.isLoading(false);
                },
                onDateSelected: (start, end) {
                  poisonController.poisoningStartDate.value = start;
                  poisonController.poisoningEndDate.value = end;
                },
              ),
              const Space(height: 14),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /*GridView.builder(
                        shrinkWrap: true,
                        // 🔹 Makes it take only as much height as needed
                        physics: const NeverScrollableScrollPhysics(),
                        // 🔹 Prevents scroll conflict with main scroll
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: context.isDesktop ? 7 : 3,
                          crossAxisSpacing: context.isDesktop ? 10 : 12,
                          mainAxisSpacing: context.isDesktop ? 10 : 12,
                          childAspectRatio: context.isDesktop ? 1.9 : 1.5,
                        ),
                        itemCount: poisonController.poisoningDataMap.length,
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
                                    poisonController.poisoningDataMap.keys
                                        .elementAt(index),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    poisonController.poisoningDataMap.values
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
                      ),*/
                      Space(
                        height: 10,
                      ),
                      NewCommonSearchField(
                        initialValue: poisonController.searchText.value,
                        onChanged: (value) {
                          poisonController.searchText.value = value;
                          poisonController.getPoisonList(
                            startDate:
                                poisonController.poisoningStartDate.toString(),
                            endDate:
                                poisonController.poisoningEndDate.toString(),
                            patientName: poisonController.searchText.value,
                            dischargeStatus: "0",
                          );
                        },
                      ),
                      Space(
                        height: 10,
                      ),
                      Container(
                        height: 600,
                        // margin: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: DataTable2(
                            headingRowColor: WidgetStateProperty.all(
                                Colors.blueGrey.shade50),
                            headingRowHeight: 56,
                            dataRowHeight: 56,
                            columnSpacing: 20,
                            horizontalMargin: 12,
                            minWidth: 1800,
                            // ensures horizontal scroll
                            fixedTopRows: 1,
                            // ✅ keeps header sticky
                            border: TableBorder.all(
                              color: Colors.grey.shade300,
                            ),
                            columns: const [
                              DataColumn2(
                                  size: ColumnSize.S,
                                  label: Text("S.No",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DataColumn2(
                                  size: ColumnSize.M,
                                  label: Text("TAEI ID",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DataColumn2(
                                  size: ColumnSize.M,
                                  label: Text("Patient Name",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DataColumn2(
                                  size: ColumnSize.L,
                                  label: Text("Create / Update",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DataColumn2(
                                  size: ColumnSize.L,
                                  label: Text("Emergency Category",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DataColumn2(
                                  label: Text("Mode of Arrival",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DataColumn2(
                                  label: Text("Scene/IFT",
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
                                  label: Text("Destination Hospital",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DataColumn2(
                                  label: Text("Triage Flag",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DataColumn2(
                                  label: Text("View",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                            ],
                            rows: poisonController.poisoningList.map((poison) {
                              Color? rowColor;
                              switch (poison.triageFlag) {
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
                                color: MaterialStateProperty.all(rowColor),
                                cells: [
                                  DataCell(
                                    Text(
                                      (((poisonController.poisoningCurrentPage
                                                          .value -
                                                      1) *
                                                  poisonController
                                                      .poisoningLimit) +
                                              (poisonController.poisoningList
                                                      .indexOf(poison) ??
                                                  0) +
                                              1)
                                          .toString(),
                                    ),
                                  ),
                                  DataCell(Text(poison.triageId.toString())),
                                  DataCell(Text(poison.nameOfPatient ?? '-')),
                                  DataCell(TableCommonButton(
                                      compact: false,
                                      color: poison.poisonId != null
                                          ? Colors.green.shade700
                                          : Colors.redAccent.shade700,
                                      label: poison.poisonId != null
                                          ? "Update"
                                          : "Poison",
                                      icon: poison.poisonId != null
                                          ? Icons.edit
                                          : Icons.add_business_rounded,
                                      onTap: () {
                                        if (poison.poisonId == null) {
                                          poisonController.poisoning(
                                              PoisoningModel(
                                                  poison: Poison(),
                                                  poisonsOutcome:
                                                      PoisonsOutcome()));
                                          poisonController.currentIndex.value =
                                              0;
                                          poisonController
                                              .dischargeStatus.value = "0";
                                          Get.to(PoisonForm(
                                            dateAndTimeOfIncident:
                                                poison.dateAndTimeOfIncident,
                                            dateTimeOfTriage:
                                                poison.dateTimeOfTriage,
                                            triageId:
                                                poison.triageId.toString(),
                                            poisonId:
                                                poison.poisonId.toString(),
                                            isUpdate: false,
                                          ));
                                          log("Test Confirm Created${poisonController.dischargeStatus.value}");
                                        } else {
                                          poisonController.poisoning(
                                              PoisoningModel(
                                                  poison: Poison(),
                                                  poisonsOutcome:
                                                      PoisonsOutcome()));
                                          poisonController.currentIndex.value =
                                              0;
                                          poisonController
                                              .dischargeStatus.value = "0";
                                          Get.to(PoisonForm(
                                            dateAndTimeOfIncident:
                                                poison.dateAndTimeOfIncident,
                                            dateTimeOfTriage:
                                                poison.dateTimeOfTriage,
                                            triageId:
                                                poison.triageId.toString(),
                                            poisonId:
                                                poison.poisonId.toString(),
                                            isUpdate: true,
                                          ));
                                          log("Test Confirm Update${poisonController.dischargeStatus.value}");
                                        }
                                      })),
                                  DataCell(
                                      Text(poison.emergencyCategory ?? '-')),
                                  DataCell(Text(poison.modeOfArrival ?? '-')),
                                  DataCell(Text(poison.sceneIft ?? '-')),
                                  DataCell(
                                      Text(poison.presentingComplaint ?? '-')),
                                  DataCell(Text(poison.sourceHospital ?? '-')),
                                  DataCell(
                                      Text(poison.destinationHospital ?? '-')),
                                  DataCell(Text(poison.triageFlag ?? '-')),
                                  DataCell(TableCommonButton(
                                    compact: false,
                                    label: "View",
                                    onTap: () {
                                      Get.to(
                                        TriageEmoPillarsViewPage(
                                          from: 'Poisoning',
                                          triageId: poison.triageId.toString(),
                                          pillarId: poison.poisonId.toString(),
                                        ),
                                      );
                                    },
                                  ))
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
                            poisonController.poisoningCurrentPage.value > 1
                                ? () async {
                                    await poisonController.getPoisonList(
                                      startDate: poisonController
                                          .poisoningStartDate.value
                                          .toString(),
                                      endDate: poisonController
                                          .poisoningEndDate.value
                                          .toString(),
                                      pageNumber: poisonController
                                              .poisoningCurrentPage.value -
                                          1,
                                      patientName:
                                          poisonController.searchText.value,
                                      dischargeStatus: "0",
                                    );
                                  }
                                : null,
                      ),
                      Text(
                        'Page ${poisonController.poisoningCurrentPage.value} of ${poisonController.poisoningTotalPages.value}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: poisonController.poisoningCurrentPage.value <
                                poisonController.poisoningTotalPages.value
                            ? () async {
                                await poisonController.getPoisonList(
                                    startDate: poisonController
                                        .poisoningStartDate.value
                                        .toString(),
                                    endDate: poisonController
                                        .poisoningEndDate.value
                                        .toString(),
                                    pageNumber: poisonController
                                            .poisoningCurrentPage.value +
                                        1,
                                    patientName:
                                        poisonController.searchText.value,
                                    dischargeStatus: "0");
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
    );
  }

  int calculatePositiveDays(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 0;

    try {
      // Convert "2025-11-26 03:42:00 PM" → DateTime
      DateTime date = DateFormat("yyyy-MM-dd hh:mm:ss a").parse(dateString);

      // Difference from now
      int days = DateTime.now().difference(date).inDays;

      // Return only positive (no negative values)
      return days < 0 ? 0 : days;
    } catch (e) {
      return 0;
    }
  }
}
