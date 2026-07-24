import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:taei_gov/src/script/views/script_detail_screen.dart';

import 'package:taei_gov/src/emo_user/controller/emo_controller.dart';
import 'package:taei_gov/src/emo_user/view/emo_form.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/src/script/controller/script_controller.dart';
import 'package:taei_gov/src/script/models/create_script_model.dart';
import 'package:taei_gov/src/stemi/form_page.dart';
import 'package:taei_gov/src/triage_emo_pillars_view/triage_emo_pillars_view_page.dart';
import 'package:taei_gov/utils/common/space.dart';
import 'package:taei_gov/utils/common/start_end_date_picker.dart';
import 'package:taei_gov/utils/common/table_common_button.dart';
import 'package:taei_gov/utils/helpers/no_data_widget.dart';
import 'package:taei_gov/utils/helpers/page_loader.dart';
import 'package:taei_gov/widgets/CommonSearchBar.dart';

import 'add_script.dart';

class ScriptListPage extends StatefulWidget {
  final bool appBar;

  const ScriptListPage({super.key, this.appBar = true});

  @override
  State<ScriptListPage> createState() => _ScriptListPageState();
}

class _ScriptListPageState extends State<ScriptListPage> {
  ScriptController controller = Get.put(ScriptController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller.isScriptLoading(true);
      await controller.getScriptList(
        startDate: DateFormat('yyyy-MM-dd 00:00:00')
            .format(DateTime.now().subtract(Duration(days: 7))),
        endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
        dischargeStatus: "2",
      );
      await controller.getStrokeDashboard(
        startDate: DateFormat('yyyy-MM-dd 00:00:00')
            .format(DateTime.now().subtract(Duration(days: 7))),
        endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
      );
      controller.isScriptLoading(false);
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
    return Scaffold(
        appBar: widget.appBar
            ? AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Get.back(),
                ),
                backgroundColor: Colors.redAccent,
                title: const Text('Script List'),
              )
            : null,
        body: Obx(
          () => controller.isScriptLoading.value
              ? pageLoader()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      CommonDateRangePicker(
                        startDate: controller.scriptStartDate.value,
                        endDate: controller.scriptEndDate.value,
                        onApply: () async {
                          controller.isLoading(true);
                          await controller.getScriptList(
                            startDate: controller.scriptStartDate.toString(),
                            endDate: controller.scriptEndDate.toString(),
                            dischargeStatus: "2",
                          );
                          await controller.getStrokeDashboard(
                            startDate: controller.scriptStartDate.toString(),
                            endDate: controller.scriptEndDate.toString(),
                          );
                          controller.searchText.value = "";
                          controller.isLoading(false);
                        },
                        onDateSelected: (start, end) {
                          controller.scriptStartDate.value = start;
                          controller.scriptEndDate.value = end;
                        },
                      ),
                      const SizedBox(height: 16),
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
                                itemCount: controller.strokeDataMap.length,
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
                                            controller.strokeDataMap.keys
                                                .elementAt(index),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            controller.strokeDataMap.values
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
                                initialValue: controller.searchText.value,
                                onChanged: (value) {
                                  controller.searchText.value = value;

                                  controller.getScriptList(
                                    startDate:
                                        controller.scriptStartDate.toString(),
                                    endDate:
                                        controller.scriptEndDate.toString(),
                                    patientName: controller.searchText.value,
                                    dischargeStatus: "2",
                                  );
                                },
                              ),
                              Space(
                                height: 10,
                              ),
                              Container(
                                height: 500,
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
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn2(
                                          size: ColumnSize.S,
                                          label: Text("TAEI ID",
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn2(
                                          label: Text("Patient name",
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn2(
                                          size: ColumnSize.L,
                                          label: Text("Create / Update",
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn2(
                                          label: Text("Mode of arrival",
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn2(
                                          label: Text("Scene or ift",
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn2(
                                          label: Text("Emergency category",
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn2(
                                          label: Text("Presenting complaint",
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn2(
                                          label: Text(
                                              "If ift - source hospital",
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

                                    rows: controller.scriptList
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
                                              (((controller.scriptCurrentPage
                                                                  .value -
                                                              1) *
                                                          controller
                                                              .scriptLimit) +
                                                      (controller.scriptList
                                                          .indexOf(emo)) +
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
                                              color: emo.strokeId != null
                                                  ? Colors.green.shade700
                                                  : Colors.redAccent.shade700,
                                              label: emo.strokeId != null
                                                  ? "Update"
                                                  : "Script",
                                              icon: emo.strokeId != null
                                                  ? Icons.edit
                                                  : Icons.add_business_rounded,
                                              onTap: () {
                                                if (emo.strokeId != null) {
                                                  controller.dischargeStatus
                                                      .value = "";
                                                  Get.to(() => AddScript(
                                                        strokeId: emo.strokeId
                                                            .toString(),
                                                        triageId: emo.triageId
                                                            .toString(),
                                                        isUpdate: true,
                                                      ));
                                                } else {
                                                  controller.scriptModel(
                                                      CreateScriptModel(
                                                    stroke: Stroke(),
                                                    outcome: Outcome(),
                                                  ));
                                                  controller.dischargeStatus
                                                      .value = "";
                                                  Get.to(() => AddScript(
                                                        strokeId: emo.strokeId
                                                            .toString(),
                                                        triageId: emo.triageId
                                                            .toString(),
                                                        isUpdate: false,
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
                                                Get.to(TriageEmoPillarsViewPage(
                                                    from: 'Script',
                                                    pillarId:
                                                        emo.strokeId.toString(),
                                                    triageId: emo.triageId
                                                        .toString()));
                                              })),
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
                                    controller.scriptCurrentPage.value > 1
                                        ? () async {
                                            await controller.getScriptList(
                                              startDate: controller
                                                  .scriptStartDate.value
                                                  .toString(),
                                              endDate: controller
                                                  .scriptEndDate.value
                                                  .toString(),
                                              pageNumber: controller
                                                      .scriptCurrentPage.value -
                                                  1,
                                              patientName:
                                                  controller.searchText.value,
                                              dischargeStatus: "2",
                                            );
                                          }
                                        : null,
                              ),
                              Text(
                                'Page ${controller.scriptCurrentPage.value} of ${controller.scriptTotalPages.value}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: const Icon(Icons.chevron_right),
                                onPressed: controller.scriptCurrentPage.value <
                                        controller.scriptTotalPages.value
                                    ? () async {
                                        await controller.getScriptList(
                                          startDate: controller
                                              .scriptStartDate.value
                                              .toString(),
                                          endDate: controller
                                              .scriptEndDate.value
                                              .toString(),
                                          pageNumber: controller
                                                  .scriptCurrentPage.value +
                                              1,
                                          patientName:
                                              controller.searchText.value,
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
