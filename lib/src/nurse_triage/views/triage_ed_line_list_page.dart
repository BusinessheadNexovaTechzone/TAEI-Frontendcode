// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:taei_gov/src/nurse_triage/controller/nurse_triage_controller.dart';
// import 'package:taei_gov/src/nurse_triage/views/add_accident.dart';
// import 'package:taei_gov/src/responsive.dart';
// import 'package:taei_gov/utils/common/appbar.dart';
// import 'package:taei_gov/utils/common/start_end_date_picker.dart';
// import 'package:taei_gov/utils/common/table_common_button.dart';
//
// import '../../../widgets/CommonSearchBar.dart';
//
// class TriageEdListPage extends StatefulWidget {
//   final bool isFromHome;
//   const TriageEdListPage({super.key, this.isFromHome = false});
//
//   @override
//   State<TriageEdListPage> createState() => _TriageEdListPageState();
// }
//
// class _TriageEdListPageState extends State<TriageEdListPage> {
//   final NurseTriageController controller = Get.put(NurseTriageController());
//   bool _blink = true;
//   Timer? _timer;
//
//   final TextEditingController searchController = TextEditingController();
//   List<dynamic> filteredList = [];
//   bool _isFocused = false;
//   Timer? _debounce;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await controller.getEdLineList();
//       filteredList = List.from(controller.edLineList);
//     });
//
//     // blinking animation every 800ms
//     _timer = Timer.periodic(const Duration(milliseconds: 800), (_) {
//       setState(() => _blink = !_blink);
//     });
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }
//
//   /// 🔍 Patient search filter
//   void _filterSearch(String query) {
//     if (_debounce?.isActive ?? false) _debounce!.cancel();
//     _debounce = Timer(const Duration(milliseconds: 300), () {
//       setState(() {
//         if (query.isEmpty) {
//           filteredList = List.from(controller.edLineList);
//         } else {
//           filteredList = controller.edLineList
//               .where((item) =>
//               (item.patientName ?? '')
//                   .toLowerCase()
//                   .contains(query.toLowerCase().trim()))
//               .toList();
//         }
//       });
//     });
//   }
//
//   /// 🔥 Blink-based color animation for RTS status
//   Color getBlinkColor(String? rtsColor) {
//     if (!_blink) return Colors.white;
//     switch (rtsColor?.toLowerCase()) {
//       case 'red':
//         return Colors.red.shade100;
//       case 'yellow':
//         return Colors.yellow.shade100;
//       case 'green':
//         return Colors.green.shade100;
//       default:
//         return Colors.white;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: widget.isFromHome
//           ? null
//           : CommonAppBar(title: "Triage ED Line List"),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         if (controller.edLineList.isEmpty) {
//           return const Center(child: Text("No cases found"));
//         }
//
//         return Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Column(
//             spacing: 16,
//             children: [
//
//               /// 🔹 Animated Search Bar
//               CommonSearchBar(
//
//                 controller: searchController,
//                 onChanged: _filterSearch,
//                 isDesktop: context.isDesktop,
//                 hintText: "Search by patient name",
//               ),
//
//               /// 🔹 DataTable with Blink Effect
//               Expanded(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.05),
//                         blurRadius: 6,
//                         offset: const Offset(0, 3),
//                       )
//                     ],
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: DataTable(
//                         headingRowColor: WidgetStateProperty.all(
//                             Colors.blueGrey.shade50),
//                         columnSpacing: 20,
//                         dataRowMinHeight: 1990,
//                         headingRowHeight: 52,
//                         dataRowHeight: 52,
//                         border: TableBorder.all(
//                           color: Colors.grey.shade300,
//                         ),
//                         columns: const [
//                           DataColumn(label: Text("Case ID", style: TextStyle(fontWeight: FontWeight.bold))),
//                           DataColumn(label: Text("Patient Name", style: TextStyle(fontWeight: FontWeight.bold))),
//                           DataColumn(label: Text("Create / Entry", style: TextStyle(fontWeight: FontWeight.bold))),
//                           DataColumn(label: Text("District", style: TextStyle(fontWeight: FontWeight.bold))),
//                           DataColumn(label: Text("Base Location", style: TextStyle(fontWeight: FontWeight.bold))),
//                           DataColumn(label: Text("Vehicle No.", style: TextStyle(fontWeight: FontWeight.bold))),
//                           DataColumn(label: Text("Call Type", style: TextStyle(fontWeight: FontWeight.bold))),
//                           DataColumn(label: Text("Chief Complaint", style: TextStyle(fontWeight: FontWeight.bold))),
//                           DataColumn(label: Text("Source Hospital", style: TextStyle(fontWeight: FontWeight.bold))),
//                           DataColumn(label: Text("Hospital Name", style: TextStyle(fontWeight: FontWeight.bold))),
//                         ],
//                         rows: filteredList.map<DataRow>((data) {
//                           final bgColor = getBlinkColor(data.rtsColor);
//
//                           return DataRow(
//                             color: MaterialStateProperty.all(bgColor),
//                             cells: [
//                               DataCell(Text(data.caseId?.toString() ?? "-")),
//                               DataCell(Text(data.patientName ?? "-")),
//                               DataCell(TableCommonButton(
//                                 compact: true,
//                                 label: "Triage",
//                                 color: Colors.green.shade700,
//                                 icon: Icons.add_business_rounded,
//                                 onTap: () {
//                                   Get.to(AddAccident(
//                                     id: data.caseId?.toString(),
//                                     isUpdate: false,
//                                   ));
//                                 },
//                               )),
//                               DataCell(Text(data.districtName ?? "-")),
//                               DataCell(Text(data.baseLocation ?? "-")),
//                               DataCell(Text(data.vehicleNumber ?? "-")),
//                               DataCell(Text(data.callType ?? "-")),
//                               DataCell(Text(data.chiefComplaint ?? "-")),
//                               DataCell(Text(data.emergencySubType ?? "-")),
//                               DataCell(Text(data.hospitalName ?? "-")),
//                             ],
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//
//         );
//       }),
//     );
//   }
// }
