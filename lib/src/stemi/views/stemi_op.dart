import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/src/kpidashborad/commondatepickertest.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/src/stemi/controller/stemi_controller.dart';
import 'package:taei_gov/src/stemi/form_page.dart';
import 'package:taei_gov/src/stemi/views/op_details_page.dart';
import 'package:taei_gov/utils/common/start_end_date_picker.dart';
import 'package:taei_gov/utils/helpers/page_loader.dart';
import '../../../widgets/CommonSearchBar.dart';
import 'add_stemi.dart';

class StemiListPageOp extends StatefulWidget {
  final bool appBar;

  const StemiListPageOp({super.key, this.appBar = true});

  @override
  State<StemiListPageOp> createState() => _StemiListPageOpState();
}

class _StemiListPageOpState extends State<StemiListPageOp> {
  final StemiController controller = Get.put(StemiController());
  final TextEditingController searchController = TextEditingController();

  List<dynamic> filteredList = [];
  Timer? _debounce;

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.getListStemiOp(
        startDate: DateFormat('yyyy-MM-dd 00:00:00').format(DateTime.now()),
        endDate  : DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
      );

      // Initialize full data to filteredList (for display)
      filteredList =
          controller.stemiListDataOp.expand((e) => e.rows ?? []).toList();
      setState(() {});
    });
  }

  // 🔍 Local search with debounce (no UI change)
  void _filterSearch(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 100), () {
      final lower = query.toLowerCase().trim();

      setState(() {
        if (lower.isEmpty) {
          // Reset to all rows
          filteredList =
              controller.stemiListDataOp.expand((e) => e.rows ?? []).toList();
        } else {
          // 🔍 Filter only by patient name
          filteredList = controller.stemiListDataOp
              .expand((e) => e.rows ?? [])
              .where((row) {
            final name = (row.nameOfPatient ?? '').toLowerCase();
            return name.contains(lower);
          }).toList();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          context.isDesktop ? const Color(0xFFF1E9E9) : Colors.white,
      appBar: widget.appBar
          ? AppBar(
              backgroundColor: Colors.redAccent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Get.back(),
              ),
              title: const Text('Cardiology OP'),
              centerTitle: true,
              actions: [
                if (!context.isDesktop)
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    tooltip: 'Create',
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const StemiFormPage(create: true),
                        ),
                      );
                      if (result == true) controller.stemiModel.refresh();
                    },
                  ),
              ],
            )
          : null,
      body: Obx(() {
        if (controller.isLoading.value) return pageLoader();
        if (controller.stemiListDataOp.isEmpty) {
          return const Center(child: Text("No records found"));
        }

        return Padding(
          padding: context.isDesktop
              ? const EdgeInsets.symmetric(horizontal:50, vertical: 20)
              : const EdgeInsets.all(8),
          child: Column(
            spacing: 20,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (context.isDesktop) ...[
                    CommonSearchBar(
                      controller: searchController,
                      onChanged: _filterSearch,
                      isDesktop: context.isDesktop,
                      hintText: "Search by name",
                      accentColor: Colors.redAccent,
                    ),
                    CommonDateRangePicker1(
                      startDate: controller.stemiStartDate.value,
                      endDate: controller.stemiEndDate.value,
                      onApply: () async {
                        controller.isLoading(true);
                        await controller.getListStemiOp(
                          startDate: controller.stemiStartDate.toString(),
                          endDate: controller.stemiEndDate.toString(),
                        );
                        controller.isLoading(false);
                        filteredList = controller.stemiListDataOp
                            .expand((e) => e.rows ?? [])
                            .toList();
                        setState(() {});
                      },
                      onDateSelected: (start, end) {
                        controller.stemiStartDate.value = start;
                        controller.stemiEndDate.value = end;
                      },
                    ),
                    // Align(
                    //   alignment: Alignment.topRight,
                    //   child: ElevatedButton.icon(
                    //     onPressed: () async {
                    //       final result = await Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (_) => const StemiFormPage(create: true),
                    //         ),
                    //       );
                    //       if (result == true) controller.stemiModel.refresh();
                    //     },
                    //     icon: const Icon(Icons.add, color: Colors.white),
                    //     label: const Text("Create"),
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: Colors.blueAccent,
                    //       padding: const EdgeInsets.symmetric(
                    //           horizontal: 20, vertical: 18),
                    //       shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(8)),
                    //     ),
                    //   ),
                    // ),
                  ]
                ],
              ),

              // 🔹 For mobile view
              if (!context.isDesktop) ...[
                Align(
                  alignment: Alignment.topLeft,
                  child: CommonDateRangePicker(
                    startDate: controller.stemiStartDate.value,
                    endDate: controller.stemiEndDate.value,
                    onApply: () async {
                      controller.isLoading(true);
                      await controller.getListStemiOp(
                        startDate: controller.stemiStartDate.toString(),
                        endDate: controller.stemiEndDate.toString(),
                      );
                      controller.isLoading(false);
                      filteredList = controller.stemiListDataOp
                          .expand((e) => e.rows ?? [])
                          .toList();
                      setState(() {});
                    },
                    onDateSelected: (start, end) {
                      controller.stemiStartDate.value = start;
                      controller.stemiEndDate.value = end;
                    },
                  ),
                ),
                CommonSearchBar(
                  controller: searchController,
                  onChanged: _filterSearch,
                  isDesktop: context.isDesktop,
                  hintText: "Search by name, mobile, or OP number",
                  accentColor: Colors.redAccent,
                ),
              ],

              // 🔹 Data Table (no layout change)
              Expanded(
                child: Container(
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
                  child: ScrollConfiguration(
                    behavior:
                        const ScrollBehavior().copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(

                          headingRowColor:
                              WidgetStateProperty.all(Colors.blueGrey.shade50),
                          headingRowHeight: 50,
                          dataRowMaxHeight: 56,
                          columnSpacing: context.isDesktop ? 120 : 30,
                          border: TableBorder.all(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          columns: const [
                            DataColumn(
                                label: Text("Patient ID",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text("OP Number",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text("Name",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text("Gender",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text("Mobile",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text("Parent Name",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            DataColumn(
                                label: Text("Action",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                          ],
                          // ✅ Local Search applied here
                          rows: [
                            for (var row in filteredList
                              ..sort((a, b) => (b.patientId ?? '0')
                                  .compareTo(a.patientId ?? '0')))
                              DataRow(
                                color:
                                    MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                                    final index = filteredList.indexOf(row);
                                    return index.isEven
                                        ? Colors.grey[100]
                                        : Colors.white;
                                  },
                                ),
                                cells: [
                                  DataCell(
                                      Text(row.patientId?.toString() ?? "-")),
                                  DataCell(Text(row.patientOpNumber ?? "-")),
                                  DataCell(Text(row.nameOfPatient ?? "-")),
                                  DataCell(Text(row.gender ?? "-")),
                                  DataCell(
                                      Text(row.patientMobileNumber ?? "-")),
                                  DataCell(Text(row.fathername ?? "-")),
                                  DataCell(
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blueAccent,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: () async {
                                        Get.to(
                                          StemiDetailPageOp(
                                            triageId: row.patientId.toString(),
                                            isAppbar: true,
                                          ),
                                        );






                                        // final result = await Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (_) => StemiFormPage(
                                        //       create: false,
                                        //       id: row.patientId.toString(),
                                        //     ),
                                        //   ),
                                        // );
                                        // if (result == true)
                                        //   controller.stemiModel.refresh();
                                      },
                                      child: const Text("View"),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
