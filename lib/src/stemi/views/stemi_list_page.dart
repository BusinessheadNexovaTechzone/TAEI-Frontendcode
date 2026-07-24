import 'dart:convert';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/constants/constant.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/src/stemi/controller/stemi_controller.dart';
import 'package:taei_gov/src/stemi/form_page.dart';
import 'package:taei_gov/src/triage_emo_pillars_view/triage_emo_pillars_view_page.dart';
import 'package:taei_gov/utils/common/start_end_date_picker.dart';
import 'package:taei_gov/utils/common/table_common_button.dart';
import 'package:taei_gov/utils/helpers/local_data_helper.dart';
import 'package:taei_gov/utils/helpers/page_loader.dart';
import '../../../utils/common/space.dart';
import '../../../widgets/CommonSearchBar.dart';
import '../../login/models/user_model.dart';
import '../../nurse_triage/views/add_accident.dart';
import 'add_stemi.dart';

class StemiListPage extends StatefulWidget {
  final bool appBar;
   final int? discharge;

  const StemiListPage({super.key, this.appBar = true, this.discharge,});

  @override
  State<StemiListPage> createState() => _StemiListPageState();
}

class _StemiListPageState extends State<StemiListPage> {
  final StemiController stemiController = Get.put(StemiController());
  final TextEditingController searchController = TextEditingController();
  bool _isFocused = false;

  List<dynamic> filteredList = [];

