import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// import 'package:open_filex/open_filex.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';

// Use universal_html for safe web DOM access behind kIsWeb checks.
import 'package:universal_html/html.dart' as html;

import 'package:taei_gov/src/prem/model/prem_dashboard_model.dart';
import '../../../constants/urls.dart';
import '../../../utils/helpers/http_helper.dart';
import '../../../utils/helpers/loading_helper.dart';
import '../model/prem_detail.dart';
import '../model/prem_lookup_model.dart';
import '../model/prem_model.dart';
import '../model/requestMode.dart';

class PremController extends GetxController {
  Rx<PremModel1> premModel1 = PremModel1().obs;
  RxInt currentIndex = 0.obs;
  var ListData = <PremListData>[].obs;
  var ListData1 = <PremDetails>[].obs;

  Rx<PremLooksUpModel> premLookup = PremLooksUpModel().obs;
  var filteredDiagnosisRefs = <DiagnosisRefItem>[].obs;
  int? refId;
  RxBool isLoading = false.obs;
  RxInt pastHistory = 0.obs;

  var premDashBoard = PremDashBoard().obs;
  var premDataMap = <String, String>{}.obs;
  var premStartDate = Rxn<DateTime>();
  var premEndDate = Rxn<DateTime>();

  static final _client = CustomHttpHelper();

