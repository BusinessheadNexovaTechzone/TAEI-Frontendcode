import 'dart:convert';
import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:taei_gov/constants/urls.dart';
import 'package:taei_gov/src/hang/model/hanging_dashboard_model.dart';
import 'package:taei_gov/src/hang/model/hanging_list_model.dart';
import 'package:taei_gov/src/hang/model/hanging_model.dart';
import 'package:taei_gov/src/hang/model/look_up.dart';
import 'package:taei_gov/utils/helpers/http_helper.dart';

import '../../../utils/helpers/loading_helper.dart';
import '../model/hangDetails.dart';
import '../service/hang_service.dart';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
// import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;

class HangController1 extends GetxController {
  RxInt currentIndex = 0.obs;
  var lookupList = Rxn<HangingLookup>();
  RxBool isLookupLoading = true.obs;
  var startDate = Rxn<DateTime>();
  var endDate = Rxn<DateTime>();
  var hangingDashboard = HangingDashBoard().obs;

  var hangingDataMap = <String, String>{}.obs;
  static final _client = CustomHttpHelper();

  // Use Rxn for a nullable single details object
  var hangingDetails = Rxn<HangingDetails>();

  // Loading indicator used by the UI
  RxBool isLoading = false.obs;

  Future<bool> getHangDetails({required String id}) async {
    try {
      isLoading(true);
      log("Fetching hang details for id: $id");
      var url = Uri.parse(Urls.getHangingDetails + id);
      var response = await _client.get(url);
      log('Triage Details: (${response.statusCode}) ${response.body}');

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        var d = jsonDecode(response.body);
        hangingDetails.value = HangingDetails.fromJson(d);
        Fluttertoast.showToast(msg: 'Details Fetched Successfully');
        return true;
      } else {
        Fluttertoast.showToast(msg: 'No data found');
        return false;
      }
    } catch (ex, stack) {
      log("getHangDetails error: $ex\n$stack");
      Fluttertoast.showToast(msg: 'Failed to fetch details');
      return false;
    } finally {
      isLoading(false);
    }
  }

  Future<void> generateHangDetailsPdf() async {
    try {
      final data = hangingDetails.value;
      if (data == null) {
        Fluttertoast.showToast(msg: "No data available to generate PDF");
        return;
      }

      final hanging = data.hanging;
      final outcome = data.outcome;

      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(24),
          build: (context) => [
            pw.Center(
              child: pw.Text(
                "TAEI HANGING CASE SUMMARY REPORT",
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue800,
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
            pw.SizedBox(height: 16),
            sectionTitle("Hanging Case Information"),
            infoRow("Nature of Incident", hanging?.natureOfIncident),
            infoRow("Suspension Type", hanging?.suspensionOfBody),
            infoRow("Materials Used", hanging?.materialsUsedForHanging),
            infoRow(
                "Symptoms at Presentation", hanging?.symptomsAtPresentation),

            pw.Divider(),

            // Section 2: Interventions & Supportive Care
            sectionTitle("Interventions & Supportive Care"),
            infoRow("Interventions", hanging?.interventions),
            infoRow("Other Interventions", hanging?.othInterventions),
            infoRow(
                "Supportive Care Provided", hanging?.supportiveCareProvided),
            infoRow(
                "Other Supportive Care", hanging?.othSupportiveCareProvided),
            infoRow("Counselling Provided", hanging?.isCounsellingProvided),
            infoRow("Duration of Stay (days)",
                hanging?.durationOfHospitalStay?.toString()),

            pw.Divider(),

            // Section 3: Admission Details
            sectionTitle("Admission Details"),
            infoRow("Department", hanging?.nameOfDept),
            infoRow("Patient Admitted", hanging?.patientAdmitted),
            infoRow("Admission Date", hanging?.dateOfAdmit),
            infoRow("User ID", hanging?.userId?.toString()),
            infoRow("Inserted Date", hanging?.insertedDate),

            pw.Divider(),

            // Section 4: Outcome Details
            sectionTitle("Outcome Details"),
            infoRow("Outcome", outcome?.outcome),
            infoRow("Discharge Date", outcome?.dischargeDate),
            infoRow("Condition of Patient", outcome?.conditionOfPatient),
            infoRow("Hospital Type", outcome?.hospitalType),
            infoRow("Destination Hospital", outcome?.destinationHospital),
            infoRow(
                "Destination TAEI Hospital", outcome?.destinationTaeiHospital),
            infoRow("Referring Doctor", outcome?.referringDoctor),
            infoRow("TAEI Sheet Documented", outcome?.documentedTaeiSheet),

            pw.SizedBox(height: 20),
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

      // ✅ Save or Download File
      final bytes = await pdf.save();

      if (kIsWeb) {
        final blob = html.Blob([bytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", "Hanging_Case_Report.pdf")
          ..click();
        html.Url.revokeObjectUrl(url);
        Fluttertoast.showToast(msg: "PDF downloaded successfully");
      } else {
        final dir = await getApplicationDocumentsDirectory();
        final file = File(
            "${dir.path}/Hanging_Case_${DateTime.now().millisecondsSinceEpoch}.pdf");
        await file.writeAsBytes(bytes);
        Fluttertoast.showToast(msg: "PDF saved to: ${file.path}");
        // await OpenFilex.open(file.path);
      }
    } catch (e, s) {
      log("❌ PDF Generation Error: $e\n$s");
      Fluttertoast.showToast(msg: "Failed to generate PDF");
    }
  }

  /// 📘 Section Title
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

  /// 🩺 Info Row (Label & Value)
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

// other methods (lookup, lists, create/update etc) remain unchanged...
}
