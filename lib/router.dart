// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//       appBar: widget.appBar
//           ? AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Get.back(),
//         ),
//         backgroundColor: Colors.redAccent,
//         title: context.isDesktop
//             ? Center(child: Text('Drowning'))
//             : Text('Drowning'),
//       )
//           : null,
//       body: Obx(
//             () => controller.isDrowningLoading.value
//             ? const Center(
//           child: CircularProgressIndicator(),
//         )
//             : controller.drowningList.value == null ||
//             controller.drowningList.value!.rows!.isEmpty
//             ? noDataWidget()
//             : Container(
//           padding: context.isDesktop
//               ? EdgeInsets.only(left: 30, right: 30, top: 8)
//               : EdgeInsets.all(10),
//           child: Column(
//             spacing: 0,
//             children: [
//               Expanded(
//                 child: GridView.builder(
//                   gridDelegate:
//                   SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: context.isDesktop ? 7 : 3,
//                     crossAxisSpacing: context.isDesktop ? 11 : 12,
//                     mainAxisSpacing: 12,
//                     childAspectRatio:
//                     context.isDesktop ? 1.68 : 1.5,
//                   ),
//                   itemCount: burnData.length,
//                   itemBuilder: (context, index) {
//                     return Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black26,
//                             blurRadius: 6,
//                             offset: Offset(2, 4),
//                           ),
//                         ],
//                         gradient: LinearGradient(
//                           colors: gradientColors[
//                           index % gradientColors.length],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                       ),
//                       child: Center(
//                         child: Column(
//                           mainAxisAlignment:
//                           MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               burnData.keys.elementAt(index),
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 6),
//                             Text(
//                               burnData.values
//                                   .elementAt(index)
//                                   .toString(),
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               Expanded(
//                 child: Container(
//                   // margin: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         // ignore: deprecated_member_use
//                         color: Colors.black.withOpacity(0.05),
//                         blurRadius: 6,
//                         offset: const Offset(0, 3),
//                       )
//                     ],
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: DataTable2(
//                       headingRowColor: WidgetStateProperty.all(
//                           Colors.blueGrey.shade50),
//                       headingRowHeight: 56,
//                       dataRowHeight: 56,
//                       columnSpacing: 20,
//                       horizontalMargin: 12,
//                       minWidth: 1200,
//                       // ensures horizontal scroll
//                       fixedTopRows: 1,
//                       // ✅ keeps header sticky
//                       border: TableBorder.all(
//                         color: Colors.grey.shade300,
//                       ),
//                       columns: const [
//                         DataColumn2(
//                             label: Text("TAEI ID",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold))),
//                         DataColumn2(
//                             label: Text("Patient Name",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold))),
//                         DataColumn2(
//                             label: Text("Create",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold))),
//                         DataColumn2(
//                             label: Text("Vehicle No.",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold))),
//                         DataColumn2(
//                             label: Text("Mode of Arrival",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold))),
//                         DataColumn2(
//                             label: Text("Call ID",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold))),
//                         DataColumn2(
//                             label: Text("Chief Complaint",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold))),
//                         DataColumn2(
//                             label: Text("Source Hospital",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold))),
//                         DataColumn2(
//                             label: Text("Destination Hospital",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold))),
//                         DataColumn2(
//                             label: Text("View",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold))),
//                       ],
//
//                       rows: controller.drowningList.value!.rows!
//                           .map<DataRow>((data) {
//                         // Row color based on statusid
//                         Color? rowColor;
//                         switch (data.statusid) {
//                           case 1:
//                             rowColor = Colors.red[100];
//                             break;
//                           case 2:
//                             rowColor = Colors.orange[100];
//                             break;
//                           case 3:
//                             rowColor = Colors.green[100];
//                             break;
//                           default:
//                             rowColor = null;
//                         }
//
//                         return DataRow(
//                           color: WidgetStateProperty.all(rowColor),
//                           cells: [
//                             DataCell(Text(
//                                 data.triageId?.toString() ?? "-")),
//                             DataCell(
//                                 Text(data.nameOfPatient ?? "-")),
//                             DataCell(
//                               ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor:
//                                   Colors.blueAccent,
//                                   padding:
//                                   const EdgeInsets.symmetric(
//                                       horizontal: 16,
//                                       vertical: 8),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius:
//                                     BorderRadius.circular(8),
//                                   ),
//                                 ),
//                                 onPressed: () {
//                                   if (data.drowningId == null) {
//                                     controller.drowningModel.value =
//                                     null;
//                                     controller.currentIndex.value =
//                                     0;
//                                     Get.to(() => CreateDrowning(
//                                       hangId: data.drowningId,
//                                       triageId: data.triageId,
//                                       isUpdate: false,
//                                     ));
//                                   } else {
//                                     controller.drowningModel.value =
//                                     null;
//                                     controller.currentIndex.value =
//                                     0;
//                                     Get.to(() => CreateDrowning(
//                                       hangId: data.drowningId,
//                                       triageId: data.triageId,
//                                       isUpdate: true,
//                                     ));
//                                   }
//                                 },
//                                 child: data.drowningId != null
//                                     ? Text("Update")
//                                     : Text("Drowning"),
//                               ),
//                             ),
//                             DataCell(Text(
//                                 data.presentingComplaint ?? "-")),
//                             DataCell(
//                                 Text(data.modeOfArrival ?? "-")),
//                             DataCell(Text(
//                                 data.drowningId?.toString() ??
//                                     "-")),
//                             DataCell(Text(
//                                 data.drowningId?.toString() ??
//                                     "-")),
//                             DataCell(
//                                 Text(data.sourceHospital ?? "-")),
//                             DataCell(Text(
//                                 data.destinationHospital ?? "-")),
//                             DataCell(
//                               IconButton(
//                                 icon: const Icon(
//                                     Icons.remove_red_eye,
//                                     color: Colors.blue),
//                                 tooltip: "View Drowning",
//                                 onPressed: () {
//                                   // Get.to(() => CreateDrowning(
//                                   //       triageId: data.triageId,
//                                   //       isUpdate: false,
//                                   //       hangId: data.drowningId,
//                                   //     ));
//                                 },
//                               ),
//                             ),
//                           ],
//                         );
//                       }).toList(),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ));
// }
