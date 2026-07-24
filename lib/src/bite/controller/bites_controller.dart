import 'dart:convert';
import 'dart:developer';
import 'dart:ui' as pw;
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:taei_gov/src/bite/model/bitesstings_dashboard_model.dart';
import '../../../constants/urls.dart';
import '../../../utils/helpers/http_helper.dart';
import '../model/detailPage.dart';
import '../model/look_up_bites.dart';
import '../model/bites_modelGet.dart';
import '../model/request_model.dart';
import '../model/request_model.dart' as req;
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

// Use universal_html for safe web DOM access behind kIsWeb checks.
import 'package:universal_html/html.dart' as html;

class BitesController extends GetxController {
  Rx<BitesStingsRequestModel> bitesModelRequest = BitesStingsRequestModel(
    bitesStings: req.BitesStings(),
    outcome: req.OutcomeModel(),
  ).obs;

  var ListData = <BitesRow>[].obs;
  Rx<LookUpBiteStingMasterModel> bitesLookUp = LookUpBiteStingMasterModel().obs;
  RxBool isLoading = false.obs;
  RxBool notFound = false.obs;

  var filteredOrganismRefs = <TypeOfOrganism>[].obs;
  var bitesStartDate = Rxn<DateTime>();
  var bitesEndDate = Rxn<DateTime>();
  static final _client = CustomHttpHelper();

  var bitesStingsDashboard = BitesStingsDashBoard().obs;
  var bitesStingsDataMap = <String, String>{}.obs;

  Rx<BitesStingsDetails> bitesDetails = BitesStingsDetails().obs;

