import 'dart:convert';
import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/constants/urls.dart';
import 'package:taei_gov/src/emo_user/model/emo_dahboard_model.dart';
import 'package:taei_gov/src/emo_user/model/emo_details_model.dart';
import 'package:taei_gov/src/emo_user/model/emo_list_model.dart';
import 'package:taei_gov/src/emo_user/model/emo_lookup_model.dart';
import 'package:taei_gov/src/emo_user/model/emo_model.dart';
import 'package:taei_gov/utils/helpers/http_helper.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;

class EmoController extends GetxController {
  Rx<EmoModel> emoModel = EmoModel(
    emo: Emo(),
    emoOutcome: EmoOutcome(),
  ).obs;
  RxBool isOutcome = false.obs;

  // RxList<EmoModel> emoListData = <EmoModel>[].obs;
  RxList<EmoListData> emoList = <EmoListData>[].obs;
  Rx<EmoLooksUpModel> emoLookup = EmoLooksUpModel().obs;

  RxBool isLoading = false.obs;
  RxInt currentIndex = 0.obs;

  RxString searchController = ''.obs;

  RxInt pastHistory = 0.obs;
  RxString emergencyCategory = ''.obs;

  var emoStartDate = Rxn<DateTime>();
  var emoEndDate = Rxn<DateTime>();

  Rx<EmoDetailsModel> emoDetailsModel = EmoDetailsModel().obs;

  static final _client = CustomHttpHelper();

