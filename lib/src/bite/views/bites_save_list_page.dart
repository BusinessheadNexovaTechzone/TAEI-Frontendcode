import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/src/emo_user/controller/emo_controller.dart';
import 'package:taei_gov/src/emo_user/model/emo_model.dart';
import 'package:taei_gov/src/emo_user/view/emo_form.dart';
import 'package:taei_gov/src/prem/view/prem_form.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/src/triage_emo_pillars_view/triage_emo_pillars_view_page.dart';
import 'package:taei_gov/utils/common/common_button.dart';
import 'package:taei_gov/utils/common/space.dart';
import 'package:taei_gov/utils/common/start_end_date_picker.dart';
import 'package:taei_gov/utils/common/table_common_button.dart';
import 'package:taei_gov/widgets/CommonSearchBar.dart';

import '../../../utils/helpers/loading_helper.dart';
import '../controller/bites_controller.dart';
import 'add_bites.dart';

class BitesSaveListPage extends StatefulWidget {
  final bool appBar;

  const BitesSaveListPage({super.key, this.appBar = true});

  @override
  State<BitesSaveListPage> createState() => _BitesSaveListPageState();
}

class _BitesSaveListPageState extends State<BitesSaveListPage> {
  BitesController bitesController = Get.put(BitesController());

  //String startDate = "2025-01-01";
  RxString endDate =
      DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()).obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      bitesController.isLoading(true);
      await bitesController.getListBites(
        startDate: DateFormat('yyyy-MM-dd 00:00:00')
            .format(DateTime.now().subtract(const Duration(days: 7))),
        endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
        dischargeStatus: "0",
      );
      // await bitesController.getBitesStingsDashboard(
      //   startDate: DateFormat('yyyy-MM-dd 00:00:00')
      //       .format(DateTime.now().subtract(const Duration(days: 7))),
      //   endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
      // );
      bitesController.isLoading(false);
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
    if (bitesController.ListData.isNotEmpty) {
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
                  ? Center(child: Text('Bites & Stings'))
                  : Text('Bites & Stings'),
            )
          : null,
      body: Obx(
        () => bitesController.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: context.isDesktop
                    ? EdgeInsets.all(14)
                    : EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    CommonDateRangePicker(
                      startDate: bitesController.bitesStartDate.value,
                      endDate: bitesController.bitesEndDate.value,
                      onApply: () async {
                        bitesController.isLoading(true);
                        await bitesController.getListBites(
                          startDate:
                              bitesController.bitesStartDate.value.toString(),
                          endDate:
                              bitesController.bitesEndDate.value.toString(),
                          dischargeStatus: "0",
                        );
                        // await bitesController.getBitesStingsDashboard(
                        //   startDate: bitesController.bitesStartDate.toString(),
                        //   endDate: bitesController.bitesEndDate.toString(),
                        // );
                        bitesController.searchText.value = "";
                        bitesController.isLoading(false);
                      },
                      onDateSelected: (start, end) {
                        bitesController.bitesStartDate.value = start;
                        bitesController.bitesEndDate.value = end;
                      },
                    ),
                    Space(
                      height: 12,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /* GridView.builder(
                              shrinkWrap: true,
                              // 🔹 Makes it take only as much height as needed
                              physics: const NeverScrollableScrollPhysics(),
                              // 🔹 Prevents scroll conflict with main scroll
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: context.isDesktop ? 7 : 3,
                                crossAxisSpacing: context.isDesktop ? 10 : 12,
                                mainAxisSpacing: context.isDesktop ? 10 : 12,
                                childAspectRatio: context.isDesktop ? 1.9 : 1.5,
                              ),
                              itemCount:
                                  bitesController.bitesStingsDataMap.length,
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
                                          bitesController
                                              .bitesStingsDataMap.keys
                                              .elementAt(index),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          bitesController
                                              .bitesStingsDataMap.values
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
                              initialValue: bitesController.searchText.value,
                              onChanged: (value) {
                                bitesController.searchText.value = value;
                                bitesController.getListBites(
                                  startDate:
                                      bitesController.bitesStartDate.toString(),
                                  endDate:
                                      bitesController.bitesEndDate.toString(),
                                  patientName: bitesController.searchText.value,
                                  dischargeStatus: "0",
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
                                                fontWeight: FontWeight.bold))),
                                    DataColumn2(
                                        size: ColumnSize.M,
                                        label: Text("TAEI ID",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    DataColumn2(
                                        size: ColumnSize.L,
                                        label: Text("Patient Name",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    DataColumn2(
                                        size: ColumnSize.L,
                                        label: Text("Create / Update",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    DataColumn2(
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
                                  rows: bitesController.ListData.map((bites) {
                                    Color? rowColor;

                                    switch (bites.triageFlag) {
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
                                            (((bitesController.bitesCurrentPage
                                                                .value -
                                                            1) *
                                                        bitesController
                                                            .bitesLimit) +
                                                    (bitesController.ListData
                                                        .indexOf(bites)) +
                                                    1)
                                                .toString(),
                                          ),
                                        ),
                                        DataCell(
                                            Text(bites.triageId.toString())),
                                        DataCell(
                                            Text(bites.nameOfPatient ?? '-')),
                                        DataCell(TableCommonButton(
                                            compact: false,
                                            label: bites.bitesStingsId != null
                                                ? "Update"
                                                : "Bites&Stings",
                                            icon: bites.bitesStingsId != null
                                                ? Icons.edit
                                                : Icons.add_business_rounded,
                                            color: bites.bitesStingsId != null
                                                ? Colors.green.shade700
                                                : Colors.redAccent.shade700,
                                            onTap: () async {
                                              bitesController
                                                  .dischargeStatus.value = "0";
                                              final isEdit =
                                                  bites.bitesStingsId != null;
                                              final result =
                                                  await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      BitesFormPage(
                                                    id: bites.bitesStingsId
                                                        ?.toString(),
                                                    triageId: bites.triageId
                                                        ?.toString(),
                                                  ),
                                                ),
                                              );
                                              if (result == true) {
                                                bitesController.getListBites(
                                                  startDate: bitesController
                                                      .bitesStartDate.value
                                                      .toString(),
                                                  endDate: bitesController
                                                      .bitesEndDate.value
                                                      .toString(),
                                                  dischargeStatus: "0",
                                                  patientName: bitesController
                                                      .searchText.value,
                                                );
                                              }
                                            })),
                                        DataCell(Text(
                                            bites.emergencyCategory ?? '-')),
                                        DataCell(
                                            Text(bites.modeOfArrival ?? '-')),
                                        DataCell(Text(bites.sceneIft ?? '-')),
                                        DataCell(Text(
                                            bites.presentingComplaint ?? '-')),
                                        DataCell(
                                            Text(bites.sourceHospital ?? '-')),
                                        DataCell(Text(
                                            bites.destinationHospital ?? '-')),
                                        DataCell(Text(bites.triageFlag ?? '-')),
                                        DataCell(TableCommonButton(
                                          compact: false,
                                          label: "View",
                                          onTap: () {
                                            Get.to(
                                              TriageEmoPillarsViewPage(
                                                from: 'Bites',
                                                triageId:
                                                    bites.triageId.toString(),
                                                pillarId: bites.bitesStingsId
                                                    .toString(),
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
                                  bitesController.bitesCurrentPage.value > 1
                                      ? () async {
                                          await bitesController.getListBites(
                                            startDate: bitesController
                                                .bitesStartDate.value
                                                .toString(),
                                            endDate: bitesController
                                                .bitesEndDate.value
                                                .toString(),
                                            pageNumber: bitesController
                                                    .bitesCurrentPage.value -
                                                1,
                                            patientName: bitesController
                                                .searchText.value,
                                            dischargeStatus: "0",
                                          );
                                        }
                                      : null,
                            ),
                            Text(
                              'Page ${bitesController.bitesCurrentPage.value} of ${bitesController.bitesTotalPages.value}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.chevron_right),
                              onPressed: bitesController
                                          .bitesCurrentPage.value <
                                      bitesController.bitesTotalPages.value
                                  ? () async {
                                      await bitesController.getListBites(
                                        startDate: bitesController
                                            .bitesStartDate.value
                                            .toString(),
                                        endDate: bitesController
                                            .bitesEndDate.value
                                            .toString(),
                                        pageNumber: bitesController
                                                .bitesCurrentPage.value +
                                            1,
                                        patientName:
                                            bitesController.searchText.value,
                                        dischargeStatus: "0",
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
      ),
    );
  }
}