  /// ✅ Helper to wrap async calls with loader
  Future<T> _withLoader<T>(Future<T> Function() task) async {
    try {
      isLoading.value = true;
      return await task();
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createBites({required BitesStingsRequestModel data}) async {
    return _withLoader(() async {
      try {
        final jsonBody = jsonEncode(data.toJson());
        final encoder = JsonEncoder.withIndent('  ');
        debugPrint("Request JSON:\n${encoder.convert(data.toJson())}");

        var url = Uri.parse(Urls.createBites);
        var response = await _client.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonBody,
        );

        try {
          final responseJson = jsonDecode(response.body);
          debugPrint("Response:\n${encoder.convert(responseJson)}");
        } catch (_) {
          debugPrint("Response: ${response.body}");
        }

        if (response.statusCode == 200 || response.statusCode == 201) {
          var d = jsonDecode(response.body);
          //if (d["message"] != null) Fluttertoast.showToast(msg: d["message"]);
          //Get.back();
          getListBites(
            startDate: DateFormat('yyyy-MM-dd 00:00:00')
                .format(DateTime.now().subtract(Duration(days: 7))),
            endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
            dischargeStatus: dischargeStatus.value,
          );
          getBitesStingsDashboard(
            startDate: DateFormat('yyyy-MM-dd 00:00:00')
                .format(DateTime.now().subtract(Duration(days: 7))),
            endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
          );
          return true;
        } else {
          Fluttertoast.showToast(
              msg: "Failed to create record: ${response.statusCode}");
          return false;
        }
      } catch (ex, stackTrace) {
        debugPrint("createBites exception: $ex\n$stackTrace");
        Fluttertoast.showToast(msg: "Error: $ex");
        return false;
      }
    });
  }

  Future<bool> getBitesById({required String id}) async {
    return _withLoader(() async {
      try {
        var url = Uri.parse("${Urls.getBitesById}$id");
        var response = await _client.get(url);
        log('getBitesById response: ${response.statusCode} | ${response.body}');

        if (response.statusCode == 200 && response.body.isNotEmpty) {
          var d = jsonDecode(response.body);
          bitesModelRequest.value = BitesStingsRequestModel.fromJson(d);
          if (d["message"] != null) Fluttertoast.showToast(msg: d["message"]);
          return true;
        } else {
          Fluttertoast.showToast(msg: "Record not found");
          return false;
        }
      } catch (ex, stackTrace) {
        log("getBitesById exception: $ex\n$stackTrace");
        Fluttertoast.showToast(msg: "Error: $ex");
        return false;
      }
    });
  }

  Future<bool> getBitesByTriageId({required String id}) async {
    return _withLoader(() async {
      try {
        var url = Uri.parse("${Urls.getBitesByTriageId}$id");
        var response = await _client.get(url);
        log('getBitesById response: ${response.statusCode} | ${response.body}');

        if (response.statusCode == 404) {
          notFound.value = true;
        }

        debugPrint(notFound.value.toString() + "JHHjhsdhjhsjdh");

        if (response.statusCode == 200 && response.body.isNotEmpty) {
          var d = jsonDecode(response.body);
          bitesModelRequest.value = BitesStingsRequestModel.fromJson(d);
          if (d["message"] != null) Fluttertoast.showToast(msg: d["message"]);
          return true;
        } else {
          Fluttertoast.showToast(msg: "Record not found");
          return false;
        }
      } catch (ex, stackTrace) {
        log("getBitesById exception: $ex\n$stackTrace");
        Fluttertoast.showToast(msg: "Error: $ex");
        return false;
      }
    });
  }

  Future<bool> updateBites(
      {required BitesStingsRequestModel data, required String id}) async {
    debugPrint("${data.outcome?.causeOfDeath.toString()} karmo");
    return _withLoader(() async {
      try {
        var url = Uri.parse(Urls.updateBites + id);
        var response = await _client.put(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(data.toJson()),
        );

        if (response.body.isNotEmpty) {
          log('updateBites response: ${response.body}');
          Fluttertoast.showToast(msg: "Data updated successfully");
          getListBites(
            startDate: DateFormat('yyyy-MM-dd 00:00:00')
                .format(DateTime.now().subtract(Duration(days: 7))),
            endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
            dischargeStatus: dischargeStatus.value,
          );
          getBitesStingsDashboard(
            startDate: DateFormat('yyyy-MM-dd 00:00:00')
                .format(DateTime.now().subtract(Duration(days: 7))),
            endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
          );
          return true;
        } else {
          return false;
        }
      } catch (ex) {
        Fluttertoast.showToast(msg: "Error updating data");
        return false;
      }
    });
  }

  Future<void> deleteBites({required String id}) async {
    return _withLoader(() async {
      try {
        var url = Uri.parse("${Urls.deleteBites}$id");
        var response = await _client.delete(url);
        log("deleteBites response: ${response.statusCode} | ${response.body}");

        if (response.statusCode == 200 || response.statusCode == 204) {
          Fluttertoast.showToast(msg: "Record deleted");
          getListBites(
            startDate: DateFormat('yyyy-MM-dd 00:00:00').format(DateTime.now()),
            endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
            dischargeStatus: dischargeStatus.value,
          );
        } else {
          Fluttertoast.showToast(msg: "Failed to delete record");
        }
      } catch (ex, stackTrace) {
        log("deleteBites exception: $ex\n$stackTrace");
        Fluttertoast.showToast(msg: "Something went wrong: $ex");
      }
    });
  }

  /// Pagination
  var bitesCurrentPage = 1.obs;
  var bitesTotalPages = 1.obs;
  final int bitesLimit = 20;
  var bitesTotalCount = 0.obs;
  RxString dischargeStatus = "".obs;
  var searchText = "".obs;

// filtered list getter
  List<BitesRow> get filteredBitesList {
    if (searchText.value.isEmpty) {
      return ListData;
    }
    return ListData.where((e) {
      final name = (e.nameOfPatient ?? "").toLowerCase();
      return name.contains(searchText.value.toLowerCase());
    }).toList();
  }

  Future<bool> getListBites({
    required String startDate,
    required String endDate,
    String patientName = "",
    String dischargeStatus = "",
    int pageNumber = 1,
  }) async {
    return _withLoader(() async {
      try {
        var url = Uri.parse(Urls.getBites +
            "?limit=10&offset=1&start_date=$startDate&end_date=$endDate&patient_name=$patientName&discharge_status=$dischargeStatus");
        var response = await _client.get(url);
        log('getListBites response: ${response.statusCode} | ${response.body}');

        if (response.statusCode == 200 && response.body.isNotEmpty) {
          var bitesListResponse = biteStingModelFromJson1(response.body);
          ListData.assignAll(bitesListResponse.rows ?? []);
          log('getTrauma123 response: ${ListData.toString()}');
          bitesTotalCount.value = bitesListResponse.totalCount ?? 0;
          bitesTotalPages.value = (bitesTotalCount.value / bitesLimit)
              .ceil()
              .clamp(1, double.infinity)
              .toInt();
          bitesStartDate.value = DateTime.parse(startDate);
          bitesEndDate.value = DateTime.parse(endDate);
          bitesCurrentPage.value = pageNumber;
          return true;
        } else {
          return false;
        }
      } catch (ex, stackTrace) {
        log("getListBites exception: $ex\n$stackTrace");
        Fluttertoast.showToast(msg: "Error: $ex");
        return false;
      }
    });
  }

  Future<bool> getBitesLookup() async {
    return _withLoader(() async {
      try {
        var url = Uri.parse(Urls.getBitesLookup);
        var response = await _client.get(url);
        log('getBitesLookup response: ${response.body}');

        if (response.body.isNotEmpty) {
          var list = biteStingLookupModelFromJson(response.body);
          bitesLookUp.value = list;
          return true;
        } else {
          return false;
        }
      } catch (ex) {
        log("getBitesLookup error: $ex");
        return false;
      }
    });
  }

  Future<bool> getBitesDetails({required String id}) async {
    try {
      log("Fetching Bites Details for ID: $id");

      // ✅ Make GET request correctly
      var url = Uri.parse("${Urls.getBitesDetails}$id");
      var response = await _client.get(url); // <-- Correct usage

      log("Response (${response.statusCode}): ${response.body}");

      // ✅ Handle response safely
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        var decoded = jsonDecode(response.body);
        bitesDetails.value = BitesStingsDetails.fromJson(decoded);
        Fluttertoast.showToast(msg: 'Details fetched successfully');
        return true;
      } else {
        Fluttertoast.showToast(msg: 'No data found');
        return false;
      }
    } catch (ex, stack) {
      log("Error fetching bites details: $ex\n$stack");
      Fluttertoast.showToast(msg: 'Failed to fetch details');
      return false;
    }
  }

