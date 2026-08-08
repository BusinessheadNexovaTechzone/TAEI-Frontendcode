import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/constants/urls.dart';
import 'package:taei_gov/src/trauma/model/trauma_dashboard_model.dart';
import 'package:taei_gov/src/trauma/model/trauma_details_model.dart';
import 'package:taei_gov/src/trauma/model/trauma_list_model.dart';
import 'package:taei_gov/src/trauma/model/trauma_lookup_model.dart';
import 'package:taei_gov/src/trauma/model/trauma_model.dart';
import 'package:taei_gov/src/trauma/views/trauma_list_page.dart';
import 'package:taei_gov/utils/helpers/http_helper.dart';

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;

class TraumaController extends GetxController {
  Rx<TraumaModel> trauma = TraumaModel(
    trauma: Trauma(),
    traumaFinal: TraumaFinal(),
    traumaValues: TraumaValues(),
  ).obs;
  Rx<TraumaDetailsModel> traumaDetails = TraumaDetailsModel().obs;
  RxList<TraumaListData> traumaList = <TraumaListData>[].obs;
  Rx<TraumaLooksUpModel> traumaLookup = TraumaLooksUpModel().obs;
  RxBool isLoading = false.obs;
  RxInt currentIndex = 0.obs;
  RxString isPatientAdmitted = "".obs;

  var traumaDashBoard = GetTraumaSummary().obs;
  var traumaDataMap = <String, String>{}.obs;

  var traumaStartDate = Rxn<DateTime>();
  var traumaEndDate = Rxn<DateTime>();

  static final _client = CustomHttpHelper();

  void changeIndex(int index) {
    currentIndex.value = index;
  }

