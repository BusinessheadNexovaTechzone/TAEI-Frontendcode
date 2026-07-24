import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/src/nurse_triage/controller/nurse_triage_controller.dart';
import 'package:taei_gov/src/nurse_triage/models/create_triage_model.dart';
import 'package:taei_gov/src/nurse_triage/views/add_accident.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/src/transit_care/controller/transit_care_controller.dart';
import 'package:taei_gov/utils/common/space.dart';
import 'package:taei_gov/utils/common/start_end_date_picker.dart';
import 'package:taei_gov/utils/common/table_common_button.dart';
import 'package:taei_gov/utils/helpers/no_data_widget.dart';
import 'package:taei_gov/utils/helpers/page_loader.dart';
import 'package:taei_gov/widgets/CommonSearchBar.dart';

import '../../triage_emo_pillars_view/triage_emo_pillars_view_page.dart';
import '../controller/pdf_generative_controller.dart';

class TriageNurseList extends StatefulWidget {
  final bool appBar;

  const TriageNurseList({super.key, this.appBar = true});

  @override
  State<TriageNurseList> createState() => _TriageNurseListState();
}

class _TriageNurseListState extends State<TriageNurseList> {
  NurseTriageController controller = Get.put(NurseTriageController());
  final TransitCareController transitController =
      Get.put(TransitCareController());
  final controllerpdf = Get.put(pdfController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller.isTriageLoading(true);
      await controller.getTriageList(
        startDate: DateFormat('yyyy-MM-dd 00:00:00')
            .format(DateTime.now().subtract(const Duration(days: 7))),
        endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
      );
      await controller.fetchTriageDashboard(
        startDate: DateFormat('yyyy-MM-dd 00:00:00')
            .format(DateTime.now().subtract(const Duration(days: 7))),
        endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
      );
      controller.isTriageLoading(false);
      // fetchData();
    });

    // fetchData();
    super.initState();
  }

  // fetchData() {
  //   Future.delayed(Duration.zero, () async {
  //     await controller.getTriageList();
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
    return SafeArea(
      bottom: true,
      child: Scaffold(
          appBar: widget.appBar
              ? AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Get.back(),
                  ),
                  backgroundColor: Colors.redAccent,
                  title: context.isDesktop
                      ? Center(child: Text('Triage List'))
                      : Text('Triage List'),
                )
              : null,
          body: Obx(() => controller.isTriageLoading.value
              ? pageLoader()
              : Padding(
                  padding: context.isDesktop
                      ? EdgeInsets.all(16.0)
                      : EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      CommonDateRangePicker(
                        startDate: controller.triageStartDate.value,
                        endDate: controller.triageEndDate.value,
                        onApply: () async {
                          controller.isTriageLoading(true);
                          await controller.getTriageList(
                            startDate:
                                controller.triageStartDate.value.toString(),
                            endDate: controller.triageEndDate.value.toString(),
                          );

                          await controller.fetchTriageDashboard(
                            startDate:
                                controller.triageStartDate.value.toString(),
                            endDate: controller.triageEndDate.value.toString(),
                          );
                          controller.isTriageLoading(false);
                        },
                        onDateSelected: (start, end) {
                          controller.triageStartDate.value = start;
                          controller.triageEndDate.value = end;
                        },
                      ),
                      Space(
                        height: 20,
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
                                itemCount: controller.triageDataMap.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
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
                                            controller.triageDataMap.keys
                                                .elementAt(index),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            controller.triageDataMap.values
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
                                height: 20,
                              ),
                              NewCommonSearchField(
                                initialValue: controller.triageSearchText.value,
                                onChanged: (value) {
                                  controller.triageSearchText.value = value;
                                },
                              ),
                              Space(
                                height: 20,
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
                                            label: Text("S.No",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        DataColumn2(
                                            size: ColumnSize.S,
                                            label: Text("TAEI",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        DataColumn2(
                                            label: Text("Patient Name",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        DataColumn2(
                                            label: Text("Update / Edit",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        DataColumn2(
                                            label: Text("Vehicle No.",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        DataColumn2(
                                            label: Text("Mode of Arrival",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        DataColumn2(
                                            label: Text("Call ID",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        DataColumn2(
                                            label: Text("Chief Complaint",
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
                                            label: Text("View",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        DataColumn2(
                                            label: Text("Case Sheet",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))),

                                        // DataColumn2(
                                        //     label: Text("Update",
                                        //         style:
                                        //             TextStyle(fontWeight: FontWeight.bold))),
                                      ],
                                      rows: controller.filteredTriageList
                                              .map<DataRow>((triage) {
                                            return DataRow(
                                              color: MaterialStateProperty.all(
                                                  triage.triageFlag == 'Yellow'
                                                      ? Colors.yellow
                                                      : triage.triageFlag ==
                                                              'Red'
                                                          ? Colors.red
                                                          : triage.triageFlag ==
                                                                  'Green'
                                                              ? Colors.green
                                                              : triage.triageFlag ==
                                                                      'Black'
                                                                  ? Colors.grey
                                                                      .shade300
                                                                  : Colors
                                                                      .white),
                                              cells: [
                                                DataCell(
                                                  Text(
                                                    (((controller.triageCurrentPage
                                                                        .value -
                                                                    1) *
                                                                controller
                                                                    .triageLimit) +
                                                            (controller
                                                                    .triageList
                                                                    .indexOf(
                                                                        triage) ??
                                                                0) +
                                                            1)
                                                        .toString(),
                                                  ),
                                                ),

                                                DataCell(Text(triage.triageId
                                                        ?.toString() ??
                                                    "-")),
                                                DataCell(Text(
                                                    triage.nameOfPatient ??
                                                        "-")),

                                                DataCell(TableCommonButton(
                                                    compact: false,
                                                    label: "Triage",
                                                    icon: Icons
                                                        .add_business_rounded,
                                                    color:
                                                        Colors.green.shade700,
                                                    onTap: () {
                                                      controller.createTriageModel(
                                                          TriageModel(
                                                              triage: Triage(),
                                                              triageBy108:
                                                                  TriageBy108(),
                                                              triageDtls:
                                                                  TriageDtls()));
                                                      controller.currentIndex
                                                          .value = 0;
                                                      Get.to(AddAccident(
                                                        id: triage.triageId
                                                            .toString(),
                                                        isUpdate: true,
                                                        form: triage.callId ==
                                                                    null ||
                                                                triage.callId ==
                                                                    'null'
                                                            ? true
                                                            : false,
                                                      ));
                                                    })),
                                                DataCell(Text(
                                                    triage.vehicleNumber ??
                                                        "-")),
                                                DataCell(Text(
                                                    triage.modeOfArrival ??
                                                        "-")),
                                                DataCell(
                                                    Text(triage.callId ?? "-")),
                                                DataCell(Text(
                                                    triage.chiefComplaint ??
                                                        "-")),
                                                DataCell(Text(
                                                    triage.sourceHospital ??
                                                        "-")),
                                                DataCell(Text(triage
                                                        .destinationHospital ??
                                                    "-")),
                                                triage.triageId != null
                                                    ? DataCell(
                                                        TableCommonButton(
                                                            compact: false,
                                                            label: "View",
                                                            onTap: () {
                                                              Get.to(
                                                                  TriageEmoPillarsViewPage(
                                                                from: 'Triage',
                                                                triageId: triage
                                                                    .triageId
                                                                    .toString(),
                                                                triage: true,
                                                              ));
                                                            }))
                                                    : DataCell(
                                                        Text("Not Available")),
                                                DataCell(
                                                  Obx(() {
                                                    final isDownloading =
                                                        controllerpdf
                                                                .downloadingId
                                                                .value ==
                                                            triage.triageId
                                                                .toString();

                                                    return Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        IconButton(
                                                          icon: Image.asset(
                                                                  'assets/icons/download_icon.png',
                                                                  width: 34,
                                                                  height: 34,
                                                                  colorBlendMode:
                                                                      BlendMode
                                                                          .srcIn,
                                                                  filterQuality:
                                                                      FilterQuality
                                                                          .high,
                                                                ),
                                                          onPressed: () {},
                                                        ),

                                                        const SizedBox(
                                                            width: 6),

                                                        /// 👁 View Asset Button
                                                        IconButton(
                                                          icon: Image.asset(
                                                            'assets/logo/green_1.png',
                                                            width: 34,
                                                            height: 34,
                                                            colorBlendMode:
                                                                BlendMode.srcIn,
                                                            filterQuality:
                                                                FilterQuality
                                                                    .high,
                                                          ),
                                                          splashRadius: 18,
                                                          onPressed:
                                                              isDownloading
                                                                  ? null
                                                                  : () {
                                                                      controllerpdf
                                                                          .downloadFullCasePdf(
                                                                        id: triage
                                                                            .triageId
                                                                            .toString(),
                                                                        emoB:
                                                                            true,
                                                                      );
                                                                    },
                                                        ),
                                                      ],
                                                    );
                                                  }),
                                                ),

                                                // DataCell(
                                                //   IconButton(
                                                //     icon: const Icon(Icons.edit,
                                                //         color: Colors.blue),
                                                //     tooltip: "Edit Triage",
                                                //     onPressed: () {
                                                //       Get.to(AddAccident(
                                                //         id: triage.triageId.toString(),
                                                //         isUpdate: true,
                                                //       ));
                                                //     },
                                                //   ),
                                                // ),
                                              ],
                                            );
                                          }).toList() ??
                                          [],
                                    ),
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
                                    controller.triageCurrentPage.value > 1
                                        ? () async {
                                            await controller.getTriageList(
                                              startDate: controller
                                                  .triageStartDate.value
                                                  .toString(),
                                              endDate: controller
                                                  .triageEndDate.value
                                                  .toString(),
                                              pageNumber: controller
                                                      .triageCurrentPage.value -
                                                  1,
                                            );
                                          }
                                        : null,
                              ),
                              Text(
                                'Page ${controller.triageCurrentPage.value} of ${controller.triageTotalPages.value}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: const Icon(Icons.chevron_right),
                                onPressed: controller.triageCurrentPage.value <
                                        controller.triageTotalPages.value
                                    ? () async {
                                        await controller.getTriageList(
                                          startDate: controller
                                              .triageStartDate.value
                                              .toString(),
                                          endDate: controller
                                              .triageEndDate.value
                                              .toString(),
                                          pageNumber: controller
                                                  .triageCurrentPage.value +
                                              1,
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
                ))),
    );
  }
}
