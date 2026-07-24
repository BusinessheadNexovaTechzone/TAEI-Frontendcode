import 'dart:async';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/src/drowning/controller/drowning_controller.dart';
import 'package:taei_gov/src/drowning/views/create_drowning.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/utils/helpers/no_data_widget.dart';
import '../../../utils/common/space.dart';
import '../../../utils/common/start_end_date_picker.dart';
import '../../../widgets/CommonSearchBar.dart';
import '../../triage_emo_pillars_view/triage_emo_pillars_view_page.dart';

class DrowningListPage extends StatefulWidget {
  final bool appBar;
  final int? discharge;

  const DrowningListPage({super.key, this.appBar = true, this.discharge});

  @override
  State<DrowningListPage> createState() => _DrowningListPageState();
}

class _DrowningListPageState extends State<DrowningListPage> {
  DrowningController controller = Get.put(DrowningController());
  final TextEditingController searchController = TextEditingController();

  /// ✅ Local filtered list
  List<dynamic> filteredList = [];

  bool _isFocused = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDrowningData();
    });
  }

  Future<void> _loadDrowningData() async {
    controller.isDrowningLoading(true);

    final now = DateTime.now();

    final startDate = DateFormat('yyyy-MM-dd 00:00:00').format(now);
    final endDate = DateFormat('yyyy-MM-dd 23:59:59').format(now);

    await controller.getDrowningList(
      startDate: startDate,
      endDate: endDate,
      dischargeStatus: widget.discharge ?? 1,
    );

    await controller.getDrowningDashboard(
      startDate: startDate,
      endDate: endDate,
    );

    controller.isDrowningLoading(false);
  }

  @override
  void didUpdateWidget(covariant DrowningListPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.discharge != widget.discharge) {
      _loadDrowningData();
    }
  }

  // Future<void> fetchData() async {
  //   await controller.getDrowningList(
  //     startDate: DateFormat('yyyy-MM-dd 00:00:00')
  //         .format(DateTime.now().subtract(Duration(days: 7))),
  //     endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
  //   );
  // }

  // /// ✅ Local search filter (by name only)
  // void _filterSearch(String query) {
  //   setState(() {
  //     if (query.isEmpty) {
  //       filteredList = List.from(controller.drowningList.value!.rows ?? []);
  //     } else {
  //       filteredList = controller.drowningList.value!.rows!
  //           .where((item) => (item.nameOfPatient ?? '')
  //               .toLowerCase()
  //               .contains(query.toLowerCase()))
  //           .toList();
  //     }
  //   });
  // }

  final List<List<Color>> gradientColors = [
    [Colors.purple, Colors.deepPurpleAccent],
    [Colors.orange, Colors.deepOrangeAccent],
    [Colors.green, Colors.lightGreen],
    [Colors.blue, Colors.lightBlueAccent],
    [Colors.red, Colors.pinkAccent],
    [Colors.teal, Colors.cyan],
    [Colors.indigo, Colors.blueAccent],
  ];

  // final Map<String, int> drowningSummary = {
  //   'Total': 26,
  //   'IFT': 11,
  //   'No of Admitted': 26,
  //   'Pending': 25,
  //   'Mild': 26,
  //   'Moderate': 26,
  //   'Severe': 26,
  // };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar
          ? AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Get.back(),
              ),
              backgroundColor: Colors.redAccent,
              title: const Text('Drowning Cases'),
              centerTitle: true,
            )
          : null,
      body: Obx(
        () => controller.isDrowningLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: context.isDesktop
                    ? const EdgeInsets.all(18)
                    : const EdgeInsets.all(8),
                child: Column(
                  spacing: context.isDesktop ? 10 : 12,
                  children: [
                    CommonDateRangePicker(
                      startDate: controller.drowningStartDate.value,
                      endDate: controller.drowningEndDate.value,
                      onApply: () async {
                        controller.isDrowningLoading(true);
                        await controller.getDrowningList(
                            startDate:
                                controller.drowningStartDate.value.toString(),
                            endDate:
                                controller.drowningEndDate.value.toString(),
                            dischargeStatus: widget.discharge!);
                        await controller.getDrowningDashboard(
                          startDate:
                              controller.drowningStartDate.value.toString(),
                          endDate: controller.drowningEndDate.value.toString(),
                        );
                        controller.isDrowningLoading(false);
                      },
                      onDateSelected: (start, end) {
                        controller.drowningStartDate.value = start;
                        controller.drowningEndDate.value = end;
                      },
                    ),
                    // const SizedBox(height: 14),

                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// 🔹 Summary Cards
                            Visibility(
                              visible: widget.discharge == 1 ? false : true,
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: context.isDesktop ? 7 : 3,
                                  crossAxisSpacing: context.isDesktop ? 10 : 12,
                                  mainAxisSpacing: context.isDesktop ? 10 : 12,
                                  childAspectRatio:
                                      context.isDesktop ? 1.9 : 1.5,
                                ),
                                itemCount: controller.drowningDataMap.length,
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
                                            controller.drowningDataMap.keys
                                                .elementAt(index),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            controller.drowningDataMap.values
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

                            Container(
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
                                    minWidth: 1800,
                                    fixedTopRows: 1,
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
                                          size: ColumnSize.M,
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
                                          size: ColumnSize.L,
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
                                          size: ColumnSize.S,
                                          label: Text("View",
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    ],

                                    /// ✅ Use filteredList for display
                                    rows: controller.filteredDrowningList
                                        .map<DataRow>((data) {
                                      Color? rowColor;
                                      switch (data.triageFlag) {
                                        case 'Red':
                                          rowColor = Colors.red;
                                          break;
                                        case 'Yellow':
                                          rowColor = Colors.yellow.shade700;
                                          break;
                                        case 'Green':
                                          rowColor = Colors.green;
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
                                              (((controller.drowningCurrentPage
                                                                  .value -
                                                              1) *
                                                          controller
                                                              .drowningLimit) +
                                                      (controller.drowningList
                                                          .indexOf(data)) +
                                                      1)
                                                  .toString(),
                                            ),
                                          ),
                                          DataCell(Text(
                                              data.triageId?.toString() ??
                                                  "-")),
                                          DataCell(
                                              Text(data.nameOfPatient ?? "-")),
                                          DataCell(
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.blueAccent,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 8),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              onPressed: () {
                                                if (data.drowningId == null) {
                                                  controller.drowningModel
                                                      .value = null;
                                                  controller
                                                      .currentIndex.value = 0;
                                                  Get.to(() => CreateDrowning(
                                                        hangId: data.drowningId,
                                                        triageId: data.triageId,
                                                        isUpdate: false,
                                                      ));
                                                } else {
                                                  controller.drowningModel
                                                      .value = null;
                                                  controller
                                                      .currentIndex.value = 0;
                                                  Get.to(() => CreateDrowning(
                                                        hangId: data.drowningId,
                                                        triageId: data.triageId,
                                                        isUpdate: true,
                                                      ));
                                                }
                                              },
                                              child: data.drowningId != null
                                                  ? const Text("Update")
                                                  : const Text("Drowning"),
                                            ),
                                          ),
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
                                          DataCell(
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.remove_red_eye,
                                                  color: Colors.blue),
                                              tooltip: "View Drowning",
                                              onPressed: () {
                                                Get.to(TriageEmoPillarsViewPage(
                                                    from: 'Drowning',
                                                    pillarId: data.drowningId
                                                        .toString(),
                                                    triageId: data.triageId
                                                        .toString()));
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            )
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
                              onPressed: controller.drowningCurrentPage.value >
                                      1
                                  ? () async {
                                      await controller.getDrowningList(
                                          startDate: controller
                                              .drowningStartDate.value
                                              .toString(),
                                          endDate: controller
                                              .drowningEndDate.value
                                              .toString(),
                                          pageNumber: controller
                                                  .drowningCurrentPage.value -
                                              1,
                                          dischargeStatus: widget.discharge!);
                                    }
                                  : null,
                            ),
                            Text(
                              'Page ${controller.drowningCurrentPage.value} of ${controller.drowningTotalPages.value}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.chevron_right),
                              onPressed: controller.drowningCurrentPage.value <
                                      controller.drowningTotalPages.value
                                  ? () async {
                                      await controller.getDrowningList(
                                          startDate: controller
                                              .drowningStartDate.value
                                              .toString(),
                                          endDate: controller
                                              .drowningEndDate.value
                                              .toString(),
                                          pageNumber: controller
                                                  .drowningCurrentPage.value +
                                              1,
                                          dischargeStatus: widget.discharge!);
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
    );
  }
}