  /// ✅ Generate PDF
  Future<void> generateBitesDetailsPdf() async {
    try {
      final data = bitesDetails.value;
      if (data == null) {
        Fluttertoast.showToast(msg: "No data available to generate PDF");
        return;
      }
      final bites = data.bitesStings;
      final outcome = data.outcome;
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(24),
          build: (context) => [
            pw.Center(
              child: pw.Text(
                "TAEI BITES & STINGS CASE SUMMARY REPORT",
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.deepOrange,
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
            sectionTitle("Bite / Sting Information"),
            infoRow("Type of Bite / Sting", bites?.typeOfBiteSting),
            infoRow("Type of Organism", bites?.typeOfOrganism),
            infoRow("Venomous Type", bites?.venomousType),
            infoRow("Other Venomous Type", bites?.othVenomousType),
            infoRow("Site of Bite / Sting", bites?.siteOfBiteSting),
            infoRow("Symptoms", bites?.symptomsAtPresentation),
            infoRow("Signs of Envenomation",
                bites?.signsOfEnvenomationAllergicReaction),
            infoRow(
                "Time to Reach After Bite", bites?.timeToReachAfterBiteSting),
            infoRow("Investigations", bites?.investigationsPerformed),

            pw.Divider(),

            // Section 2: Treatment & Management
            sectionTitle("Treatment & Management"),
            infoRow("First Aid Given", bites?.firstAidGiven),
            infoRow("Anti-Venom / Allergy Treatment",
                bites?.antiVenomOrAllergyTreatmentName),
            infoRow("Dosage", bites?.antiVenomOrAllergyTreatmentDosage),
            infoRow("Timing", bites?.antiVenomOrAllergyTreatmentTiming),
            infoRow("Supportive Care", bites?.supportiveCareProvided),
            infoRow("Counselling Before Discharge",
                bites?.counsellingProvidedBeforeDischarge),
            infoRow("Duration of Stay (days)",
                bites?.durationOfHospitalStay?.toString()),

            pw.Divider(),

            // Section 3: Admission Details
            sectionTitle("Admission Details"),
            infoRow("Department", bites?.nameOfDept),
            infoRow("Admitted", bites?.patientAdmitted),
            infoRow("Admission Date", bites?.dateOfAdmit),
            infoRow("User ID", bites?.userId?.toString()),

            pw.Divider(),

            // Section 4: Outcome Details
            sectionTitle("Outcome Details"),
            infoRow("Outcome", outcome?.outcome),
            infoRow("Discharge Date", outcome?.dischargeDate),
            infoRow("Condition", outcome?.conditionOfPatient),
            infoRow("Hospital Type", outcome?.hospitalType),
            infoRow("Destination Hospital", outcome?.destinationHospital),
            infoRow("Referring Doctor", outcome?.referringDoctor),
            infoRow("TAEI Sheet Documented", outcome?.documentedTaeiSheet),
            infoRow("Exit Date", outcome?.patientExitDate),

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

      // Save or download the file
      final bytes = await pdf.save();

      if (kIsWeb) {
        final blob = html.Blob([bytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", "Bites_And_Stings_Report.pdf")
          ..click();
        html.Url.revokeObjectUrl(url);
        Fluttertoast.showToast(msg: "PDF downloaded successfully");
      } else {
        final dir = await getApplicationDocumentsDirectory();
        final file = File(
            "${dir.path}/Bites_And_Stings_${DateTime.now().millisecondsSinceEpoch}.pdf");
        await file.writeAsBytes(bytes);
        Fluttertoast.showToast(msg: "PDF saved to: ${file.path}");
        // await OpenFilex.open(file.path);
      }
    } catch (e, s) {
      log("❌ PDF Generation Error: $e\n$s");
      Fluttertoast.showToast(msg: "Failed to generate PDF");
    }
  }

  /// 📘 Section title widget
  pw.Widget sectionTitle(String title) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 6),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 14,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.deepOrange,
        ),
      ),
    );
  }

  /// 🩺 Label-value row widget
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
              style: const pw.TextStyle(color: PdfColors.black),
            ),
          ),
        ],
      ),
    );
  }







  Future<bool> getBitesStingsDashboard(
      {required String startDate, required String endDate}) async {
    try {
      var url = Uri.parse(Urls.getBitesStingsDashboard +
          "?start_date=$startDate&end_date=$endDate");
      var response = await _client.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      });
      log('getEmoLookup response: ${response.body}');

      if (response.body.isNotEmpty) {
        var list = bitesStingsDashBoardFromJson(response.body);
        bitesStingsDashboard.value = list.first ?? BitesStingsDashBoard();

        bitesStingsDataMap.value = {
          "Total": bitesStingsDashboard.value.total.toString(),
          "Venomous": bitesStingsDashboard.value.venomous.toString(),
          "Non Venomous": bitesStingsDashboard.value.nonVenomous.toString(),
          "IFT": bitesStingsDashboard.value.ift.toString(),
          "Admitted": bitesStingsDashboard.value.admitted.toString(),
          "Pending": bitesStingsDashboard.value.pending.toString(),
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
}
