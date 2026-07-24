import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/src/emo_user/model/emo_model.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/src/stemi/form_page.dart';
import 'package:taei_gov/src/trauma/controller/trauma_controller.dart';
import 'package:taei_gov/src/trauma/model/trauma_model.dart';
import 'package:taei_gov/src/trauma/views/add_trauma.dart';
import 'package:taei_gov/src/triage_emo_pillars_view/triage_emo_pillars_view_page.dart';
import 'package:taei_gov/utils/common/common_button.dart';
import 'package:taei_gov/utils/common/space.dart';
import 'package:taei_gov/utils/common/start_end_date_picker.dart';
import 'package:taei_gov/utils/common/table_common_button.dart';
import 'package:taei_gov/widgets/CommonSearchBar.dart';

class TraumaSaveListPage extends StatefulWidget {
  final bool appBar;

  const TraumaSaveListPage({super.key, this.appBar = true});

  @override
  State<TraumaSaveListPage> createState() => _TraumaSaveListPageState();
}

class _TraumaSaveListPageState extends State<TraumaSaveListPage> {
  TraumaController traumaController = Get.put(TraumaController());

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   traumaController.getTraumaList();
  //   super.initState();
  // }

  void initState() {
    super.initState();
    // Defer calling until after build
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      traumaController.isLoading(true);
      await traumaController.getTraumaList(
        startDate: DateFormat('yyyy-MM-dd 00:00:00')
            .format(DateTime.now().subtract(Duration(days: 7))),
        endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
        dischargeStatus: "0",
      );

      traumaController.isLoading(false);
    });
  }

  final List<List<Color>> gradients = [
    [Colors.blue, Colors.blueAccent],
    [Colors.red, Colors.redAccent],
    [Colors.yellow.shade900, Colors.yellow.shade900],
    [Colors.green, Colors.greenAccent],
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
                  ? Center(child: Text("Trauma"))
                  : Text('Trauma'),
            )
          : null,
      body: Obx(
        () => traumaController.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: context.isDesktop
                    ? EdgeInsets.all(18.0)
                    : EdgeInsets.all(2.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      CommonDateRangePicker(
                        startDate: traumaController.traumaStartDate.value,
                        endDate: traumaController.traumaEndDate.value,
                        onApply: () async {
                          traumaController.isLoading(true);
                          await traumaController.getTraumaList(
                            startDate:
                                traumaController.traumaStartDate.toString(),
                            endDate: traumaController.traumaEndDate.toString(),
                            dischargeStatus: "0",
                          );
                          traumaController.searchText.value = "";
                          traumaController.isLoading(false);
                        },
                        onDateSelected: (start, end) {
                          traumaController.traumaStartDate.value = start;
                          traumaController.traumaEndDate.value = end;
                        },
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Space(
                                height: 10,
                              ),
                              NewCommonSearchField(
                                initialValue: traumaController.searchText.value,
                                onChanged: (value) {
                                  traumaController.searchText.value = value;
                                  traumaController.getTraumaList(
                                    startDate: traumaController
                                        .traumaStartDate.value
                                        .toString(),
                                    endDate: traumaController
                                        .traumaEndDate.value
                                        .toString(),
                                    patientName:
                                        traumaController.searchText.value,
                                    dischargeStatus: "0",
                                  );
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
                                      horizontalMargin: 30,
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
                                            size: ColumnSize.S,
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
                                            label: Text("Handed Over",
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
                                            size: ColumnSize.L,
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
                                      rows: traumaController.traumaList
                                          .map<DataRow>((caseData) {
                                        return DataRow(
                                          color: MaterialStateProperty.all(
                                              caseData.triageFlag == 'Yellow'
                                                  ? Colors.yellow
                                                  : caseData.triageFlag == 'Red'
                                                      ? Colors.red
                                                      : caseData.triageFlag ==
                                                              'Green'
                                                          ? Colors.green
                                                          : caseData.triageFlag ==
                                                                  'Black'
                                                              ? Colors
                                                                  .grey.shade700
                                                              : Colors.white),
                                          cells: [
                                            DataCell(
                                              Text(
                                                (((traumaController.traumaCurrentPage
                                                                    .value -
                                                                1) *
                                                            traumaController
                                                                .traumaLimit) +
                                                        (traumaController
                                                                .traumaList
                                                                .indexOf(
                                                                    caseData) ??
                                                            0) +
                                                        1)
                                                    .toString(),
                                              ),
                                            ),
                                            DataCell(Text(
                                                caseData.triageId?.toString() ??
                                                    "-")),
                                            DataCell(Text(
                                                caseData.nameOfPatient ?? "-")),
                                            DataCell(TableCommonButton(
                                                compact: false,
                                                label: caseData.traumaId != null
                                                    ? "Update"
                                                    : "Trauma",
                                                icon: caseData.traumaId != null
                                                    ? Icons.edit
                                                    : Icons
                                                        .add_business_rounded,
                                                color: caseData.traumaId != null
                                                    ? Colors.green.shade700
                                                    : Colors.redAccent.shade700,
                                                onTap: () {
                                                  if (caseData.traumaId ==
                                                      null) {
                                                    traumaController.trauma(
                                                      TraumaModel(
                                                        trauma: Trauma(),
                                                        traumaFinal:
                                                            TraumaFinal(),
                                                        traumaValues:
                                                            TraumaValues(),
                                                        traumaOutcome:
                                                            TraumaOutcome(),
                                                      ),
                                                    );
                                                    traumaController
                                                        .currentIndex.value = 0;
                                                    traumaController
                                                        .dischargeStatus
                                                        .value = "0";
                                                    traumaController
                                                            .trauma
                                                            .value
                                                            .traumaFinal
                                                            ?.surgeryTakenupFromTriageDate =
                                                        calculatePositiveDays(
                                                            caseData
                                                                .dateTimeOfTriage);

                                                    traumaController
                                                            .trauma
                                                            .value
                                                            .traumaFinal
                                                            ?.surgeryTakenupFromIncidentDate =
                                                        calculatePositiveDays(
                                                            caseData
                                                                .dateAndTimeOfIncident);
                                                    Get.to(AddTrauma(
                                                      triageId: caseData
                                                          .triageId
                                                          .toString(),
                                                      traumaId: caseData
                                                          .traumaId
                                                          .toString(),
                                                      isUpdate: false,
                                                    ));
                                                  } else {
                                                    traumaController.trauma(
                                                      TraumaModel(
                                                        trauma: Trauma(),
                                                        traumaFinal:
                                                            TraumaFinal(),
                                                        traumaValues:
                                                            TraumaValues(),
                                                        traumaOutcome:
                                                            TraumaOutcome(),
                                                      ),
                                                    );
                                                    traumaController
                                                        .currentIndex.value = 0;
                                                    traumaController
                                                        .dischargeStatus
                                                        .value = "0";
                                                    Get.to(AddTrauma(
                                                      triageId: caseData
                                                          .triageId
                                                          .toString(),
                                                      traumaId: caseData
                                                          .traumaId
                                                          .toString(),
                                                      dateTimeOfTriage: caseData
                                                          .dateTimeOfTriage,
                                                      dateAndTimeOfIncident:
                                                          caseData
                                                              .dateAndTimeOfIncident,
                                                      isUpdate: true,
                                                      dischargeStatus: "0",
                                                    ));
                                                  }
                                                })),
                                            DataCell(Text(
                                                caseData.ddd?.toString() ??
                                                    "-")),
                                            DataCell(Text(
                                                caseData.modeOfArrival ?? "-")),
                                            DataCell(
                                                Text(caseData.sceneIft ?? "-")),
                                            DataCell(Text(
                                                caseData.emergencyCategory ??
                                                    "-")),
                                            DataCell(Text(
                                                caseData.presentingComplaint ??
                                                    "-")),
                                            DataCell(Text(
                                                caseData.sourceHospital ??
                                                    "-")),
                                            DataCell(Text(
                                                caseData.destinationHospital ??
                                                    "-")),
                                            DataCell(Text(
                                                caseData.triageFlag ?? "-")),
                                            DataCell(TableCommonButton(
                                                compact: false,
                                                label: "View",
                                                onTap: () {
                                                  Get.to(
                                                      TriageEmoPillarsViewPage(
                                                          from: 'Trauma',
                                                          pillarId: caseData
                                                              .traumaId
                                                              .toString(),
                                                          triageId: caseData
                                                              .triageId
                                                              .toString()));
                                                })),
                                          ],
                                        );
                                      }).toList(),
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
                                onPressed: traumaController
                                            .traumaCurrentPage.value >
                                        1
                                    ? () async {
                                        await traumaController.getTraumaList(
                                          startDate: traumaController
                                              .traumaStartDate.value
                                              .toString(),
                                          endDate: traumaController
                                              .traumaEndDate.value
                                              .toString(),
                                          pageNumber: traumaController
                                                  .traumaCurrentPage.value -
                                              1,
                                          patientName:
                                              traumaController.searchText.value,
                                          dischargeStatus: "0",
                                        );
                                      }
                                    : null,
                              ),
                              Text(
                                'Page ${traumaController.traumaCurrentPage.value} of ${traumaController.traumaTotalPages.value}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: const Icon(Icons.chevron_right),
                                onPressed: traumaController
                                            .traumaCurrentPage.value <
                                        traumaController.traumaTotalPages.value
                                    ? () async {
                                        await traumaController.getTraumaList(
                                          startDate: traumaController
                                              .traumaStartDate.value
                                              .toString(),
                                          endDate: traumaController
                                              .traumaEndDate.value
                                              .toString(),
                                          pageNumber: traumaController
                                                  .traumaCurrentPage.value +
                                              1,
                                          patientName:
                                              traumaController.searchText.value,
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
      ),
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
