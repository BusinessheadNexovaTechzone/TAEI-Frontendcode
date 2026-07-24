import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/constants/urls.dart';
import 'package:taei_gov/src/poison/model/poisoning_details_model.dart'
    hide poisoningListModelFromJson;
import 'package:taei_gov/src/poison/model/poisoning_list_model.dart';
import 'package:taei_gov/src/poison/model/poisoning_lookup_model.dart';
import 'package:taei_gov/src/poison/model/poisoning_model.dart';

import 'package:taei_gov/utils/helpers/http_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

// import 'package:file_picker/file_picker.dart';
import 'package:universal_html/html.dart' as html;
import '../model/poisoning_dashboard_model.dart';

import 'dart:io';
import 'package:flutter/foundation.dart';

class PoisonController extends GetxController {
  RxInt currentIndex = 0.obs;
  RxString isPatientAdmitted = "".obs;
  RxString selectedSupportiveCare = "".obs;
  RxString isPatientAdmitted3 = "".obs;
  RxString isPatientAdmitted4 = "".obs;
  RxBool notFound = false.obs;
  var poisoningStartDate = Rxn<DateTime>();
  var poisoningEndDate = Rxn<DateTime>();

  Rx<PoisoningDetailsModel> poisoningDetails = PoisoningDetailsModel().obs;

  var poisoningDashBoard = PoisoningDashBoard().obs;
  var poisoningDataMap = <String, String>{}.obs;

  /// Poisoning Model
  Rx<PoisoningModel> poisoning = PoisoningModel(
    poison: Poison(),
    poisonsOutcome: PoisonsOutcome(),
  ).obs;

  static final _client = CustomHttpHelper();
  RxList<PoisoningListData> poisoningList = <PoisoningListData>[].obs;
  Rx<PoisoningLookUpModel> poisoningLookup = PoisoningLookUpModel().obs;
  RxBool isLoading = false.obs;

  Future<T> _withLoader<T>(Future<T> Function() task) async {
    try {
      isLoading.value = true;
      return await task();
    } finally {
      isLoading.value = false;
    }
  }

  void changeIndex(int index) {
    currentIndex.value = index;
  }

  /// Pagination
  var poisoningCurrentPage = 1.obs;
  var poisoningTotalPages = 1.obs;
  final int poisoningLimit = 20;
  var poisoningTotalCount = 0.obs;
  RxString dischargeStatus = "".obs;
  var searchText = "".obs;

// filtered list getter
//   List<PoisoningListData> get filteredPoisoningList {
//     if (searchText.value.isEmpty) {
//       return poisoningList;
//     }
//     return poisoningList.where((e) {
//       final name = (e.nameOfPatient ?? "").toLowerCase();
//       return name.contains(searchText.value.toLowerCase());
//     }).toList();
//   }

