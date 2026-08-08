import 'dart:convert';
import 'dart:developer';
// import 'package:file_picker/file_picker.dart';

import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:taei_gov/constants/urls.dart';
import 'package:taei_gov/src/hang/model/hanging_dashboard_model.dart';
import 'package:taei_gov/src/hang/model/look_up.dart';
import 'package:taei_gov/utils/helpers/http_helper.dart';

import '../models/script_detailscreen.dart';

import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;

class ScriptController1 extends GetxController {
  RxInt currentIndex = 0.obs;
  var lookupList = Rxn<HangingLookup>();
  RxBool isLookupLoading = true.obs;
  var startDate = Rxn<DateTime>();
  var endDate = Rxn<DateTime>();
  var hangingDashboard = HangingDashBoard().obs;

  var hangingDataMap = <String, String>{}.obs;
  static final _client = CustomHttpHelper();

  // Use Rxn for a nullable single details object
  var StrokDetails = Rxn<StrokeDetails>();

  // Loading indicator used by the UI
  RxBool isLoading = false.obs;

  Future<bool> getStrokeDetails({required String id}) async {
    try {
      isLoading(true);
      log("Fetching stroke details for id: $id");
      var url = Uri.parse(Urls.getStrokeDetails + id);
      var response = await _client.get(url);
      log('Stroke Details: (${response.statusCode}) ${response.body}');

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        var d = jsonDecode(response.body);
        StrokDetails.value = StrokeDetails.fromJson(d);
        Fluttertoast.showToast(msg: 'Details Fetched Successfully');
        // await generateStrokePdf(StrokDetails.value!);
        return true;
      } else {
        Fluttertoast.showToast(msg: 'No data found');
        return false;
      }
    } catch (ex, stack) {
      log("getStrokeDetails error: $ex\n$stack");
      Fluttertoast.showToast(msg: 'Failed to fetch details');
      return false;
    } finally {
      isLoading(false);
    }
  }

  /// 🧾 Generate Stroke Details PDF (same format as CaseList PDF)
  Future<void> generateStrokePdf(StrokeDetails data) async {
    final pdf = pw.Document();

    // 🔹 LOAD LOGOS
    final logo1 = pw.MemoryImage(
      (await rootBundle.load('assets/logo/test2.jpeg'))
          .buffer
          .asUint8List(),
    );
    final logo2 = pw.MemoryImage(
      (await rootBundle.load('assets/logo/tn_logo.png'))
          .buffer
          .asUint8List(),
    );
    final logo3 = pw.MemoryImage(
      (await rootBundle.load('assets/logo/taei_logo.jpeg'))
          .buffer
          .asUint8List(),
    );

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

    pw.Widget infoRow(String label, dynamic value) {
      final text =
      (value == null || value.toString().trim().isEmpty)
          ? '-' * 40
          : value.toString();

      return pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 12, top: 6),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.SizedBox(
              width: 160,
              child: pw.Text(
                "$label:",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Expanded(
              child: pw.Text(
                text,
                style: pw.TextStyle(letterSpacing: 1.2),
              ),
            ),
          ],
        ),
      );
    }

    final stroke = data.stroke;
    final outcome = data.outcome;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [

          // 🔷 HEADER WITH LOGOS
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Image(logo1, width: 60, height: 60),
              pw.Image(logo2, width: 58, height: 55),
              pw.Image(logo3, width: 58, height: 55),
            ],
          ),

          pw.SizedBox(height: 10),

          pw.Center(
            child: pw.Text(
              "Stroke Case Report",
              style: pw.TextStyle(
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue800,
              ),
            ),
          ),

          pw.SizedBox(height: 16),

          // 🧠 Stroke Information
          sectionTitle("Stroke Information"),

          infoRow("Stroke ID", stroke?.id),
          infoRow("Triage ID", stroke?.triageId),

          infoRow("Date/Time of Entry", stroke?.dateTimeOfEntry),
          infoRow("Arrival Time (Symptoms)", stroke?.arrivalTimeSymptoms),
          infoRow("Reason for Delay", stroke?.reasonForDelay),
          infoRow("Scene / IFT", stroke?.sceneIft),

          infoRow("Referred From", stroke?.referredFrom),
          infoRow("Reason for Referral", stroke?.reasonForReferral),
          infoRow("Other Reason for Referral", stroke?.othReasonForReferral),

          infoRow("Admitted", stroke?.admitted),
          infoRow("Admitted Date & Time", stroke?.admittedDateTime),

          infoRow("Lysis Done Outside", stroke?.lysisDoneOutside),
          infoRow("Lysis Outside Date", stroke?.lysisDoneOutsideDate),

          infoRow("Symptoms", stroke?.symptoms),

          infoRow("Absolute Contraindication",
              stroke?.absoluteContraindication),
          infoRow("Other Absolute Contraindication",
              stroke?.othAbsoluteContraindication),

          infoRow("NIHSS Scale", stroke?.nihsScale),

          infoRow("CBG", stroke?.cbg),
          infoRow("CBG Date", stroke?.cbgDate),

          infoRow("History of Anticoagulant",
              stroke?.historyOfAnticoagulant),

          infoRow(
            "Blood Pressure (SBP / DBP)",
            stroke?.bpSbp != null || stroke?.bpDbp != null
                ? "${stroke?.bpSbp ?? '-'} / ${stroke?.bpDbp ?? '-'}"
                : null,
          ),

          infoRow("ASPECT Score", stroke?.aspectScore),

          infoRow("CT Scan", stroke?.ctScan),
          infoRow("CT Scan Date", stroke?.ctScanDate),

          infoRow("MRI Scan", stroke?.mriScan),
          infoRow("MRI Scan Date", stroke?.mriScanDate),
          infoRow("MRI Scan Eligibility",
              stroke?.mriScanEligibility),

          infoRow("Cath Lab Procedure",
              stroke?.cathLabProcedure),
          infoRow("Cath Lab Procedure Date",
              stroke?.cathLabProcedureDate),

          infoRow("Procedure Done", stroke?.procedureDone),
          infoRow("Name of Procedure", stroke?.nameOfProcedure),

          infoRow("Stroke Type", stroke?.type),

          infoRow("Lysis Done", stroke?.lysisDone),
          infoRow("Lysis Date", stroke?.lysisDate),

          infoRow("Thrombolysis Drug",
              stroke?.thrombolysisByDrug),

          infoRow("Thrombectomy", stroke?.thrombectomy),
          infoRow("Thrombectomy Details",
              stroke?.thrombectomyDtls),

          infoRow("Decompression Craniectomy",
              stroke?.decompressionCraniectomy),
          infoRow("Decompression Craniectomy Details",
              stroke?.decompressionCraniectomyDtls),

          infoRow("Drug Prescribed", stroke?.drugPrescribed),

          infoRow("User ID", stroke?.userId),
          infoRow("Inserted Date", stroke?.insertedDate),
          infoRow("Reference Form ID", stroke?.refFormId),
          infoRow("Reference ID", stroke?.refId),
          sectionTitle("Outcome Details"),

          infoRow("Outcome", outcome?.outcome),

          infoRow("Discharge Date", outcome?.dischargeDate),
          infoRow("Discharge Static Date",
              outcome?.dischargeStaticDate),

          infoRow("DAMA Date", outcome?.damaDate),
          infoRow("Absconded Date", outcome?.abscondedDate),

          infoRow("Death Date", outcome?.deathDate),
          infoRow("Cause of Death", outcome?.causeOfDeath),

          infoRow("Transferred Ward Date",
              outcome?.transferredWardDate),
          infoRow("Transferred ICU Date",
              outcome?.transferredIcuDate),

          infoRow("Transferred To", outcome?.transferredTo),

          infoRow("Hospital Type", outcome?.hospitalType),

          infoRow("Destination Hospital",
              outcome?.destinationHospital),
          infoRow("Destination TAEI Hospital",
              outcome?.destinationTaeiHospital),

          infoRow("Reason for Referral",
              outcome?.reasonForReferral),

          infoRow("Condition of Patient",
              outcome?.conditionOfPatient),

          infoRow("Referring Doctor",
              outcome?.referringDoctor),

          infoRow("TAEI Sheet Documented",
              outcome?.documentedTaeiSheet),

          infoRow("Treatment Given",
              outcome?.treatmentGiven),

          infoRow("Duration of Stay (Days)",
              outcome?.durationStay),

          infoRow("Is Discharged",
              outcome?.is_discharged),



          pw.SizedBox(height: 20),

          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              "Generated by TAEI System  "
                  "${DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now())}",
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

    // 🌐 WEB
    if (kIsWeb) {
      final blob = html.Blob([bytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute(
          "download",
          "Stroke_Details_${DateTime.now().millisecondsSinceEpoch}.pdf",
        )
        ..click();
      html.Url.revokeObjectUrl(url);
      return;
    }

    // 📱 MOBILE
    final dir = await getApplicationDocumentsDirectory();
    final file = File(
      "${dir.path}/Stroke_Details_${DateTime.now().millisecondsSinceEpoch}.pdf",
    );
    await file.writeAsBytes(bytes);
    Fluttertoast.showToast(msg: "✅ PDF saved to: ${file.path}");
  }
}
