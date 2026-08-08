import 'dart:async';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/src/burn/view/burns_details_page.dart';
import 'package:taei_gov/src/prem/controller/prem_controller.dart';
import 'package:taei_gov/src/prem/model/prem_detail.dart';
import 'package:taei_gov/src/prem/view/prem_form.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/src/trauma/views/trauma_details_page.dart';
import 'package:taei_gov/src/triage_emo_pillars_view/triage_emo_pillars_view_page.dart';
import 'package:taei_gov/utils/common/table_common_button.dart';
import 'package:taei_gov/widgets/CommonSearchBar.dart';
import '../../../utils/common/start_end_date_picker.dart';
import '../../../utils/helpers/space.dart';
import 'prem_detailPage.dart';

class PremListPage extends StatefulWidget {
  final bool appBar;

  const PremListPage({super.key, this.appBar = true});

  @override
  State<PremListPage> createState() => _PremListPageState();
}

class _PremListPageState extends State<PremListPage> {
  PremController premController = Get.put(PremController());
  final TextEditingController searchController = TextEditingController();

  List<dynamic> filteredList = [];

  bool _isFocused = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      premController.isLoading(true);
      await premController.getPremList(
        startDate: DateFormat('yyyy-MM-dd 00:00:00')
            .format(DateTime.now().subtract(Duration(days: 7))),
        endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
        dischargeStatus: "2",
      );
      await premController.getPremDashboard(
        startDate: DateFormat('yyyy-MM-dd 00:00:00')
            .format(DateTime.now().subtract(Duration(days: 7))),
        endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
      );
      premController.isLoading(false);
      filteredList = List.from(premController.ListData);
      setState(() {});
    });
  }

  /// ✅ Local search filter (by patient name)
  void _filterSearch(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      setState(() {
        if (query.isEmpty) {
          filteredList = List.from(premController.ListData);
        } else {
          filteredList = premController.ListData.where((item) {
            final name = (item.nameOfPatient ?? '').toLowerCase();
            return name.contains(query.toLowerCase().trim());
          }).toList();
        }
      });
    });
  }

  final List<List<Color>> gradients = [
    [Colors.blue, Colors.blueAccent],
    [Colors.green, Colors.lightGreen],
    [Colors.red, Colors.orange],
    [Colors.purple, Colors.deepPurple],
    [Colors.teal, Colors.cyan],
    [Colors.red, Colors.pinkAccent],
    [Colors.yellow, Colors.amber],
    [Colors.indigo, Colors.indigoAccent],
    [Colors.brown, Colors.brown.shade400]
  ];

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
              title: const Text('Prem'),
              centerTitle: true,
            )
          : null,
      body: Obx(
        () => premController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: context.isDesktop
                    ? const EdgeInsets.all(18)
                    : const EdgeInsets.all(8),
                child: Column(
                  spacing: context.isDesktop ? 16 : 10,
                  children: [
                    CommonDateRangePicker(
                      startDate: premController.premStartDate.value,
                      endDate: premController.premEndDate.value,
                      onApply: () async {
                        premController.isLoading(true);
                        await premController.getPremList(
                          startDate: premController.premStartDate.toString(),
                          endDate: premController.premEndDate.toString(),
                          dischargeStatus: "2",
                        );
                        await premController.getPremDashboard(
                          startDate: premController.premStartDate.toString(),
                          endDate: premController.premEndDate.toString(),
                        );
                        premController.searchText.value = "";
                        premController.isLoading(false);
                        //  filteredList = List.from(premController.ListData);
                        //setState(() {});
                      },
                      onDateSelected: (start, end) {
                        premController.premStartDate.value = start;
                        premController.premEndDate.value = end;
                      },
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// 🔹 Dashboard Cards
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: context.isDesktop ? 7 : 3,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: context.isDesktop ? 1.9 : 1.4,
                              ),
                              itemCount: premController.premDataMap.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                      colors:
                                          gradients[index % gradients.length],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 6,
                                          offset: Offset(2, 4))
                                    ],
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          premController.premDataMap.keys
                                              .elementAt(index),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          premController.premDataMap.values
                                              .elementAt(index),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20),
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
                              initialValue: premController.searchText.value,
                              onChanged: (value) {
                                premController.searchText.value = value;
                                premController.getPremList(
                                  startDate:
                                      premController.premStartDate.toString(),
                                  endDate:
                                      premController.premEndDate.toString(),
                                  patientName: premController.searchText.value,
                                  dischargeStatus: "2",
                                );
                              },
                            ),
                            Space(
                              height: 10,
                            ),

                            /// 🔹 Data Table (Uses filteredList)
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
                                          label: Text("S.No.",
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
                                          size: ColumnSize.L,
                                          label: Text("Patient Name",
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
                                          size: ColumnSize.L,
                                          label: Text("Emergency Category",
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
                                          label: Text("Scene/IFT",
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      DataColumn2(
                                          size: ColumnSize.L,
                                          label: Text("Chief Complaint",
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
                                    rows: premController.premList
                                        .map<DataRow>((premlist) {
                                      Color? rowColor;
                                      switch (premlist.triageFlag) {
                                        case 'Red':
                                          rowColor = Colors.red;
                                          break;
                                        case 'Yellow':
                                          rowColor = Colors.yellow.shade700;
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
                                              (((premController.premCurrentPage
                                                                  .value -
                                                              1) *
                                                          premController
                                                              .premLimit) +
                                                      (premController.premList
                                                          .indexOf(premlist)) +
                                                      1)
                                                  .toString(),
                                            ),
                                          ),
                                          DataCell(Text(
                                              premlist.triageId.toString())),
                                          DataCell(Text(
                                              premlist.nameOfPatient ?? '-')),
                                          DataCell(
                                            GestureDetector(
                                              onTap: () {
                                                if (premlist
                                                        .emergencyCategory ==
                                                    "PREM -Trauma") {
                                                  Get.to(TraumaDetailsPage(
                                                    triageId: premlist.triageId
                                                        .toString(),
                                                  ));
                                                } else if (premlist
                                                        .emergencyCategory ==
                                                    "PREM Burns") {
                                                  Get.to(BurnsDetailsPage(
                                                    triageId: premlist.triageId
                                                        .toString(),
                                                  ));
                                                } else {
                                                  premController.dischargeStatus
                                                      .value = "";
                                                  Get.to(() => PremFormPage(
                                                        id: premlist.premId
                                                            ?.toString(),
                                                        triageId: premlist
                                                            .triageId
                                                            ?.toString(),
                                                      ));
                                                }
                                              },
                                              child: Container(
                                                height: 35,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16),
                                                decoration: BoxDecoration(
                                                  color: premlist.premId != null
                                                      ? Colors.green
                                                      : Colors.redAccent,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                        color: Colors.black26,
                                                        blurRadius: 4,
                                                        offset: Offset(0, 2))
                                                  ],
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  _getButtonLabel(premlist),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                          DataCell(Text(
                                              premlist.emergencyCategory ??
                                                  '-')),
                                          DataCell(Text(
                                              premlist.modeOfArrival ?? '-')),
                                          DataCell(
                                              Text(premlist.sceneIft ?? '-')),
                                          DataCell(Text(
                                              premlist.presentingComplaint ??
                                                  '-')),
                                          DataCell(Text(
                                              premlist.sourceHospital ?? '-')),
                                          DataCell(Text(
                                              premlist.destinationHospital ??
                                                  '-')),
                                          DataCell(
                                              Text(premlist.triageFlag ?? '-')),
                                          // DataCell(Text(premlist.triageFlag ?? '-')),

                                          DataCell(TableCommonButton(
                                            compact: false,
                                            label: "View",
                                            onTap: () {
                                              Get.to(
                                                TriageEmoPillarsViewPage(
                                                  from: 'Prem',
                                                  triageId: premlist.triageId
                                                      .toString(),
                                                  pillarId: premlist.premId
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
                              onPressed:
                                  premController.premCurrentPage.value > 1
                                      ? () async {
                                          await premController.getPremList(
                                            startDate: premController
                                                .premStartDate.value
                                                .toString(),
                                            endDate: premController
                                                .premEndDate.value
                                                .toString(),
                                            pageNumber: premController
                                                    .premCurrentPage.value -
                                                1,
                                            patientName:
                                                premController.searchText.value,
                                            dischargeStatus: "2",
                                          );
                                        }
                                      : null,
                            ),
                            Text(
                              'Page ${premController.premCurrentPage.value} of ${premController.premTotalPages.value}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.chevron_right),
                              onPressed: premController.premCurrentPage.value <
                                      premController.premTotalPages.value
                                  ? () async {
                                      await premController.getPremList(
                                        startDate: premController
                                            .premStartDate.value
                                            .toString(),
                                        endDate: premController
                                            .premEndDate.value
                                            .toString(),
                                        pageNumber: premController
                                                .premCurrentPage.value +
                                            1,
                                        patientName:
                                            premController.searchText.value,
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
      ),
    );
  }

  String _getButtonLabel(dynamic premlist) {
    if (premlist.emergencyCategory == "PREM -Trauma") {
      return "View Trauma";
    } else if (premlist.emergencyCategory == "PREM Burns") {
      return "View Burns";
    } else {
      return premlist.premId != null ? "Update PREM" : "Create PREM";
    }
  }

  Color _getButtonColor(dynamic premlist) {
    if (premlist.emergencyCategory == "PREM -Trauma" ||
        premlist.emergencyCategory == "PREM Burns") {
      return Colors.blueAccent; // view details type
    } else {
      return premlist.premId != null ? Colors.green : Colors.redAccent;
    }
  }
}
