import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:taei_gov/src/emo_user/controller/emo_controller.dart';
import 'package:taei_gov/src/emo_user/model/emo_model.dart';
import 'package:taei_gov/src/emo_user/view/emo_form.dart';
import 'package:taei_gov/src/nurse_triage/controller/pdf_generative_controller.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/src/triage_emo_pillars_view/triage_emo_pillars_view_page.dart';
import 'package:taei_gov/utils/common/common_button.dart';
import 'package:taei_gov/utils/common/space.dart';
import 'package:taei_gov/utils/common/start_end_date_picker.dart';
import 'package:taei_gov/utils/common/table_common_button.dart';
import 'package:taei_gov/widgets/CommonSearchBar.dart';

class EmoListPage extends StatefulWidget {
  final bool isFromHome;

  const EmoListPage({super.key, this.isFromHome = false});

  @override
  State<EmoListPage> createState() => _EmoListPageState();
}

class _EmoListPageState extends State<EmoListPage> {
  EmoController emoController = Get.put(EmoController());
  pdfController pdfControllerD = Get.put(pdfController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      emoController.isLoading(true);
      await emoController.getEmoListData(
        startDate: DateFormat('yyyy-MM-dd 00:00:00')
            .format(DateTime.now().subtract(Duration(days: 7))),
        endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
      );
      await emoController.fetchEmoDashboard(
        startDate: DateFormat('yyyy-MM-dd 00:00:00')
            .format(DateTime.now().subtract(Duration(days: 7))),
        endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
      );
      emoController.isLoading(false);
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
        appBar: widget.isFromHome
            ? null
            : AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Get.back(),
                ),
                backgroundColor: Colors.redAccent,
                title: context.isDesktop
                    ? Center(child: Text('Emo List'))
                    : Text('Emo List'),
              ),
        body: Obx(
          () => emoController.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: context.isDesktop
                      ? EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 8, bottom: 8)
                      : EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      CommonDateRangePicker(
                        startDate: emoController.emoStartDate.value,
                        endDate: emoController.emoEndDate.value,
                        onApply: () async {
                          emoController.isLoading(true);
                          await emoController.getEmoListData(
                            startDate:
                                emoController.emoStartDate.value.toString(),
                            endDate: emoController.emoEndDate.value.toString(),
                          );
                          await emoController.fetchEmoDashboard(
                            startDate: emoController.emoStartDate.toString(),
                            endDate: emoController.emoEndDate.toString(),
                          );
                          emoController.isLoading(false);
                          emoController.searchText.value = "";
                        },
                        onDateSelected: (start, end) {
                          emoController.emoStartDate.value = start;
                          emoController.emoEndDate.value = end;
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
                                itemCount: emoController.emoDataMap.length,
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
                                            emoController.emoDataMap.keys
                                                .elementAt(index),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            emoController.emoDataMap.values
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
                              SizedBox(
                                height: 16,
                              ),
                              NewCommonSearchField(
                                initialValue: emoController.searchText.value,
                                onChanged: (value) {
                                  emoController.searchText.value = value;
                                  emoController.getEmoListData(
                                    startDate: emoController.emoStartDate.value
                                        .toString(),
                                    endDate: emoController.emoEndDate.value
                                        .toString(),
                                    patientName: emoController.searchText.value,
                                    dischargeStatus: "",
                                  );
                                },
                              ),
                              SizedBox(
                                height: 16,
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
                                      fixedTopRows: 1,
                                      border: TableBorder.all(
                                        color: Colors.grey.shade300,
                                      ),
                                      columns: const [
                                        DataColumn2(
                                          size: ColumnSize.S,
                                          label: Text("S.No",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        DataColumn2(
                                          size: ColumnSize.S,
                                          label: Text("TAEI ID",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        DataColumn2(
                                          size: ColumnSize.S,
                                          label: Text("Patient Name",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        DataColumn2(
                                          label: Text("Create / Edit",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        DataColumn2(
                                          label: Text("Mode Of Arrival",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        DataColumn2(
                                          label: Text("Scene IFT",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        DataColumn2(
                                          label: Text("Medical Emergency",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        DataColumn2(
                                          label: Text("Surgical Emergency",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        DataColumn2(
                                          label: Text("View",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        DataColumn2(
                                          label: Text("Case Sheet",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                      rows: emoController.emoList
                                          .map<DataRow>((emo) {
                                        return DataRow(
                                          color: MaterialStateProperty.all(emo
                                                      .triageFlag ==
                                                  "Yellow"
                                              ? Colors.yellow
                                              : emo.triageFlag == "Red"
                                                  ? Colors.red
                                                  : emo.triageFlag == "Green"
                                                      ? Colors.green
                                                      : emo.triageFlag ==
                                                              "Black"
                                                          ? Colors.grey.shade700
                                                          : Colors.white),
                                          cells: [
                                            DataCell(
                                              Text(
                                                (((emoController.emoCurrentPage
                                                                    .value -
                                                                1) *
                                                            emoController
                                                                .emoLimit) +
                                                        emoController
                                                            .filteredEmoList
                                                            .indexOf(emo) +
                                                        1)
                                                    .toString(),
                                              ),
                                            ),
                                            DataCell(Text(
                                                emo.triageId?.toString() ??
                                                    "-")),
                                            DataCell(
                                                Text(emo.nameOfPatient ?? "-")),
                                            DataCell(TableCommonButton(
                                                compact: false,
                                                color: emo.emoId != null
                                                    ? Colors.green.shade700
                                                    : Colors.redAccent.shade700,
                                                label: emo.emoId != null
                                                    ? "Update"
                                                    : "Emo",
                                                icon: emo.emoId != null
                                                    ? Icons.edit
                                                    : Icons
                                                        .add_business_rounded,
                                                onTap: () {
                                                  if (emo.emoId == null) {
                                                    emoController
                                                        .emoModel(EmoModel(
                                                      emo: Emo(),
                                                      emoOutcome: EmoOutcome(),
                                                    ));
                                                    emoController
                                                        .currentIndex.value = 0;
                                                    Get.to(EmoForm(
                                                      id: emo.triageId
                                                          .toString(),
                                                      emoId:
                                                          emo.emoId.toString(),
                                                      isUpdate: false,
                                                      isAdult: emo.isAdult == 0
                                                          ? false
                                                          : true,
                                                    ));
                                                  } else {
                                                    emoController
                                                        .emoModel(EmoModel(
                                                      emo: Emo(),
                                                      emoOutcome: EmoOutcome(),
                                                    ));
                                                    emoController
                                                        .currentIndex.value = 0;
                                                    Get.to(EmoForm(
                                                      id: emo.triageId
                                                          .toString(),
                                                      emoId:
                                                          emo.emoId.toString(),
                                                      isUpdate: true,
                                                      isAdult: emo.isAdult == 0
                                                          ? false
                                                          : true,
                                                    ));
                                                  }
                                                })),
                                            DataCell(
                                                Text(emo.modeOfArrival ?? "-")),
                                            DataCell(Text(emo.sceneIft ?? "-")),
                                            DataCell(Text(
                                                emo.medicalEmergency ?? "-")),
                                            DataCell(Text(
                                                emo.surgicalEmergency ?? "-")),
                                            DataCell(
                                              TableCommonButton(
                                                compact: false,
                                                label: "View",
                                                onTap: () {
                                                  Get.to(
                                                    TriageEmoPillarsViewPage(
                                                      from: 'EMO',
                                                      triageId: emo.triageId
                                                          .toString(),
                                                      emoId: emo.emoId,
                                                      emo: emo.emoId == null
                                                          ? true
                                                          : false,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            DataCell(
                                              Obx(() {
                                                final isLoading = pdfControllerD
                                                        .downloadingId.value ==
                                                    emo.triageId.toString();

                                                return Row(
                                                  children: [
                                                    IconButton(
                                                      icon:Image.asset(
                                                        'assets/icons/download_icon.png',
                                                        width: 34,
                                                        height: 34,
                                                        // color: ,
                                                        filterQuality: FilterQuality.high,

                                                      ),
                                                      onPressed:(){

                                                      }
                                                    ),
                                                    SizedBox(width: 2,),
                                                    IconButton(
                                                      icon: isLoading
                                                          ? const SizedBox(
                                                        width: 20,
                                                        height: 20,
                                                        child: CircularProgressIndicator(strokeWidth: 2),
                                                      )
                                                          : emo.emoId == null?Image.asset(
                                                        'assets/logo/Red.png',
                                                        width: 34,
                                                        height: 34,
                                                      ):Image.asset(
                                                        'assets/logo/green_1.png',
                                                        width: 34,
                                                        height: 34,
                                                      ),
                                                      onPressed: isLoading
                                                          ? null
                                                          : () {
                                                        emo.emoId == null?null:
                                                            pdfControllerD.downloadFullCasePdf(
                                                          id: emo.triageId.toString(),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                );
                                              }),
                                            ),
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
                                onPressed: emoController.emoCurrentPage.value >
                                        1
                                    ? () async {
                                        await emoController.getEmoListData(
                                          startDate: emoController
                                              .emoStartDate.value
                                              .toString(),
                                          endDate: emoController
                                              .emoEndDate.value
                                              .toString(),
                                          pageNumber: emoController
                                                  .emoCurrentPage.value -
                                              1,
                                          patientName:
                                              emoController.searchText.value,
                                          dischargeStatus: "",
                                        );
                                      }
                                    : null,
                              ),
                              Text(
                                'Page ${emoController.emoCurrentPage.value} of ${emoController.emoTotalPages.value}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: const Icon(Icons.chevron_right),
                                onPressed: emoController.emoCurrentPage.value <
                                        emoController.emoTotalPages.value
                                    ? () async {
                                        await emoController.getEmoListData(
                                          startDate: emoController
                                              .emoStartDate.value
                                              .toString(),
                                          endDate: emoController
                                              .emoEndDate.value
                                              .toString(),
                                          pageNumber: emoController
                                                  .emoCurrentPage.value +
                                              1,
                                          patientName:
                                              emoController.searchText.value,
                                          dischargeStatus: "",
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
