// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:taei_gov/src/report_dashboard/controller/entry_dashboard_controller.dart';

// import '../../../../utils/common/common_drop_down.dart';
// import '../../../../utils/common/space.dart';
// import '../../../../utils/common/start_end_date_picker.dart';
// import '../../../../utils/helpers/excel_helper.dart';
// import '../../../../utils/helpers/no_data_widget.dart';
// import '../../../../utils/helpers/page_loader.dart';

// class PatientReportScreen extends StatefulWidget {
//   @override
//   State<PatientReportScreen> createState() => _PatientReportScreenState();
// }

// class _PatientReportScreenState extends State<PatientReportScreen> {
//   final controller = Get.put(EntryDashboardController());

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   fetchData() async {
//     controller.fromDate.value =
//         DateTime.now().subtract(const Duration(days: 6));
//     controller.toDate.value = DateTime.now();
//     Future.wait([
//       controller.getData(),
//       controller.getPatientReport(),
//     ]);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Obx(() {
//         if (controller.isPatientReportLoading.value ||
//             controller.isLoading.value) {
//           return pageLoader();
//         }

//         final dataList = controller.patientReportData.value?.data ?? [];

//         // if (dataList.isEmpty) {
//         //   return Column(
//         //     children: [
//         //       CommonDateRangePicker(
//         //         startDate: controller.fromDate.value,
//         //         endDate: controller.toDate.value,
//         //         onApply: () async {
//         //           await controller.getPatientReport();
//         //         },
//         //         onDateSelected: (start, end) {
//         //           controller.fromDate.value = start;
//         //           controller.toDate.value = end;
//         //         },
//         //       ),
//         //       const SizedBox(height: 200),
//         //       noDataWidget(msg: "No Records Found"),
//         //     ],
//         //   );
//         // }

//         /// Extract table headers
//         List<String> keys = [];
//         if (dataList.isNotEmpty) {
//           keys = dataList.first.toJson().keys.toList();
//         }

//         return LayoutBuilder(
//           builder: (context, constraints) {
//             final bool isDesktop = constraints.maxWidth > 700;

//             return SingleChildScrollView(
//               child: Padding(
//                 padding: EdgeInsets.all(isDesktop ? 30 : 12),
//                 child: Column(
//                   children: [
//                     Space(height: 20),
//                     NewTitleDropdown(
//                         title: 'Report Type',
//                         hint: 'Select Type',
//                         items: controller.dk.toList(),
//                         selectedId: controller.patientReportType.value,
//                         onChanged: (value) async {
//                           controller.patientReportType.value = value!;
//                           await controller.getPatientReport();
//                         }),
//                     Space(height: 20),

//                     /// Date Range Picker
//                     CommonDateRangePicker(
//                       startDate: controller.fromDate.value,
//                       endDate: controller.toDate.value,
//                       onApply: () async {
//                         await controller.getPatientReport();
//                       },
//                       onDateSelected: (start, end) {
//                         controller.fromDate.value = start;
//                         controller.toDate.value = end;
//                       },
//                     ),
//                     if (dataList.isNotEmpty)
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           ElevatedButton(
//                               onPressed: () {
//                                 ExcelDownloadHelper.downloadExcel(
//                                     fileName: "Patient_report.xlsx",
//                                     headers: keys,
//                                     data: dataList
//                                         .map((e) => e.toJson())
//                                         .toList());
//                               },
//                               child: Text("Download"))
//                         ],
//                       ),
//                     Space(height: 20),

//                     Text(
//                       "Patient Entry Dashboard",
//                       style: TextStyle(
//                         fontSize: isDesktop ? 24 : 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),

//                     Space(height: 20),

//                     dataList.isEmpty
//                         ? SizedBox(
//                             height: 100,
//                             child: noDataWidget(msg: "No Records Found"))
//                         : Container(
//                             margin: EdgeInsets.all(isDesktop ? 20 : 10),
//                             padding: EdgeInsets.all(isDesktop ? 20 : 10),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(14),
//                               boxShadow: const [
//                                 BoxShadow(
//                                   color: Colors.black12,
//                                   blurRadius: 4,
//                                   offset: Offset(0, 2),
//                                 )
//                               ],
//                             ),
//                             child: SingleChildScrollView(
//                               scrollDirection: Axis.horizontal,
//                               child: DataTable(
//                                 dataRowMinHeight: 48,
//                                 dataRowMaxHeight: 55,
//                                 headingRowHeight: 55,
//                                 headingRowColor: WidgetStateProperty.all(
//                                     Colors.orange.shade100),
//                                 border: TableBorder.all(
//                                     color: Colors.grey.shade300),
//                                 columnSpacing: isDesktop ? 40 : 20,

//                                 /// ------------------ TABLE COLUMNS ------------------
//                                 columns: [
//                                   const DataColumn(
//                                     // S.No column
//                                     label: Text(
//                                       "S.NO",
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                   ...keys.map<DataColumn>((key) {
//                                     return DataColumn(
//                                       label: Text(
//                                         key.replaceAll("_", " ").toUpperCase(),
//                                         style: TextStyle(
//                                           fontSize: isDesktop ? 15 : 13,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     );
//                                   }).toList(),
//                                 ],

//                                 /// ------------------ TABLE ROWS ------------------
//                                 rows: [
//                                   /// Data rows
//                                   ...dataList
//                                       .asMap()
//                                       .entries
//                                       .map<DataRow>((entry) {
//                                     int index = entry.key;
//                                     var item = entry.value;
//                                     final map = item.toJson();

//                                     return DataRow(
//                                       cells: [
//                                         /// S.No Cell
//                                         DataCell(Text(
//                                           (index + 1).toString(),
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: isDesktop ? 14 : 12),
//                                         )),

//                                         /// Other cells
//                                         ...keys.map<DataCell>((key) {
//                                           return DataCell(
//                                             Text(
//                                               map[key]?.toString() ?? "-",
//                                               style: TextStyle(
//                                                 fontSize: isDesktop ? 14 : 12,
//                                               ),
//                                             ),
//                                           );
//                                         }).toList(),
//                                       ],
//                                     );
//                                   }).toList(),

//                                   /// ------------------ TOTAL ROW ------------------
//                                   // DataRow(
//                                   //   color: WidgetStateProperty.all(
//                                   //     Colors.yellow.shade200,
//                                   //   ),
//                                   //   cells: [
//                                   //     /// "Total" in S.No Column
//                                   //     const DataCell(
//                                   //       Text(
//                                   //         "TOTAL",
//                                   //         style: TextStyle(
//                                   //           fontWeight: FontWeight.bold,
//                                   //         ),
//                                   //       ),
//                                   //     ),

//                                   //     /// Total values for each column
//                                   //     ...keys.map<DataCell>((key) {
//                                   //       final totalValue = columnTotals[key];

//                                   //       return DataCell(
//                                   //         Text(
//                                   //           (totalValue == null || totalValue == 0)
//                                   //               ? "-"
//                                   //               : totalValue.toString(),
//                                   //           style: TextStyle(
//                                   //             fontWeight: FontWeight.bold,
//                                   //             fontSize: isDesktop ? 15 : 13,
//                                   //           ),
//                                   //         ),
//                                   //       );
//                                   //     }).toList(),
//                                   //   ],
//                                   // ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }
// }