  String startDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()
      .subtract(const Duration(days: 7))
      .copyWith(hour: 0, minute: 0, second: 0));
  String endDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

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
  void initState() {
    super.initState();
    userStress();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void didUpdateWidget(covariant StemiListPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If discharge value changed
    if (oldWidget.discharge != widget.discharge) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    stemiController.isLoading(true);

    final now = DateTime.now();

    final startDate =
    DateFormat('yyyy-MM-dd 00:00:00').format(now);
    final endDate =
    DateFormat('yyyy-MM-dd 23:59:59').format(now);

    await stemiController.getListStemi(
      startDate: startDate,
      endDate: endDate,
      dischargeStatus: widget.discharge ?? 1,
    );

    await stemiController.getStemiDashboard(
      startDate: startDate,
      endDate: endDate,
    );

    stemiController.isLoading(false);
  }

  // Future<void> _loadData() async {
  //   stemiController.isLoading(true);
  //   await stemiController.getListStemi(startDate: startDate, endDate: endDate);
  //   stemiController.isLoading(false);
  //
  //   filteredList =
  //       stemiController.stemiListData.expand((e) => e.rows ?? []).toList();
  // }

  void userStress() {
    String userJson = LocalDataHelper.getString(Constant.userDetails);
    if (userJson.isNotEmpty) {
      UserModel userDetails = UserModel.fromJson(jsonDecode(userJson));
      print("Hospital: ${userDetails.user?.hospital?.hospitalname}");
    }
  }

  // /// 🔍 Filter only by patient name
  // void _filterSearch(String query) {
  //   setState(() {
  //     if (query.isEmpty) {
  //       filteredList =
  //           stemiController.stemiListData.expand((e) => e.rows ?? []).toList();
  //     } else {
  //       filteredList = stemiController.stemiListData
  //           .expand((e) => e.rows ?? [])
  //           .where((row) => (row.nameOfPatient ?? '')
  //               .toLowerCase()
  //               .contains(query.toLowerCase().trim()))
  //           .toList();
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar
          ? AppBar(
              backgroundColor: Colors.redAccent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Get.back(),
              ),
              title: const Text('Stemi List'),
              centerTitle: true,
            )
          : null,
      body: Obx(
        () => stemiController.isLoading.value
            ? pageLoader()
            : Container(
                padding: context.isDesktop
                    ? EdgeInsets.all(18.0)
                    : EdgeInsets.all(2.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    spacing: 14,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CommonDateRangePicker(
                        startDate: stemiController.stemiStartDate.value,
                        endDate: stemiController.stemiEndDate.value,
                        onApply: () async {
                          stemiController.isLoading(true);
                          await stemiController.getListStemi(
                            startDate:
                                stemiController.stemiStartDate.toString(),
                            endDate: stemiController.stemiEndDate.toString(), dischargeStatus: widget.discharge!

                          );
                          await stemiController.getStemiDashboard(
                            startDate:
                                stemiController.stemiStartDate.toString(),
                            endDate: stemiController.stemiEndDate.toString(),
                          );
                          stemiController.isLoading(false);
                        },
                        onDateSelected: (start, end) {
                          stemiController.stemiStartDate.value = start;
                          stemiController.stemiEndDate.value = end;
                        },
                      ),

                      /// 🔹 Animated Search Bar
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Visibility(
                                visible:widget.discharge == 1?false:true,
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
                                  itemCount: stemiController.stemiDataMap.length,
                                  itemBuilder: (context, index) {
                                    final key = stemiController.stemiDataMap.keys
                                        .elementAt(index);
                                    final value = stemiController
                                        .stemiDataMap.values
                                        .elementAt(index);

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
                                              key,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              value,
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
                                initialValue: stemiController.searchText.value,
                                onChanged: (value) {
                                  stemiController.searchText.value = value;
                                },
                              ),
                              Space(
                                height: 10,
                              ),

                              /// 🔹 Data Table
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
                                        headingRowColor:
                                            WidgetStateProperty.all(
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
                                              label: Text("S.No")),
                                          DataColumn2(
                                              size: ColumnSize.M,
                                              label: Text("TAEI ID")),
                                          DataColumn2(
                                              label: Text("Mode Of Arrival")),
                                          DataColumn2(
                                              label: Text("Name of Patient")),
                                          DataColumn2(label: Text("Scene/IFT")),
                                          DataColumn2(label: Text("Create")),
                                          DataColumn2(label: Text("Emergency")),
                                          DataColumn2(
                                              label: Text("Source Hospital")),
                                          DataColumn2(
                                              label:
                                                  Text("Destination Hospital")),
                                          DataColumn2(label: Text("Status Id")),
                                          DataColumn2(
                                              label: Text("Triage Flag")),
                                          DataColumn2(label: Text("View")),
                                        ],
                                        rows: stemiController.filteredTraumaList
                                            .map<DataRow>((row) {
                                          Color? rowColor;
                                          switch (row.triageFlag) {
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
                                            color: MaterialStateProperty.all(
                                                rowColor),
                                            cells: [
                                              DataCell(
                                                Text(
                                                  (((stemiController.stemiCurrentPage
                                                                      .value -
                                                                  1) *
                                                              stemiController
                                                                  .stemiLimit) +
                                                          (stemiController
                                                                  .stemiListData
                                                                  .indexOf(
                                                                      row) ??
                                                              0) +
                                                          1)
                                                      .toString(),
                                                ),
                                              ),
                                              DataCell(Text(
                                                  row.triageId?.toString() ??
                                                      "-")),
                                              DataCell(Text(
                                                  row.modeOfArrival ?? "-")),
                                              DataCell(Text(
                                                  row.nameOfPatient ?? "-")),
                                              DataCell(
                                                  Text(row.sceneIft ?? "-")),
                                              DataCell(
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.blueAccent,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 16,
                                                        vertical: 8),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    if (row.stemiId == null) {
                                                      final result =
                                                          await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) =>
                                                              StemiFormPage(
                                                            triageDate: row
                                                                .dateTimeOfTriage
                                                                .toString(),
                                                            triageId: row
                                                                .triageId
                                                                .toString(),
                                                          ),
                                                        ),
                                                      );
                                                      if (result == true) {
                                                        stemiController
                                                            .stemiModel
                                                            .refresh();
                                                      }
                                                    } else {
                                                      final result =
                                                          await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              StemiFormPage(
                                                                  id: row
                                                                      .triageId
                                                                      .toString()),
                                                        ),
                                                      );
                                                      if (result == true)
                                                        stemiController
                                                            .getListStemi(
                                                                startDate:
                                                                    startDate,
                                                                endDate:
                                                                    endDate,
                                                            dischargeStatus: widget.discharge!

                                                        );
                                                    }
                                                  },
                                                  child: row.stemiId == null
                                                      ? const Text("Stemi")
                                                      : const Text("Update"),
                                                ),
                                              ),
                                              DataCell(Text(
                                                  row.emergencyCategory ??
                                                      "-")),
                                              DataCell(Text(
                                                  row.sourceHospital ?? "-")),
                                              DataCell(Text(
                                                  row.destinationHospital ??
                                                      "-")),
                                              DataCell(Text(
                                                  row.statusid?.toString() ??
                                                      "-")),
                                              DataCell(
                                                  Text(row.triageFlag ?? "-")),
                                              DataCell(TableCommonButton(
                                                compact: false,
                                                label: "View",
                                                onTap: () {
                                                  Get.to(
                                                    TriageEmoPillarsViewPage(
                                                      from: 'STEMI',
                                                      triageId: row.triageId
                                                          .toString(),
                                                      pillarId: row.stemiId
                                                          .toString(),
                                                    ),
                                                  );
                                                },
                                              )),
                                            ],
                                          );
                                        }).toList()),
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
                                    stemiController.stemiCurrentPage.value > 1
                                        ? () async {
                                            await stemiController.getListStemi(
                                              startDate: stemiController
                                                  .stemiStartDate.value
                                                  .toString(),
                                              endDate: stemiController
                                                  .stemiEndDate.value
                                                  .toString(),
                                              pageNumber: stemiController
                                                      .stemiCurrentPage.value -
                                                  1,
                                                dischargeStatus: widget.discharge!

                                            );
                                          }
                                        : null,
                              ),
                              Text(
                                'Page ${stemiController.stemiCurrentPage.value} of ${stemiController.stemiTotalPages.value}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: const Icon(Icons.chevron_right),
                                onPressed: stemiController
                                            .stemiCurrentPage.value <
                                        stemiController.stemiTotalPages.value
                                    ? () async {
                                        await stemiController.getListStemi(
                                          startDate: stemiController
                                              .stemiStartDate.value
                                              .toString(),
                                          endDate: stemiController
                                              .stemiEndDate.value
                                              .toString(),
                                          pageNumber: stemiController
                                                  .stemiCurrentPage.value +
                                              1,
                                            dischargeStatus: widget.discharge!

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
}
