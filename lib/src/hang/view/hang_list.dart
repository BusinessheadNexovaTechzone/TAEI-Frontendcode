import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/src/hang/view/hang_form.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/utils/common/space.dart';
import 'package:taei_gov/utils/common/start_end_date_picker.dart';
import 'package:taei_gov/utils/common/table_common_button.dart';
import 'package:taei_gov/utils/helpers/no_data_widget.dart';
import 'package:taei_gov/widgets/CommonSearchBar.dart';

import '../../triage_emo_pillars_view/triage_emo_pillars_view_page.dart';
import '../controller/hang_controller.dart';

class HangingListPage extends StatefulWidget {
  final bool appBar;

  const HangingListPage({super.key, this.appBar = true});

  @override
  State<HangingListPage> createState() => _BurnListPageState();
}

class _BurnListPageState extends State<HangingListPage> {
  HangController controller = Get.put(HangController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller.isHangLoading(true);
      await controller.getHangList(
        startDate: DateFormat('yyyy-MM-dd 00:00:00')
            .format(DateTime.now().subtract(Duration(days: 7))),
        endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
        dischargeStatus: "2",
      );
      await controller.getHangingDashboard(
        startDate: DateFormat('yyyy-MM-dd 00:00:00')
            .format(DateTime.now().subtract(Duration(days: 7))),
        endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
      );
      controller.isHangLoading(false);
    });
  }

  //
  // fetchData() {
  //   Future.delayed(Duration.zero, () async {
  //     controller.isHangLoading(true);
  //     await controller.getHangList(
  //       startDate: DateFormat('yyyy-MM-dd 00:00:00')
  //           .format(DateTime.now().subtract(Duration(days: 7))),
  //       endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
  //     );
  //     await controller.getHangingDashboard(
  //       startDate: DateFormat('yyyy-MM-dd 00:00:00')
  //           .format(DateTime.now().subtract(Duration(days: 7))),
  //       endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
  //     );
  //     controller.isHangLoading(false);
  //   });
  // }

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
                    ? Center(child: Text('Hanging'))
                    : Text('Hanging'),
              )
            : null,
        body: Obx(
          () => controller.isHangLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    children: [
                      CommonDateRangePicker(
                        startDate: controller.hangingStartDate.value,
                        endDate: controller.hangingEndDate.value,
                        onApply: () async {
                          controller.isHangLoading(true);
                          await controller.getHangList(
                            startDate: controller.hangingStartDate.toString(),
                            endDate: controller.hangingEndDate.toString(),
                            dischargeStatus: "2",
                          );
                          await controller.getHangingDashboard(
                            startDate: controller.hangingStartDate.toString(),
                            endDate: controller.hangingEndDate.toString(),
                          );
                          controller.searchText.value = "";
                          controller.isHangLoading(false);
                        },
                        onDateSelected: (start, end) {
                          controller.hangingStartDate.value = start;
                          controller.hangingEndDate.value = end;
                        },
                      ),
                      const Space(
                        height: 12,
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
                                itemCount: controller.hangingDataMap.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 6,
                                          offset: Offset(2, 4),
                                        ),
                                      ],
                                      gradient: LinearGradient(
                                        colors:
                                            gradients[index % gradients.length],
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
                                            controller.hangingDataMap.keys
                                                .elementAt(index),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            controller.hangingDataMap.values
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
                                  controller.getHangList(
                                    startDate:
                                        controller.hangingStartDate.toString(),
                                    endDate:
                                        controller.hangingEndDate.toString(),
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
                                          size: ColumnSize.L,
                                          label: Text("TAEI ID",
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn2(
                                          size: ColumnSize.M,
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
                                          size: ColumnSize.L,
                                          label: Text("Scene Or IFT",
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn2(
                                          size: ColumnSize.L,
                                          label: Text("Emergency Category",
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn2(
                                          size: ColumnSize.L,
                                          label: Text("Presenting Complaint",
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn2(
                                          size: ColumnSize.L,
                                          label: Text("Source Hospital",
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn2(
                                          size: ColumnSize.L,
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

                                    rows: controller.hangingList
                                        .map<DataRow>((data) {
                                      Color? rowColor;
                                      switch (data.triageFlag) {
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
                                            WidgetStateProperty.all(rowColor),
                                        cells: [
                                          DataCell(
                                            Text(
                                              (((controller.hangingCurrentPage
                                                                  .value -
                                                              1) *
                                                          controller
                                                              .hangingLimit) +
                                                      (controller.hangingList
                                                              .indexOf(data) ??
                                                          0) +
                                                      1)
                                                  .toString(),
                                            ),
                                          ),
                                          DataCell(Text(
                                              data.triageId?.toString() ??
                                                  "-")),
                                          DataCell(
                                              Text(data.nameOfPatient ?? "-")),
                                          DataCell(TableCommonButton(
                                              compact: false,
                                              color: data.hangingId != null
                                                  ? Colors.green.shade700
                                                  : Colors.redAccent.shade700,
                                              label: data.hangingId != null
                                                  ? "Update"
                                                  : "Hanging",
                                              icon: data.hangingId != null
                                                  ? Icons.edit
                                                  : Icons.add_business_rounded,
                                              onTap: () {
                                                if (data.hangingId == null) {
                                                  controller.hangModel.value =
                                                      null;
                                                  controller
                                                      .currentIndex.value = 0;
                                                  controller.dischargeStatus
                                                      .value = "";
                                                  Get.to(() => HangForm(
                                                        hangId: data.hangingId,
                                                        triageId: data.triageId,
                                                        isUpdate: false,
                                                      ));
                                                } else {
                                                  controller.hangModel.value =
                                                      null;
                                                  controller
                                                      .currentIndex.value = 0;
                                                  controller.dischargeStatus
                                                      .value = "";
                                                  Get.to(() => HangForm(
                                                        hangId: data.hangingId,
                                                        triageId: data.triageId,
                                                        isUpdate: true,
                                                      ));
                                                }
                                              })),
                                          DataCell(
                                              Text(data.modeOfArrival ?? "-")),
                                          DataCell(Text(data.sceneIft ?? "-")),
                                          DataCell(Text(
                                              data.emergencyCategory ?? "-")),
                                          DataCell(Text(
                                              data.presentingComplaint ?? "-")),
                                          DataCell(
                                              Text(data.sourceHospital ?? "-")),
                                          DataCell(Text(
                                              data.destinationHospital ?? "-")),
                                          DataCell(
                                              Text(data.triageFlag ?? "-")),
                                          DataCell(TableCommonButton(
                                            compact: false,
                                            label: "View",
                                            onTap: () {
                                              Get.to(
                                                TriageEmoPillarsViewPage(
                                                  from: 'Hang',
                                                  triageId:
                                                      data.triageId.toString(),
                                                  pillarId:
                                                      data.hangingId.toString(),
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
                                    controller.hangingCurrentPage.value > 1
                                        ? () async {
                                            await controller.getHangList(
                                              startDate: controller
                                                  .hangingStartDate.value
                                                  .toString(),
                                              endDate: controller
                                                  .hangingEndDate.value
                                                  .toString(),
                                              pageNumber: controller
                                                      .hangingCurrentPage
                                                      .value -
                                                  1,
                                              patientName:
                                                  controller.searchText.value,
                                              dischargeStatus: "2",
                                            );
                                          }
                                        : null,
                              ),
                              Text(
                                'Page ${controller.hangingCurrentPage.value} of ${controller.hangingTotalPages.value}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: const Icon(Icons.chevron_right),
                                onPressed: controller.hangingCurrentPage.value <
                                        controller.hangingTotalPages.value
                                    ? () async {
                                        await controller.getHangList(
                                          startDate: controller
                                              .hangingStartDate.value
                                              .toString(),
                                          endDate: controller
                                              .hangingEndDate.value
                                              .toString(),
                                          pageNumber: controller
                                                  .hangingCurrentPage.value +
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