  Future<void> downloadTraumaDetailsPdf({required String id}) async {
    try {
      // Step 1: Fetch the data first
      final success = await getTraumaDetails(id: id);
      if (!success) {
        Fluttertoast.showToast(msg: "Failed to fetch trauma details");
        return;
      }

      final data = traumaDetails.value;

      // Step 2: Initialize PDF document
      final pdf = pw.Document();

      // Section title styling
      pw.Widget sectionTitle(String title) => pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 8),
            child: pw.Text(
              title,
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue800,
              ),
            ),
          );

      // Info row for label-value pairs
      pw.Widget infoRow(String label, dynamic value) {
        final displayValue =
        (value == null || value.toString().trim().isEmpty)
            ? '-'
            : value.toString();

        return pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 4),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                flex: 3,
                child: pw.Text(
                  "$label:",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.Expanded(
                flex: 5,
                child: pw.Text(displayValue),
              ),
            ],
          ),
        );
      }


      // Step 3: Build PDF structure
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(24),
          build: (context) => [
            pw.Center(
              child: pw.Text(
                "TAEI – TRAUMA CASE SUMMARY REPORT",
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue900,
                ),
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Center(
              child: pw.Text(
                "Generated on ${DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now())}",
                style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
              ),
            ),
            pw.SizedBox(height: 20),
            sectionTitle("Trauma Details"),
            infoRow("Department", data.trauma?.nameOfDept),
            infoRow("Date & Time of Entry", data.trauma?.dateTimeOfEntry),
            infoRow("Mechanism of Injury", data.trauma?.mechanismOfInjury),
            infoRow("Type of Injury", data.trauma?.typeOfInjury),
            infoRow("Other Type of Injury", data.trauma?.othTypeOfInjury),
            infoRow("RTA", data.trauma?.rta),
            infoRow(
                "Helmet Worn", data.trauma?.rtaHelmet == true ? "Yes" : "No"),
            infoRow(
                "IKT Availed", data.trauma?.iktAvailed == true ? "Yes" : "No"),
            infoRow("Assault", data.trauma?.assault),
            infoRow("Workspot Injury", data.trauma?.workspotInjury),
            infoRow("Injuries Identified", data.trauma?.injuriesIdentified),
            infoRow("Part of Body Injured", data.trauma?.partOfTheBodyInjured),
            infoRow("GCS Total", data.trauma?.gcsTotal),
            pw.Divider(),
            sectionTitle("Trauma Values"),
            infoRow("BP", "${data.traumaValues?.bpSystolic}/${data.traumaValues?.bpDiastolic}"),
            infoRow("RR", data.traumaValues?.rr),
            infoRow("RTS Autogenerate", data.traumaValues?.rtsAutogenerate),
            infoRow("Trauma Flag", data.traumaValues?.traumaFlag),
            infoRow("Admitted", data.traumaValues?.admitted == true ? "Yes" : "No"),
            infoRow("ECG Done", data.traumaValues?.ecg == true ? "Yes" : "No"),
            infoRow("ECG Findings", data.traumaValues?.ecgfindings),
            infoRow("CT Done", data.traumaValues?.ct == true ? "Yes" : "No"),
            infoRow("CT Findings", data.traumaValues?.ctfindings),
            infoRow("MRI Done", data.traumaValues?.mri == true ? "Yes" : "No"),
            infoRow("MRI Findings", data.traumaValues?.mrifindings),
            infoRow("Blood Investigation",
                data.traumaValues?.bloodInvestigation == true ? "Yes" : "No"),
            infoRow("HCG Done", data.traumaValues?.hcg == true ? "Yes" : "No"),
            infoRow("Urine Test", data.traumaValues?.urineTest == true ? "Yes" : "No"),
            pw.Divider(),
            sectionTitle("Trauma Final Management"),
            infoRow("Speciality Opinion", data.traumaFinal?.specialityOpinion),
            infoRow("CPR Done", data.traumaFinal?.iscpr == true ? "Yes" : "No"),
            infoRow("Blood Transfusion",
                data.traumaFinal?.bloodTransfusionDone == true ? "Yes" : "No"),
            infoRow("Mechanical Intubation",
                data.traumaFinal?.mechIntubation == true ? "Yes" : "No"),
            infoRow("Intubation Details", data.traumaFinal?.mechIntubationDtls),
            infoRow("Final Diagnosis", data.traumaFinal?.finalDiagnosis),
            infoRow("Type of Surgery", data.traumaFinal?.typeOfSurgery),
            infoRow("Surgery Name", data.traumaFinal?.surgeryName),
            infoRow("Surgery Date", data.traumaFinal?.dateTime),
            infoRow("Surgery Done By", data.traumaFinal?.surgeryDoneBy),
            infoRow(
                "Rehabilitation Required",
                data.traumaFinal?.rehabilitationRequired == true
                    ? "Yes"
                    : "No"),
            pw.Divider(),
            sectionTitle("Trauma Outcome"),
            infoRow("Outcome", data.traumaOutcome?.outcome),
            infoRow(
                "Discharge Date & Time", data.traumaOutcome?.taeiCaseDocumented),
            infoRow(
                "Discharge Date & Time", data.traumaOutcome?.dischargeDatetime),
            infoRow("Discharge Details", data.traumaOutcome?.dischargeDetails),
            infoRow("Hospital Type", data.traumaOutcome?.hospitalType),
            infoRow("Destination Hospital",
                data.traumaOutcome?.destinationHospital),
            infoRow(
                "Reason for Referral", data.traumaOutcome?.reasonForReferral),
            infoRow(
                "Condition of Patient", data.traumaOutcome?.conditionOfPatient),
            infoRow(
                "Referring Doctor", data.traumaOutcome?.referringDoctorName),
            infoRow("Doctor Name", data.traumaOutcome?.nameOfDoctor),
            infoRow("Stayed Duration",
                data.traumaOutcome?.stayedDuration?.toString()),
            // pw.SizedBox(height: 20),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                "Generated by TAEI System ${DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now())}",
                style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
              ),
            ),
          ],
        ),
      );

      // Step 4: Export or Download PDF
      final bytes = await pdf.save();

      if (kIsWeb) {
        final blob = html.Blob([bytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download",
              "Trauma_Case_${DateTime.now().millisecondsSinceEpoch}.pdf")
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        final dir = await getApplicationDocumentsDirectory();
        final file = File(
            "${dir.path}/Trauma_Case_${DateTime.now().millisecondsSinceEpoch}.pdf");
        await file.writeAsBytes(bytes);
        Fluttertoast.showToast(msg: "PDF saved to: ${file.path}");
      }
    } catch (e, st) {
      log("Error generating trauma PDF: $e\n$st");
      Fluttertoast.showToast(msg: "Failed to generate PDF");
    }
  }

  Future<bool> createTrauma({
    required TraumaModel data,
  }) async {
    try {
      isLoading.value = true;
      log(data.toString());
      var url = Uri.parse(Urls.createTrauma);
      var response = await _client.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(data.toCleanJson()));
      log(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var d = jsonDecode(response.body);
        Fluttertoast.showToast(msg: "Data created successfully");
        isLoading.value = false;
        Get.back();
        getTraumaList(
          startDate: DateFormat('yyyy-MM-dd 00:00:00')
              .format(DateTime.now().subtract(Duration(days: 7))),
          endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
          dischargeStatus: dischargeStatus.value,
        );
        getTraumaDashboard(
          startDate: DateFormat('yyyy-MM-dd 00:00:00')
              .format(DateTime.now().subtract(Duration(days: 7))),
          endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
        );
        return true;
      } else {
        isLoading.value = false;
        return false;
      }
    } catch (ex) {
      isLoading.value = false;
      return false;
    }
  }

  Future<bool> getTraumaById({required String id}) async {
    try {
      log(id.toString());
      var url = Uri.parse(Urls.getTraumaById + id);
      var response = await _client.get(
        url,
      );
      print(url);
      log('getEmoById response: ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        var d = jsonDecode(response.body);
        log('getEmoById response LLL: ${d.toString()}');
        trauma.value = TraumaModel.fromJson(d);
        log('getEmoById response MM: ${d.toString()}');
        log('getEmoById response Value: ${trauma.value.toString()}');
        Fluttertoast.showToast(msg: "Data loaded successfully");

        return true;
      } else {
        return false;
      }
    } catch (ex) {
      return false;
    }
  }

  Future<bool> updateTrauma({
    required TraumaModel data,
    required String id,
  }) async {
    try {
      isLoading.value = true;
      // log(data.toString());
      var url = Uri.parse(Urls.updateTrauma + id);
      var response = await _client.put(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(data.toJson()));
      if (response.statusCode == 200 || response.statusCode == 201) {
        log('updateEmo response: ${response.body}');
        // var d = jsonDecode(response.body);
        Fluttertoast.showToast(msg: "Data updated successfully");
        isLoading.value = false;
        Get.back();
        getTraumaList(
          startDate: DateFormat('yyyy-MM-dd 00:00:00')
              .format(DateTime.now().subtract(Duration(days: 7))),
          endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
          dischargeStatus: dischargeStatus.value,
        );
        getTraumaDashboard(
          startDate: DateFormat('yyyy-MM-dd 00:00:00')
              .format(DateTime.now().subtract(Duration(days: 7))),
          endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
        );
        log("Data updated successfully Dias ${dischargeStatus.value}");
        return true;
      } else {
        isLoading.value = false;
        return false;
      }
    } catch (ex) {
      isLoading.value = false;
      return false;
    }
  }

  Future<bool> deleteTrauma({required String id}) async {
    try {
      log(id.toString());
      var url = Uri.parse(Urls.deleteTrauma + id);
      var response = await _client.delete(
        url,
      );
      log(response.body);
      if (response.statusCode == 200) {
        var d = jsonDecode(response.body);
        Fluttertoast.showToast(msg: d["message"]);
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      return false;
    }
  }

  /// Pagination
  var traumaCurrentPage = 1.obs;
  var traumaTotalPages = 1.obs;
  final int traumaLimit = 20;
  var traumaTotalCount = 0.obs;
  var dischargeStatus = "".obs;
  var searchText = "".obs;

// // filtered list getter
//   List<TraumaListData> get filteredTraumaList {
//     if (searchText.value.isEmpty) {
//       return traumaList;
//     }
//     return traumaList.where((e) {
//       final name = (e.nameOfPatient ?? "").toLowerCase();
//       return name.contains(searchText.value.toLowerCase());
//     }).toList();
//   }

  Future<bool> getTraumaList({
    required String startDate,
    required String endDate,
    String patientName = "",
    String dischargeStatus = "",
    int pageNumber = 1, // offset in your API
  }) async {
    try {
      var url = Uri.parse(Urls.getTrauma +
          "list?limit=$traumaLimit&offset=$pageNumber&start_date=$startDate&end_date=$endDate&patient_name=$patientName&discharge_status=$dischargeStatus");
      var response = await _client.get(url);

      if (response.body.isNotEmpty) {
        var list = traumaListDataModelFromJson(response.body);
        traumaList.assignAll(list.rows ?? []);
        log('getTrauma123 response: ${traumaList.toString()}');
        traumaTotalCount.value = list.totalCount ?? 0;
        traumaTotalPages.value = (traumaTotalCount.value / traumaLimit)
            .ceil()
            .clamp(1, double.infinity)
            .toInt();
        traumaStartDate.value = DateTime.parse(startDate);
        traumaEndDate.value = DateTime.parse(endDate);
        traumaCurrentPage.value = pageNumber;
        log('getTrauma response: ${traumaList.toString()}');
        Fluttertoast.showToast(msg: "Data loaded successfully");

        return true;
      } else {
        return false;
      }
    } catch (ex) {
      log("getListEmo error: $ex");
      return false;
    }
  }

  Future<bool> getTraumaLookup() async {
    try {
      var url = Uri.parse(Urls.getTraumaLookup);
      var response = await _client.get(url);
      log('getEmoLookup response: ${response.body}');

      if (response.body.isNotEmpty) {
        var list = traumaLooksUpModelFromJson(response.body);
        traumaLookup.value = list;
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      log("getEmoLookup error: $ex");
      return false;
    }
  }

  /// Get TRauma Details
  Future<bool> getTraumaDetails({required String id}) async {
    try {
      log(id.toString());
      var url = Uri.parse(Urls.getTraumaDetails + id);
      var response = await _client.get(
        url,
      );
      log(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var d = jsonDecode(response.body);
        traumaDetails.value = TraumaDetailsModel.fromJson(d);
        Fluttertoast.showToast(msg: "Trauma details fetched successfully");
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      return false;
    }
  }

  Future<bool> getTraumaDashboard(
      {required String startDate, required String endDate}) async {
    try {
      var url = Uri.parse(
          Urls.getTraumaDashboard + "?start_date=$startDate&end_date=$endDate");
      var response = await _client.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      });
      log('getEmoLookup response: ${response.body}');
      if (response.body.isNotEmpty) {
        var list = traumaDashBoardFromJson(response.body);
        traumaDashBoard.value =
            list.first.getTraumaSummary ?? GetTraumaSummary();
        traumaDataMap.value = {
          "Total": traumaDashBoard.value.total.toString(),
          "Red": traumaDashBoard.value.red.toString(),
          "Yellow": traumaDashBoard.value.yellow.toString(),
          "Green": traumaDashBoard.value.green.toString(),
          "Rta": traumaDashBoard.value.rta.toString(),
          "Admitted": traumaDashBoard.value.admitted.toString(),
          "Pending": traumaDashBoard.value.pending.toString()
        };
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      log("getEmoLookup error: $ex");
      return false;
    }
  }

  int get gcsTotal {
    final eye =
        int.tryParse(trauma.value.trauma?.gcsEye?.toString() ?? "0") ?? 0;
    final verbal =
        int.tryParse(trauma.value.trauma?.gcsVerbal?.toString() ?? "0") ?? 0;
    final motor =
        int.tryParse(trauma.value.trauma?.gcsMotor?.toString() ?? "0") ?? 0;
    return eye + verbal + motor;
  }

  // --- Private Calculations ---
  int _calculateF1() {
    final total = gcsTotal;
    if (total >= 13 && total <= 15) return 4;
    if (total >= 9 && total <= 12) return 3;
    if (total >= 6 && total <= 8) return 2;
    if (total >= 4 && total <= 5) return 1;
    if (total <= 3) return 0;
    return 0;
  }

  int _calculateF2() {
    final sbp = int.tryParse(
            trauma.value.traumaValues?.bpSystolic?.toString() ?? "0") ??
        0;
    if (sbp > 89) return 4;
    if (sbp >= 76 && sbp <= 89) return 3;
    if (sbp >= 50 && sbp <= 75) return 2;
    if (sbp >= 1 && sbp <= 49) return 1;
    if (sbp == 0) return 0;
    return 0;
  }

  int _calculateF3() {
    final sbp = int.tryParse(
            trauma.value.traumaValues?.bpDiastolic?.toString() ?? "0") ??
        0;
    if (sbp > 89) return 4;
    if (sbp >= 76 && sbp <= 89) return 3;
    if (sbp >= 50 && sbp <= 75) return 2;
    if (sbp >= 1 && sbp <= 49) return 1;
    if (sbp == 0) return 0;
    return 0;
  }

  int _calculateF4() {
    final rr =
        int.tryParse(trauma.value.traumaValues?.rr?.toString() ?? "0") ?? 0;
    if (rr > 29) return 3;
    if (rr >= 10 && rr <= 29) return 4;
    if (rr >= 6 && rr <= 9) return 2;
    if (rr >= 1 && rr <= 5) return 1;
    if (rr == 0) return 0;
    return 0;
  }

  // --- Public Getters ---
  double get totalTraumaScore {
    final f1 = _calculateF1();
    final f2 = _calculateF2();
    final f3 = _calculateF3();
    final f4 = _calculateF4();
    return (0.9368 * f1) + (0.7326 * f2) + (0.2908 * f3) + (0.2908 * f4);
  }

  String get traumaColor {
    final score = totalTraumaScore;
    if (score <= 0) return "white";
    if (score >= 1 && score <= 3) return "red";
    if (score > 3 && score <= 6) return "yellow";
    if (score > 6) return "green";
    return "";
  }

  // --- Update Functions ---
  void updateGcsEye(dynamic value) {
    trauma.value.trauma?.gcsEye = value;
    trauma.refresh();
  }

  void updateGcsVerbal(dynamic value) {
    trauma.value.trauma?.gcsVerbal = value;
    trauma.refresh();
  }

  void updateGcsMotor(dynamic value) {
    trauma.value.trauma?.gcsMotor = value;
    trauma.refresh();
  }

  void updateBpSystolic(int value) {
    trauma.value.traumaValues?.bpSystolic = value;
    trauma.refresh();
  }

  void updateBpDiastolic(int value) {
    trauma.value.traumaValues?.bpDiastolic = value;
    trauma.refresh();
  }

  void updateRr(String value) {
    trauma.value.traumaValues?.rr = value;
    trauma.refresh();
  }
}
