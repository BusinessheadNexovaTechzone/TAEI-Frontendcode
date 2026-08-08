// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../../utils/common/common_drop_down.dart';
// import '../../../utils/common/space.dart';
// import '../../../utils/common/start_end_date_picker.dart';
// import '../../../utils/helpers/no_data_widget.dart';
// import '../../../utils/helpers/page_loader.dart';
// import '../controller/report_dashboard_controller.dart';

// class BiteTableScreen extends StatefulWidget {
//   @override
//   State<BiteTableScreen> createState() => _BiteTableScreenState();
// }

// class _BiteTableScreenState extends State<BiteTableScreen> {
//   final controller = Get.find<ReportDashboardController>();

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   Future<void> fetchData() async {
//     controller.fromDate.value = DateTime.now().subtract(Duration(days: 6));
//     controller.toDate.value = DateTime.now();
//     await Future.wait([controller.getData(), controller.getInstitutionById()])
//         .then((v) {
//       controller.selectedInstitution.value =
//           controller.institutionData.isNotEmpty
//               ? controller.institutionData.first.hospitalid
//               : 0;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bool isDesktop = MediaQuery.of(context).size.width > 700;

//     return Scaffold(
//       body: Obx(
//         () {
//           if (controller.isDataLoading.value) {
//             return pageLoader();
//           }

//           final dataList = controller.byteData;

//           if (dataList.isEmpty) {
//             return Column(
//               children: [
//                 Space(
//                   height: 20,
//                 ),

//                 /// DATE RANGE PICKER
//                 CommonDateRangePicker(
//                   startDate: controller.fromDate.value,
//                   endDate: controller.toDate.value,
//                   onApply: () async {
//                     controller.reportType(6);
//                     await controller.getData();
//                   },
//                   onDateSelected: (start, end) {
//                     controller.fromDate.value = start;
//                     controller.toDate.value = end;
//                   },
//                 ),
//                 Row(
//                   children: [
//                     SizedBox(
//                       width: isDesktop ? 500 : double.infinity,
//                       child: NewTitleDropdown(
//                           title: 'Institution',
//                           hint: 'Select Institution',
//                           items: controller.institutionData
//                               .map((f) => f.toJson())
//                               .toList(),
//                           selectedId: controller.selectedInstitution.value,
//                           onChanged: (value) async {
//                             controller.selectedInstitution.value = value!;
//                             await controller.getData();
//                           }),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 200),
//                 noDataWidget(msg: "No Records Found"),
//               ],
//             );
//           }

//           final keys = dataList.first.toJson().keys.toList();

//           return LayoutBuilder(
//             builder: (context, constraints) {
//               final bool isDesktop = constraints.maxWidth > 700;

//               return SingleChildScrollView(
//                 child: Padding(
//                   padding: EdgeInsets.all(isDesktop ? 30 : 12),
//                   child: Column(
//                     children: [
//                       /// DATE RANGE PICKER
//                       CommonDateRangePicker(
//                         startDate: controller.fromDate.value,
//                         endDate: controller.toDate.value,
//                         onApply: () async {
//                           controller.reportType(6);
//                           await controller.getData();
//                         },
//                         onDateSelected: (start, end) {
//                           controller.fromDate.value = start;
//                           controller.toDate.value = end;
//                         },
//                       ),

//                       SizedBox(
//                         width: isDesktop ? 500 : double.infinity,
//                         child: NewTitleDropdown(
//                             title: 'Institution',
//                             hint: 'Select Institution',
//                             items: controller.institutionData
//                                 .map((f) => f.toJson())
//                                 .toList(),
//                             selectedId: controller.selectedInstitution.value,
//                             onChanged: (value) async {
//                               controller.selectedInstitution.value = value!;
//                               await controller.getData();
//                             }),
//                       ),
//                       Space(height: 20),

//                       Text(
//                         "Bytes & Stings Summary",
//                         style: TextStyle(
//                           fontSize: isDesktop ? 24 : 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),

//                       Space(height: 20),

//                       Container(
//                         padding: EdgeInsets.all(isDesktop ? 20 : 10),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(14),
//                           boxShadow: const [
//                             BoxShadow(
//                               color: Colors.black12,
//                               blurRadius: 4,
//                               offset: Offset(0, 2),
//                             )
//                           ],
//                         ),
//                         child: SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: DataTable(
//                             headingRowColor: WidgetStateProperty.all(
//                               Colors.orange.shade100,
//                             ),
//                             border:
//                                 TableBorder.all(color: Colors.grey.shade300),
//                             columnSpacing: isDesktop ? 40 : 20,
//                             headingRowHeight: isDesktop ? 60 : 55,
//                             dataRowMinHeight: isDesktop ? 55 : 45,
//                             columns: keys
//                                 .map(
//                                   (key) => DataColumn(
//                                     label: Text(
//                                       key.replaceAll("_", " ").toUpperCase(),
//                                       style: TextStyle(
//                                         fontSize: isDesktop ? 15 : 13,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                                 .toList(),
//                             rows: dataList.map((item) {
//                               final map = item.toJson();
//                               return DataRow(
//                                 cells: keys
//                                     .map((key) => DataCell(
//                                           Text(
//                                             map[key]?.toString() ?? "-",
//                                             style: TextStyle(
//                                               fontSize: isDesktop ? 14 : 12,
//                                             ),
//                                           ),
//                                         ))
//                                     .toList(),
//                               );
//                             }).toList(),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/common/common_drop_down.dart';
import '../../../utils/common/space.dart';
import '../../../utils/common/start_end_date_picker.dart';
import '../../../utils/helpers/no_data_widget.dart';
import '../../../utils/helpers/page_loader.dart';
import '../../login/controller/login_controller.dart';
import '../controller/report_dashboard_controller.dart';

class BiteTableScreen extends StatefulWidget {
  const BiteTableScreen({super.key});

  @override
  State<BiteTableScreen> createState() => _BiteTableScreenState();
}

class _BiteTableScreenState extends State<BiteTableScreen> {
  final controller = Get.find<ReportDashboardController>();
  final loginController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      backgroundColor: Color(0xffe1e9f4),
      body: Obx(() {
        if (controller.isDataLoading.value) {
          return pageLoader();
        }

        final dataList = controller.byteData;

        /// ---------------- NO DATA UI ----------------
        if (dataList.isEmpty) {
          return noDataWidget(msg: "No Records Found");
        }

        final keys = dataList.first.toJson().keys.toList();

        /// ---------------- DATA TABLE UI ----------------
        return Container(
          width: double.infinity,
          height: 500,
          // margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: DataTable2(
              headingRowColor: MaterialStateProperty.all(Colors.blue.shade700),
              headingRowHeight: 56,
              dataRowHeight: 66,
              columnSpacing: 20,
              horizontalMargin: 12,
              minWidth: 1000,
              // ensures horizontal scroll
              fixedTopRows: 1,
              // ✅ keeps header sticky
              border: TableBorder.all(
                color: Colors.grey.shade500,
              ),
              columns: keys.map<DataColumn>((key) {
                return DataColumn2(
                  size: ColumnSize.L,
                  label: Text(
                    key.replaceAll("_", " ").toUpperCase(),
                    style: TextStyle(
                        fontSize: isDesktop ? 15 : 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                );
              }).toList(),

              rows: dataList.asMap().entries.map<DataRow>((entry) {
                final index = entry.key; // 👈 row index
                final item = entry.value;
                final map = item.toJson();

                return DataRow(
                  color: MaterialStateProperty.resolveWith<Color?>(
                    (states) {
                      // Even rows
                      if (index % 2 == 0) {
                        return Colors.lightBlue.shade100;
                      }
                      return Colors.white;
                    },
                  ),
                  cells: keys.map<DataCell>((key) {
                    return DataCell(
                      Text(
                        map[key]?.toString() ?? "-",
                        style: TextStyle(
                          fontSize: isDesktop ? 14 : 12,
                        ),
                      ),
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          ),
        );
      }),
    );
  }
}

/*SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(isDesktop ? 30 : 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Bytes & Stings Summary",
                    style: TextStyle(
                      fontSize: isDesktop ? 24 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Space(height: 20),
                Container(
                  padding: EdgeInsets.all(isDesktop ? 20 : 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(
                        Colors.orange.shade100,
                      ),
                      border: TableBorder.all(color: Colors.grey.shade300),
                      columnSpacing: isDesktop ? 40 : 20,
                      headingRowHeight: isDesktop ? 60 : 55,

                      /// ❌ REMOVED dataRowMinHeight (BUG FIX)
                      columns: keys
                          .map(
                            (key) => DataColumn(
                              label: Text(
                                key.replaceAll("_", " ").toUpperCase(),
                                style: TextStyle(
                                  fontSize: isDesktop ? 15 : 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                          .toList(),

                      rows: dataList.map((item) {
                        final map = item.toJson();
                        return DataRow(
                          cells: keys
                              .map(
                                (key) => DataCell(
                                  Text(
                                    map[key]?.toString() ?? "-",
                                    style: TextStyle(
                                      fontSize: isDesktop ? 14 : 12,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )*/