  Future<bool> getPoisonList({
    required String startDate,
    required String endDate,
    String patientName = "",
    String dischargeStatus = "",
    int pageNumber = 1,
  }) async {
    try {
      var url = Uri.parse(Urls.getPoisoningList +
          "list?limit=$poisoningLimit&offset=$pageNumber&start_date=$startDate&end_date=$endDate&patient_name=$patientName&discharge_status=$dischargeStatus");
      var response = await _client.get(url);
      if (response.body.isNotEmpty) {
        log('GetListPoison response: ${response.body}');
        var data = poisoningListModelFromJson(response.body);
        if (data.poisoningData != null) {
          poisoningList.assignAll(data.poisoningData ?? []);
          log('getTrauma123 response: ${poisoningList.toString()}');
          poisoningTotalCount.value = data.totalCount ?? 0;
          poisoningTotalPages.value =
              (poisoningTotalCount.value / poisoningLimit)
                  .ceil()
                  .clamp(1, double.infinity)
                  .toInt();
          poisoningStartDate.value = DateTime.parse(startDate);
          poisoningEndDate.value = DateTime.parse(endDate);
          poisoningCurrentPage.value = pageNumber;
          Fluttertoast.showToast(msg: "Data loaded successfully");

          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (ex) {
      log("getListEmo error: $ex");
      return false;
    }
  }

  Future<bool> createPoison({required PoisoningModel data}) async {
    try {
      isLoading.value = true;
      log(data.toString());
      var url = Uri.parse(Urls.createPoisoning);
      var response = await _client.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(data.toCleanJson()));
      log(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var d = jsonDecode(response.body);
        Fluttertoast.showToast(msg: "Data created successfully");
        isLoading.value = false;

        await getPoisonList(
          startDate: DateFormat('yyyy-MM-dd 00:00:00')
              .format(DateTime.now().subtract(const Duration(days: 7))),
          endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
          dischargeStatus: dischargeStatus.value,
        );
        await getPoisoningDashboard(
          startDate: DateFormat('yyyy-MM-dd 00:00:00')
              .format(DateTime.now().subtract(const Duration(days: 7))),
          endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
        );
        log("MY Discharge Status Created: ${dischargeStatus.value}");
        Get.back();
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

  Future<bool> getByPoisonById({required String id}) async {
    try {
      log(id.toString());
      var url = Uri.parse(Urls.getPoisoningById + id);
      var response = await _client.get(
        url,
      );
      print(url);
      log('getPoi response: ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        var d = jsonDecode(response.body);
        log('getPoison response LLL: ${d.toString()}');
        poisoning.value = PoisoningModel.fromJson(d);
        log('getPoison response MM: ${d.toString()}');
        log('getPoison response Value: ${poisoning.value.toString()}');
        Fluttertoast.showToast(msg: "Data loaded successfully");
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      return false;
    }
  }

  Future<bool> updatePoison(
      {required PoisoningModel data, required String id}) async {
    try {
      isLoading.value = true;
      var url = Uri.parse(Urls.updatePoisoning + id);
      var response = await _client.put(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(data.toJson()));
      if (response.statusCode == 200 || response.statusCode == 201) {
        log('updatePoison response: ${response.body}');
        Fluttertoast.showToast(msg: "Data updated successfully");
        isLoading.value = false;
        log("MY Discharge Status Update 66: ${dischargeStatus.value}");
        getPoisonList(
          startDate: DateFormat('yyyy-MM-dd 00:00:00')
              .format(DateTime.now().subtract(const Duration(days: 7))),
          endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
          dischargeStatus: dischargeStatus.value,
        );
        getPoisoningDashboard(
          startDate: DateFormat('yyyy-MM-dd 00:00:00')
              .format(DateTime.now().subtract(const Duration(days: 7))),
          endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
        );
        log("MY Discharge Status Update: ${dischargeStatus.value}");
        Get.back();
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

  Future<bool> getPoisonByTriageId({required String id}) async {
    // return _withLoader(() async {
    try {
      isLoading.value = true;

      var url = Uri.parse("${Urls.getPoisonByTriageId}$id");
      var response = await _client.get(url);
      log('getBitesById response: ${response.statusCode} | ${response.body}');

      if (response.statusCode == 404) {
        notFound.value = true;
      }

      debugPrint(notFound.value.toString() + "JHHjhsdhjhsjdh");

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        var d = jsonDecode(response.body);

        poisoning.value = PoisoningModel.fromJson(d);
        Fluttertoast.showToast(msg: "Data Get successfully");
        if (d["message"] != null) Fluttertoast.showToast(msg: d["message"]);
        isLoading.value = false;
        return true;
      } else {
        Fluttertoast.showToast(msg: "Record not found");
        isLoading.value = false;
        return false;
      }
    } catch (ex, stackTrace) {
      isLoading.value = false;
      log("getBitesById exception: $ex\n$stackTrace");
      Fluttertoast.showToast(msg: "Error: $ex");
      return false;
    }
  }

  Future<bool> getPoisonLookup() async {
    try {
      var url = Uri.parse(Urls.getPoisoningLookup);
      var response = await _client.get(url);
      log('getEmoLookup response: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        var list = poisoningLookUpModelFromJson(response.body);
        poisoningLookup.value = list;
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      log("getEmoLookup error: $ex");
      return false;
    }
  }

  Future<bool> getPoisoningDashboard(
      {required String startDate, required String endDate}) async {
    try {
      var url = Uri.parse(Urls.getPoisoningDashboard +
          "?start_date=$startDate&end_date=$endDate");
      var response = await _client.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      });
      log('getEmoLookup response: ${response.body}');

      if (response.body.isNotEmpty) {
        var list = poisoningDashBoardFromJson(response.body);
        poisoningDashBoard.value = list.first ?? PoisoningDashBoard();
        poisoningDataMap.value = {
          "Total": poisoningDashBoard.value.total.toString(),
          "Mild": poisoningDashBoard.value.mild.toString(),
          "Moderate": poisoningDashBoard.value.moderate.toString(),
          "Severe": poisoningDashBoard.value.severe.toString(),
          "IFT": poisoningDashBoard.value.ift.toString(),
          "Admitted": poisoningDashBoard.value.admitted.toString(),
          "Pending": poisoningDashBoard.value.pending.toString(),
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

  Future<void> fetchPoisoning({required String triageId}) async {
    try {
      isLoading(true);

      final url = Uri.parse(Urls.getPoisoningDetails + triageId);
      final response = await _client.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);
        poisoningDetails.value = PoisoningDetailsModel.fromJson(jsonMap);
        log("Successfully fetched and parsed the record.");
      } else {
        log("API Error - Status: ${response.statusCode}, Body: ${response.body}");
        Get.snackbar(
          "API Error",
          "Failed to fetch record. Status: ${response.statusCode}",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e, st) {
      log("Exception: $e\n$st");
      Get.snackbar("Exception", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  // Future<bool> getPoision({required String id}) async {
  //   try {
  //     isLoading(true);
  //     log("Fetching stroke details for id: $id");
  //     var url = Uri.parse(Urls.getPoisionDetails + id);
  //     var response = await _client.get(url);
  //     log('Stroke Details: (${response.statusCode}) ${response.body}');
  //
  //     if (response.statusCode == 200 && response.body.isNotEmpty) {
  //       var d = jsonDecode(response.body);
  //       poisoningDetails.value = poison.PoisonModeldetail1.fromJson(d);
  //       Fluttertoast.showToast(msg: 'Details Fetched Successfully');
  //       // await generateStrokePdf(StrokDetails.value!);
  //       return true;
  //     } else {
  //       Fluttertoast.showToast(msg: 'No data found');
  //       return false;
  //     }
  //   } catch (ex, stack) {
  //     Fluttertoast.showToast(msg: 'Failed to fetch details');
  //     return false;
  //   } finally {
  //     isLoading(false);
  //   }
  // }

  Future<void> generatePoisonPdf(PoisoningDetailsModel data) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) => [
            pw.Center(
              child: pw.Text(
                "Poison Case Details",
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue900,
                ),
              ),
            ),
            pw.SizedBox(height: 20),
            _sectionHeader("Poison Details"),
            _buildDetailsTable({
              "Patient Admitted": data.poisons?.patientAdmitted,
              "Department": data.poisons?.nameOfDept,
              "Admission Date": data.poisons?.dateOfAdmit,
              "Type of Poisoning": data.poisons?.typeOfPoisoning,
              "Route of Exposure": data.poisons?.routeOfExposure,
              "Substance Involved": data.poisons?.substanceInvolved,
              "Substance Sub": data.poisons?.substanceInvolvedSub,
              "Brand Name": data.poisons?.brandOrProductName,
              "Quantity": data.poisons?.quantity,
              "Source": data.poisons?.sourceOfSubstance,
              "Symptoms": data.poisons?.symptomsAtPresentation,
              "Severity": data.poisons?.severityOfPoisoning,
              "Antidote Name": data.poisons?.antidoteAdministeredName,
              "Antidote Dosage": data.poisons?.antidoteAdministeredDosage,
              "Antidote Timing": data.poisons?.antidoteAdministeredTiming,
              "Supportive Care": data.poisons?.supportiveCareProvided,
              "Counselling Provided": data.poisons?.counsellingProvided,
            }),
            pw.SizedBox(height: 15),
            _sectionHeader("Poison Outcome"),
            _buildDetailsTable({
              "Outcome": data.poisonsOutcome?.outcome,
              "Discharge Date": data.poisonsOutcome?.dischargeDate,
              "Absconded Date": data.poisonsOutcome?.abscondedDate,
              "Death Date": data.poisonsOutcome?.deathDate,
              "Cause of Death": data.poisonsOutcome?.causeOfDeath,
              "Hospital Type": data.poisonsOutcome?.hospitalType,
              "Destination Hospital": data.poisonsOutcome?.destinationHospital,
              "Reason for Referral": data.poisonsOutcome?.reasonForReferral,
              "Condition of Patient": data.poisonsOutcome?.conditionOfPatient,
              "Referring Doctor": data.poisonsOutcome?.referringDoctor,
              "TAEI Sheet Documented": data.poisonsOutcome?.documentedTaeiSheet,
              "Patient Exit Date": data.poisonsOutcome?.patientExitDate,
            }),
          ],
        ),
      );

      final pdfBytes = await pdf.save();
      final fileName =
          "Poison_Details_${DateTime.now().millisecondsSinceEpoch}.pdf";

      if (kIsWeb) {
        // ✅ Web download
        final blob = html.Blob([pdfBytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", fileName)
          ..click();
        html.Url.revokeObjectUrl(url);
        Fluttertoast.showToast(msg: "PDF downloaded successfully");
        return;
      }

      // ✅ Mobile & Desktop (directory selection)
      String? selectedDirectory =
          (await getApplicationDocumentsDirectory()) as String?;

      String filePath;
      if (selectedDirectory != null) {
        // User picked a directory
        filePath = "$selectedDirectory/$fileName";
      } else {
        // Default path if user cancels folder picker
        final dir = await getApplicationDocumentsDirectory();
        filePath = "${dir.path}/$fileName";
      }

      final file = File(filePath);
      await file.writeAsBytes(pdfBytes);
      Fluttertoast.showToast(msg: "PDF saved to: $filePath");
      log("PDF saved to: $filePath");
    } catch (e, st) {
      log("PDF generation error: $e\n$st");
      Fluttertoast.showToast(msg: "Failed to generate PDF");
    }
  }

  pw.Widget _sectionHeader(String title) => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 8),
        child: pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.red900,
          ),
        ),
      );

  pw.Widget _buildDetailsTable(Map<String, dynamic> details) {
    final entries = details.entries.toList(); // ❌ do NOT filter

    return pw.Table(
      columnWidths: const {
        0: pw.FlexColumnWidth(4),
        1: pw.FlexColumnWidth(6),
      },
      children: entries.map((e) {
        final value =
        (e.value == null || e.value.toString().trim().isEmpty)
            ? '-'
            : e.value.toString();

        return pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(
                '${e.key}:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(value),
            ),
          ],
        );
      }).toList(),
    );
  }

}