  // -------------------------------
  // CREATE
  // -------------------------------
  Future<bool> createPrem({required PremModel1 data}) async {
    try {
      const encoder = JsonEncoder.withIndent('  ');
      final jsonBody = jsonEncode(data.toJson());
      final url = Uri.parse(Urls.createPrem);

      var response = await _client.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonBody,
      );

      log("PREM CREATE RESPONSE: ${response.statusCode}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        refId = decoded["prem"]?['id'];
        final prefs = await SharedPreferences.getInstance();
        if (refId != null) await prefs.setInt('lastPremRefId', refId!);

        Fluttertoast.showToast(msg: decoded["message"] ?? "PREM Created");

        await getPremList(
          startDate: DateFormat('yyyy-MM-dd 00:00:00')
              .format(DateTime.now().subtract(Duration(days: 7))),
          endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
          dischargeStatus: dischargeStatus.value,
        );
        await getPremDashboard(
          startDate: DateFormat('yyyy-MM-dd 00:00:00')
              .format(DateTime.now().subtract(Duration(days: 7))),
          endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
        );
        return true;
      } else {
        Fluttertoast.showToast(msg: "Failed: ${response.statusCode}");
        return false;
      }
    } catch (e, st) {
      log("createPrem error: $e\n$st");
      Fluttertoast.showToast(msg: "Error: $e");
      return false;
    }
  }

  // -------------------------------
  // READ
  // -------------------------------
  Future<bool> getPremById({required String id}) async {
    isLoading.value = true;
    try {
      final url = Uri.parse("${Urls.getPremById}$id");
      final response = await _client.get(url);
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        premModel1.value = PremModel1.fromJson(jsonDecode(response.body));
        Fluttertoast.showToast(msg: "Data loaded successfully");
        return true;
      }
      Fluttertoast.showToast(msg: "No record found");
      return false;
    } catch (e) {
      log("getPremById error: $e");
      Fluttertoast.showToast(msg: "Error: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // -------------------------------
  // UPDATE
  // -------------------------------
  Future<bool> updatePrem({
    required PremModel1 data,
    required String id,
  }) async {
    try {
      isLoading.value = true;
      final url = Uri.parse(Urls.updatePrem + id);
      final response = await _client.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Fluttertoast.showToast(msg: "PREM updated successfully");
        await getPremList(
          startDate: DateFormat('yyyy-MM-dd 00:00:00')
              .format(DateTime.now().subtract(Duration(days: 7))),
          endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
          dischargeStatus: dischargeStatus.value,
        );
        await getPremDashboard(
          startDate: DateFormat('yyyy-MM-dd 00:00:00')
              .format(DateTime.now().subtract(Duration(days: 7))),
          endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
        );
        return true;
      } else {
        Fluttertoast.showToast(msg: "Failed to update: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      log("updatePrem error: $e");
      Fluttertoast.showToast(msg: "Error: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // -------------------------------
  // DELETE
  // -------------------------------
  Future<void> deletePrem({required String id}) async {
    try {
      loadingIndicator(Get.context!);
      final url = Uri.parse("${Urls.deletePrem}$id");
      final response = await _client.delete(url);
      Get.back();

      if (response.statusCode == 204) {
        Fluttertoast.showToast(msg: "Deleted successfully");
        await getPremList(
          startDate: DateFormat('yyyy-MM-dd 00:00:00')
              .format(DateTime.now().subtract(Duration(days: 7))),
          endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
          dischargeStatus: dischargeStatus.value,
        );
      } else {
        Fluttertoast.showToast(msg: "Failed to delete");
      }
    } catch (e) {
      Get.back();
      log("deletePrem error: $e");
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  // -------------------------------
  // LIST
  // -------------------------------
  var premList = <PremListData>[].obs;

  /// Pagination
  var premCurrentPage = 1.obs;
  var premTotalPages = 1.obs;
  final int premLimit = 20;
  var premTotalCount = 0.obs;
  RxString dischargeStatus = "".obs;
  var searchText = "".obs;

// filtered list getter
  List<PremListData> get filteredPremList {
    if (searchText.value.isEmpty) {
      return premList;
    }
    return premList.where((e) {
      final name = (e.nameOfPatient ?? "").toLowerCase();
      return name.contains(searchText.value.toLowerCase());
    }).toList();
  }

  Future<bool> getPremList({
    required String startDate,
    required String endDate,
    String patientName = "",
    String dischargeStatus = "",
    int pageNumber = 1, // offset in your API
  }) async {
    try {
      var url = Uri.parse(Urls.getPrem +
          "?limit=$premLimit&offset=$pageNumber&start_date=$startDate&end_date=$endDate&patient_name=$patientName&discharge_status=$dischargeStatus");
      var response = await _client.get(url);

      if (response.body.isNotEmpty) {
        var list = premListModelFromJson(response.body);
        premList.assignAll(list.rows ?? []);
        log('getPrem123 response: ${premList.toString()}');
        premTotalCount.value = list.totalCount ?? 0;
        premTotalPages.value = (premTotalCount.value / premLimit)
            .ceil()
            .clamp(1, double.infinity)
            .toInt();
        premStartDate.value = DateTime.parse(startDate);
        premEndDate.value = DateTime.parse(endDate);
        premCurrentPage.value = pageNumber;
        log('getPrem response: ${premList.toString()}');
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

  // -------------------------------
  // LOOKUP
  // -------------------------------
  Future<bool> getPremLookup() async {
    try {
      final url = Uri.parse(Urls.getPremLookup);
      final response = await _client.get(url);
      if (response.body.isNotEmpty) {
        premLookup.value = premLooksUpModelFromJson(response.body);
        return true;
      }
      return false;
    } catch (e) {
      log("getPremLookup error: $e");
      return false;
    }
  }

  // -------------------------------
  // DASHBOARD
  // -------------------------------
  Future<bool> getPremDashboard({
    required String startDate,
    required String endDate,
  }) async {
    try {
      final url = Uri.parse(
          "${Urls.getPremDashboard}?start_date=$startDate&end_date=$endDate");
      final response = await _client.get(url);
      if (response.body.isNotEmpty) {
        final list = premDashBoardFromJson(response.body);
        premDashBoard.value = list.first;
        premDataMap.value = {
          "Total": "${premDashBoard.value.total ?? 0}",
          "Admitted": "${premDashBoard.value.admitted ?? 0}",
          "Male": "${premDashBoard.value.male ?? 0}",
          "Female": "${premDashBoard.value.female ?? 0}",
          "IFT": "${premDashBoard.value.ift ?? 0}",
          "Red": "${premDashBoard.value.red ?? 0}",
          "Yellow": "${premDashBoard.value.yellow ?? 0}",
          "Green": "${premDashBoard.value.green ?? 0}",
          "Pending": "${premDashBoard.value.pending ?? 0}",
        };
        return true;
      }
      return false;
    } catch (e) {
      log("getPremDashboard error: $e");
      return false;
    }
  }

  // ======================================================
  // 📄 EXPORT PREM DATA TO PDF (New)
  // ======================================================
  Future<void> exportPremToPdf(PremModel1 premData) async {
    try {
      final pdf = pw.Document();

      final Map<String, dynamic> dataMap = {
        "Triage ID": premData.prem?.triageId ?? '',
        "Patient Admitted":
            premData.prem?.patientAdmitted == true ? "Yes" : "No",
        "Department": premData.prem?.nameOfDept ?? '',
        "Date of Admission": premData.prem?.dateOfAdmit ?? '',
        "Temperature": "${premData.prem?.temperature ?? ''} °F",
        "Approx Weight": "${premData.prem?.approxWeight ?? ''} kg",
        "CBG": "${premData.prem?.cbg ?? ''} mg/dL",
        "Development": premData.prem?.development?.toString() ?? '',
        "Triage Flag": premData.prem?.triageFlag?.toString() ?? '',
        "Diagnosis": premData.vitals?.diagnosis?.toString() ?? '',
        "Treatment Given": premData.vitals?.treatmentGiven ?? '',
        "Outcome": premData.outcome?.outcome?.toString() ?? '',
        "Referring Doctor": premData.outcome?.referringDoctor ?? '',
        "Condition of Patient":
            premData.outcome?.conditionOfPatient?.toString() ?? '',
        "Discharge Date": premData.outcome?.dischargeDate ?? '',
        "Cause of Death": premData.outcome?.causeOfDeath ?? '',
      };

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) => [
            pw.Center(
              child: pw.Text(
                "PREM FORM DETAILS",
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue800,
                ),
              ),
            ),
            pw.SizedBox(height: 16),
            ...dataMap.entries.map(
              (entry) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 6),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      flex: 3,
                      child: pw.Text(
                        "${entry.key}:",
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.black,
                        ),
                      ),
                    ),
                    pw.Expanded(
                      flex: 5,
                      child: pw.Text(entry.value.toString()),
                    ),
                  ],
                ),
              ),
            ),
            pw.Divider(),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                "Generated by TAEI System — ${DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now())}",
                style: pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey700,
                ),
              ),
            ),
          ],
        ),
      );

      final bytes = await pdf.save();

      if (kIsWeb) {
        // Use universal_html to trigger browser download (only on web)
        final blob = html.Blob([bytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download",
              "PREM_Form_${DateTime.now().millisecondsSinceEpoch}.pdf")
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        // For Mobile/Desktop
        final dir = await getApplicationDocumentsDirectory();
        final file = File(
            "${dir.path}/PREM_Form_${DateTime.now().millisecondsSinceEpoch}.pdf");
        await file.writeAsBytes(bytes);
        Fluttertoast.showToast(msg: "PDF saved to: ${file.path}");
      }
    } catch (e, st) {
      Fluttertoast.showToast(msg: "PDF generation failed: $e");
      log("PDF export error: $e\n$st");
    }
  }

  Future<bool> getPremDetails({required String id}) async {
    try {
      log("Fetching PREM Details for ID: $id");

      var response = await _client.get(Uri.parse("${Urls.getPremDetails}$id"));
      log("Response (${response.statusCode}): ${response.body}");

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final data = PremModelFromJson2(response.body);
        ListData1.assignAll([data]);
        Fluttertoast.showToast(msg: "Details fetched successfully");
        return true;
      } else {
        Fluttertoast.showToast(msg: "No data found");
        return false;
      }
    } catch (ex, stack) {
      log("Error in getPremDetails: $ex\n$stack");
      Fluttertoast.showToast(msg: "Failed to fetch details");
      return false;
    }
  }

  /// ✅ Generate PDF from fetched API data
  // import 'dart:io';
  // import 'dart:developer';
  // import 'package:flutter/foundation.dart';
  // import 'package:fluttertoast/fluttertoast.dart';
  // import 'package:get/get.dart';
  // import 'package:path_provider/path_provider.dart';
  // import 'package:pdf/pdf.dart';
  // import 'package:pdf/widgets.dart' as pw;
  // import 'package:open_filex/open_filex.dart';
  // import 'package:universal_html/html.dart' as html;

  Future<void> generatePremDetailsPdf() async {
    try {
      if (ListData1.isEmpty) {
        Fluttertoast.showToast(msg: "No data available to generate PDF");
        return;
      }

      final data = ListData1.first;
      final prem = data.prem;
      final vitals = data.vitals;
      final outcome = data.outcome;

      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(24),
          build: (context) => [
            pw.Center(
              child: pw.Text(
                "TAEI – PREM CASE SUMMARY REPORT",
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue700,
                ),
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Center(
              child: pw.Text(
                "Generated on ${DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now())}",
                style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
              ),
            ),
            pw.SizedBox(height: 8),

            // Section: PREM Details
            sectionTitle("PREM Details"),
            infoRow("Department", prem?.nameOfDept),
            infoRow("Date of Admit", prem?.dateOfAdmit),
            infoRow("Triage Flag", prem?.triageFlag),
            infoRow("Temperature", "${prem?.temperature ?? '-'}°F"),
            infoRow("CBG", prem?.cbg?.toString()),
            infoRow("Weight", "${prem?.approxWeight ?? '-'} kg"),

            pw.Divider(),

            // Section: Vitals
            sectionTitle("Vitals"),
            infoRow("Airway", vitals?.airway),
            infoRow("Breathing", vitals?.breathing),
            infoRow("Circulation", vitals?.circulationHr),
            infoRow("Perfusion", vitals?.perfusion),
            infoRow("Disability", vitals?.disability),
            infoRow("Diagnosis", vitals?.diagnosis),
            infoRow("Treatment Given", vitals?.treatmentGiven),

            pw.Divider(),

            // Section: Outcome
            sectionTitle("Outcome"),
            infoRow("Outcome", outcome?.outcome),
            infoRow("Condition of Patient", outcome?.conditionOfPatient),
            infoRow("Hospital Type", outcome?.hospitalType),
            infoRow("Destination Hospital", outcome?.destinationHospital),
            infoRow("Referral Reason", outcome?.reasonForReferral),
            infoRow("Referring Doctor", outcome?.referringDoctor),

            pw.SizedBox(height: 8),

            // Footer
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                "Generated by TAEI System — ${DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now())}",
                style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
              ),
            ),
          ],
        ),
      );

      final bytes = await pdf.save();

      if (kIsWeb) {
        final blob = html.Blob([bytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", "PREM_Details_Report.pdf")
          ..click();
        html.Url.revokeObjectUrl(url);
        Fluttertoast.showToast(msg: "PDF downloaded successfully");
      } else {
        final dir = await getApplicationDocumentsDirectory();
        final file = File(
            "${dir.path}/PREM_Details_${DateTime.now().millisecondsSinceEpoch}.pdf");
        await file.writeAsBytes(bytes);
        Fluttertoast.showToast(msg: "PDF saved to: ${file.path}");
        // await OpenFilex.open(file.path);
      }
    } catch (e, s) {
      log("PDF Generation Error: $e\n$s");
      Fluttertoast.showToast(msg: "Failed to generate PDF");
    }
  }

  /// 🔹 Section title (similar to “sectionTitle” in your Burns PDF)
  pw.Widget sectionTitle(String title) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 6),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 14,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.blue700,
        ),
      ),
    );
  }

  /// 🔹 Label-Value row (similar to “infoRow” in your Burns PDF)
  pw.Widget infoRow(String label, String? value) {

    final displayValue =
    (value == null || value.trim().isEmpty) ? '-' : value;

    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: 180,
            child: pw.Text(
              "$label:",
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.black,
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              displayValue,
              style: pw.TextStyle(color: PdfColors.black),
            ),
          ),
        ],
      ),
    );
  }
}
