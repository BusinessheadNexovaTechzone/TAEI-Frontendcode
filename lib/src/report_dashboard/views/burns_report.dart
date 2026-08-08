import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taei_gov/src/login/controller/login_controller.dart';
import 'package:taei_gov/src/report_dashboard/controller/report_dashboard_controller.dart';
import 'package:taei_gov/utils/helpers/no_data_widget.dart';
import 'package:taei_gov/utils/helpers/page_loader.dart';
import '../../../utils/common/common_drop_down.dart';
import '../../../utils/common/start_end_date_picker.dart';
import '../../../utils/helpers/space.dart';

class BurnsTableScreen extends StatefulWidget {
  @override
  State<BurnsTableScreen> createState() => _BurnsTableScreenState();
}

class _BurnsTableScreenState extends State<BurnsTableScreen> {
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

        /// Get list safely
        final dataList = controller.burnsData.value?.data ?? [];
        if (dataList.isEmpty) {
          return noDataWidget(msg: "No Records Found");
        }

        /// Extract Table Headers
        final keys = dataList.first.toJson().keys.toList();
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
              minWidth: 8000,
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