  Future<bool> createEmo({required EmoModel data}) async {
    isLoading.value = true;
    try {
      log(data.toString());
      log(jsonEncode(data.toCleanJson()));
      var url = Uri.parse(Urls.createEmo);
      var response = await _client.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(data.toCleanJson()));
      log(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Fluttertoast.showToast(msg: "Data created successfully");
        isLoading.value = true;
        await getEmoListData(
          startDate: DateFormat('yyyy-MM-dd 00:00:00')
              .format(DateTime.now().subtract(const Duration(days: 7))),
          endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
        );
        await fetchEmoDashboard(
          startDate: DateFormat('yyyy-MM-dd 00:00:00')
              .format(DateTime.now().subtract(const Duration(days: 7))),
          endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
        );
        isLoading.value = false;
        Get.back(result: true);
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

  Future<bool> getEmoById({required String id}) async {
    try {
      log(id.toString());
      var url = Uri.parse(Urls.getEmoById + id);
      var response = await _client.get(
        url,
      );
      print(url);
      log('getEmoById response: ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        var d = jsonDecode(response.body);
        emoModel.value = EmoModel.fromJson(d);
        Fluttertoast.showToast(msg: "Data loaded successfully");

        return true;
      } else {
        return false;
      }
    } catch (ex) {
      return false;
    }
  }

  Future<bool> updateEmo({required EmoModel data, required String id}) async {
    isLoading.value = true;
    try {
      // log(data.toString());
      var url = Uri.parse(Urls.updateEmo + id);
      var response = await _client.put(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(data.toJson()));
      if (response.statusCode == 200 || response.statusCode == 201) {
        log('updateEmo response: ${response.body}');
        // var d = jsonDecode(response.body);
        Fluttertoast.showToast(msg: "Data updated successfully");
        getEmoListData(
          startDate: DateFormat('yyyy-MM-dd 00:00:00')
              .format(DateTime.now().subtract(const Duration(days: 7))),
          endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
        );
        await fetchEmoDashboard(
          startDate: DateFormat('yyyy-MM-dd 00:00:00')
              .format(DateTime.now().subtract(const Duration(days: 7))),
          endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
        );
        Get.back();

        isLoading.value = false;
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

  Future<bool> deleteEmo({required String id}) async {
    try {
      log(id.toString());
      var url = Uri.parse(Urls.deleteEmo + id);
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

  // Future<bool> getListEmo() async {
  //   isLoading.value = true;
  //   try {
  //     var url = Uri.parse(Urls.getEmo);
  //     var response = await _client.get(url);
  //     log('getListEmo response: ${response.body}');
  //
  //     if (response.body.isNotEmpty) {
  //       var list = emoModelFromJson(response.body);
  //
  //       emoListData.assignAll(list);
  //
  //       Fluttertoast.showToast(msg: "Data loaded successfully");
  //       isLoading.value = false;
  //       return true;
  //     } else {
  //       isLoading.value = false;
  //       return false;
  //     }
  //   } catch (ex) {
  //     isLoading.value = false;
  //     log("getListEmo error: $ex");
  //     return false;
  //   }
  // }

  /// Pagination
  var emoCurrentPage = 1.obs;
  var emoTotalPages = 1.obs;
  final int emoLimit = 20;
  var emoTotalCount = 0.obs;

  var searchText = "".obs;

// filtered list getter
  List<EmoListData> get filteredEmoList {
    if (searchText.value.isEmpty) {
      return emoList;
    }

    return emoList.where((e) {
      final name = (e.nameOfPatient ?? "").toLowerCase();
      return name.contains(searchText.value.toLowerCase());
    }).toList();
  }

  Future<bool> getEmoListData({
    required String startDate,
    required String endDate,
    String patientName = "",
    String dischargeStatus = "",
    int pageNumber = 1, // offset in your API
    bool premBelow12Years = false,
  }) async {
    try {
      var url = Uri.parse(Urls.getEmoList +
          "list?limit=$emoLimit&offset=$pageNumber&start_date=$startDate&end_date=$endDate&patient_name=$patientName&discharge_status=$dischargeStatus&is_age12=$premBelow12Years");
      var response = await _client.get(url);
      log('New getListEmo response: ${response.body}');

      if (response.body.isNotEmpty) {
        var data = emoListDataModelFromJson(response.body);

        // assign only rows to emoList
        emoList.assignAll(data.rows ?? []);
        emoTotalCount.value = data.totalCount ?? 0;
        emoTotalPages.value = (emoTotalCount.value / emoLimit)
            .ceil()
            .clamp(1, double.infinity)
            .toInt();
        emoStartDate.value = DateTime.parse(startDate);
        emoEndDate.value = DateTime.parse(endDate);
        emoCurrentPage.value = pageNumber;

        log('HHHHHHHHHHHH ${emoList.length} items loaded');
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

  Future<bool> getEmoLookup() async {
    try {
      var url = Uri.parse(Urls.getEmoLookup);
      var response = await _client.get(url);
      log('getEmoLookup response: ${response.body}');

      if (response.body.isNotEmpty) {
        var list = emoLooksUpModelFromJson(response.body);
        emoLookup.value = list;

        return true;
      } else {
        return false;
      }
    } catch (ex) {
      log("getEmoLookup error: $ex");
      return false;
    }
  }

  var emoDashBoard = EmoDashBoard().obs;
  var emoDataMap = <String, String>{}.obs;

  ///// Triage Nurse Dash Board
  Future<bool> fetchEmoDashboard({
    required String startDate,
    required String endDate,
    bool premBelow12Years = false,
  }) async {
    try {
      final url = Uri.parse(
          "${Urls.getEMODashboard}?start_date=$startDate&end_date=$endDate&is_age12=$premBelow12Years");
      var response = await _client.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      });
      log('DAs${response.body}');
      if (response.body.isNotEmpty) {
        log('DASHBOARD${response.body}');
        final parsed = jsonDecode(response.body);
        final json = parsed is List ? parsed.first : parsed;
        emoDashBoard.value = EmoDashBoard.fromJson(json);
        emoDataMap.value = {
          "Total": emoDashBoard.value.total ?? '0',
          //"108": emoDashBoard.value.the108 ?? '0',
          "Red": emoDashBoard.value.red ?? '0',
          "Yellow": emoDashBoard.value.yellow ?? '0',
          "Green": emoDashBoard.value.green ?? '0',
          "Black": emoDashBoard.value.black ?? '0',
          "Pending": emoDashBoard.value.pending ?? '0'
        };

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error fetching dashboard: $e");
      return false;
    }
  }

  /// Get EMO Details
  Future<bool> getEmoDetails({required String id}) async {
    try {
      log(id.toString());
      var url = Uri.parse(Urls.getEmoDetails + id);
      var response = await _client.get(
        url,
      );
      log(response.body);
      if (response.statusCode == 200) {
        var d = jsonDecode(response.body);
        emoDetailsModel.value = EmoDetailsModel.fromJson(d);
        Fluttertoast.showToast(msg: "Emo details fetched successfully");
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      return false;
    }
  }

  filterSearch(String query) {
    // Filter only by patient name
    emoList.value = emoList.where((item) {
      final name = (item.nameOfPatient ?? '').toLowerCase();
      return name.contains(query.toLowerCase());
    }).toList();
  }

  Future<void> downloadEmoDetailsPdf({required String id}) async {
    try {
      // Step 1: Fetch API Data
      final url = Uri.parse(Urls.getEmoDetails + id);
      final response = await _client.get(url);

      if (response.body.isEmpty) {
        Fluttertoast.showToast(msg: "No EMO details found.");
        return;
      }

      final decoded = jsonDecode(response.body);
      emoDetailsModel.value = EmoDetailsModel.fromJson(decoded);
      final data = emoDetailsModel.value;
      Fluttertoast.showToast(msg: "EMO details fetched successfully");

      // Step 2: Create PDF Document
      final pdf = pw.Document();

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
        final displayValue = (value == null || value.toString().trim().isEmpty)
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

      // Step 3: Build PDF Layout
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) => [
            pw.Center(
              child: pw.Text(
                "TAEI EMO CASE SUMMARY",
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue900,
                ),
              ),
            ),
            pw.SizedBox(height: 12),
            // pw.Center(
            //   child: pw.Text(
            //     "Generated on ${DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now())}",
            //     style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
            //   ),
            // ),
            pw.SizedBox(height: 20),
            sectionTitle("Case Overview"),
            infoRow("Diagnosis", data.emo?.diagnosis),
            infoRow("Emergency Category", data.emo?.emergencyCategory),
            infoRow("Other Category", data.emo?.othEmergencyCategory),
            infoRow("MLC", data.emo?.isMlc),
            infoRow("Examined By", data.emo?.nameOfTheEmo),
            pw.Divider(),
            sectionTitle("Examination Details"),
            infoRow("Time of Examination", data.emo?.timeOfExamination),
            infoRow("Pain Scale", data.emo?.painScale),
            infoRow("Pain Score", data.emo?.painScore),
            infoRow("General Disposition", data.emo?.generalDisposition),
            infoRow("Speech", data.emo?.speech),
            infoRow("Clothing", data.emo?.clothing),
            infoRow("Reaction Time", data.emo?.reactionTime),
            infoRow("Orientation Time", data.emo?.orientationTime),
            pw.Divider(),
            sectionTitle("Alcohol / Drug History"),
            infoRow("Past History", data.emo?.pastHistory),
            infoRow("Smells Alcohol", data.emo?.isPatientSmellsAlcohol),
            infoRow("Alcohol Consumption", data.emo?.isAlcoholConsumption),
            infoRow("Drunken Drive", data.emo?.isDrunkenDriveHistory),
            infoRow("Smell in Breath", data.emo?.isSmellInBreath),
            infoRow("Urine Alcohol Test", data.emo?.isUrineAlcholConcentration),
            infoRow("Memory", data.emo?.memory),
            infoRow("Self Control", data.emo?.selfControl),
            infoRow("Drug Abuse", data.emo?.isDrugAbuse),
            pw.Divider(),
            sectionTitle("Legal / MLC Details"),
            infoRow("Is MLC", data.emo?.isMlc),
            infoRow("AR Number", data.emo?.arNumber),
            infoRow(
              "MLC Date",
              data.emo?.mlcDate != null
                  ? DateFormat('dd/MM/yyyy').format(data.emo?.mlcDate!)
                  : "-",
            ),
            infoRow("MLC Time", data.emo?.mlcTime),

            pw.Divider(),

            // 💊 Treatment Details
            sectionTitle("Treatment Details"),
            infoRow("Treatment Given", data.emo?.treatmentGiven),
            infoRow("Trauma Treatment", data.emo?.emoTraumaTreatment),
            infoRow("Examined By", data.emo?.nameOfTheEmo),

            pw.Divider(),
            sectionTitle('Emo OutCome'),
            infoRow('Outcome', data.outcome?.outcome),
            infoRow('Outcome DateTime', data.outcome?.outcomeDatetime),
            infoRow('Sent To', data.outcome?.sentTo),
            infoRow('Hospital Type', data.outcome?.hospitalType),
            infoRow('Destination Hospital', data.outcome?.destinationHospital),
            infoRow('TAEI Hospital', data.outcome?.destinationTaeiHospital),
            infoRow('Reason For Referral', data.outcome?.reasonForReferral),
            infoRow('Condition Of Patient', data.outcome?.conditionOfPatient),
            infoRow('Referring Doctor', data.outcome?.referringDoctorName),
            infoRow('Is Discharged', data.outcome?.isDischarged),

            pw.SizedBox(height: 20),
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

      // Step 4: Save or Download PDF
      final bytes = await pdf.save();

      if (kIsWeb) {
        final blob = html.Blob([bytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download",
              "EMO_Case_${DateTime.now().millisecondsSinceEpoch}.pdf")
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        final dir = await getApplicationDocumentsDirectory();
        final file = File(
            "${dir.path}/EMO_Case_${DateTime.now().millisecondsSinceEpoch}.pdf");
        await file.writeAsBytes(bytes);
        Fluttertoast.showToast(msg: "PDF saved to: ${file.path}");
      }
    } catch (e, st) {
      Fluttertoast.showToast(msg: "Failed to generate PDF: $e");
      log("PDF Generation Error: $e\n$st");
    }
  }
}
