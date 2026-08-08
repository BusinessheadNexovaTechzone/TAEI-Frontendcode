import 'dart:convert';
import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:taei_gov/constants/urls.dart';
import 'package:taei_gov/src/burn/models/burn_lookup_model.dart';
import 'package:taei_gov/src/burn/models/burns_dashboard_model.dart';
import 'package:taei_gov/src/burn/models/burns_details_page.dart';
import 'package:taei_gov/src/burn/models/burns_list_model.dart';
import 'package:taei_gov/src/burn/models/create_burn_model.dart';
import 'package:taei_gov/src/burn/service/burn_service.dart';
import 'package:taei_gov/utils/helpers/http_helper.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;

class BurnController extends GetxController {
  RxInt currentIndex = 0.obs;
  RxString dischargeStatus = ''.obs;

  RxInt pastHistory = 0.obs;

  RxString visitType = ''.obs;

  RxString isSkinBank = ''.obs;

  var burnsDashBoard = GetBurnsSummary().obs;
  var burnsDataMap = <String, String>{}.obs;


  void changeIndex(int index) {
    currentIndex.value = index;
  }

  Rx<BurnsModel> burnFormData = BurnsModel(
    burns: Burns(),
    burnsOutcome: BurnsOutcome(),
    burnsValues: BurnsValues(),
    burnsTbsa: BurnsTbsa(),
    burnsSurgeryElective: [BurnsSurgeryElective()],
  ).obs;

  Rx<BurnsDetailsModel> burnsDetails = BurnsDetailsModel().obs;

  var lookupList = Rxn<BurnLookupModel>();
  RxBool isLookupLoading = true.obs;

  var isLoading = false.obs;
  var burnCaseList = <BurnsListData>[].obs;
  static final _client = CustomHttpHelper();

  Future<void> downloadBurnsDetailsPdf({required String id}) async {
    try {
      // Step 1: Fetch data
      final success = await getBurnsDetails(id: id);
      if (!success) {
        Fluttertoast.showToast(msg: "Failed to fetch burn details");
        return;
      }

      final data = burnsDetails.value;
      final pdf = pw.Document();

      // Helper widgets for PDF formatting
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
                flex: 4,
                child: pw.Text(
                  "$label:",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.Expanded(
                flex: 6,
                child: pw.Text(displayValue),
              ),
            ],
          ),
        );
      }


      // Step 2: Build the PDF content
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(24),
          build: (context) => [
            pw.Center(
              child: pw.Text(
                "TAEI BURNS CASE SUMMARY REPORT",
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

            // 🔥 BURNS DETAILS
            sectionTitle("Burns Details"),
            infoRow("Admitted", data.burns?.admitted == true ? "Yes" : "No"),
            infoRow("Admission Date", data.burns?.admissionDate),
            infoRow("Type of Burn", data.burns?.typeOfBurn),
            infoRow("Other Type of Burn", data.burns?.othTypeOfBurn),
            infoRow("Inhalation", data.burns?.inhalation == true ? "Yes" : "No"),
            infoRow("Mode of Injury", data.burns?.modeOfInjury),
            infoRow("Place of Incident", data.burns?.placeOfIncident),
            infoRow("Other Place of Incident", data.burns?.othPlaceOfIncident),
            infoRow("TBSA Area", data.burns?.tbsa),
            infoRow("TBSA Total %", data.burns?.tbsaTotalPer),
            infoRow("Degree of Burn", data.burns?.degreeOfBurn),
            infoRow("Associated Injuries", data.burns?.associatedInjuries),
            infoRow("Co-morbidities", data.burns?.coMorbidities),
            infoRow("Pregnant", data.burns?.isPregnant == true ? "Yes" : "No"),
            infoRow("Fluid Resuscitation Given",
                data.burns?.isFluidResuscitationGiven == true ? "Yes" : "No"),
            infoRow("Mechanical Ventilation",
                data.burns?.isMechanicalVentillation == true ? "Yes" : "No"),
            infoRow("Inserted Date", data.burns?.insertedDate),

            pw.Divider(),

            // 📊 TBSA BREAKDOWN (FULL)
            sectionTitle("TBSA Breakdown"),
            infoRow("Head", data.burnsTbsa?.head),
            infoRow("Neck", data.burnsTbsa?.neck),
            infoRow("Anterior Trunk", data.burnsTbsa?.anteriorTrunk),
            infoRow("Posterior Trunk", data.burnsTbsa?.posteriorTrunk),
            infoRow("Right Gluteal", data.burnsTbsa?.rightGluteal),
            infoRow("Left Gluteal", data.burnsTbsa?.leftGluteal),
            infoRow("Genital", data.burnsTbsa?.genital),
            infoRow("Right Arm", data.burnsTbsa?.rightArm),
            infoRow("Left Arm", data.burnsTbsa?.leftArm),
            infoRow("Right Forearm", data.burnsTbsa?.rightForearm),
            infoRow("Left Forearm", data.burnsTbsa?.leftForearm),
            infoRow("Right Hand", data.burnsTbsa?.rightHand),
            infoRow("Left Hand", data.burnsTbsa?.leftHand),
            infoRow("Right Thigh", data.burnsTbsa?.rightThigh),
            infoRow("Left Thigh", data.burnsTbsa?.leftThigh),
            infoRow("Right Leg", data.burnsTbsa?.rightLeg),
            infoRow("Left Leg", data.burnsTbsa?.leftLeg),
            infoRow("Right Foot", data.burnsTbsa?.rightFoot),
            infoRow("Left Foot", data.burnsTbsa?.leftFoot),

            pw.Divider(),

            // 🧴 MANAGEMENT
            sectionTitle("Burns Management & Values"),
            infoRow("Wound Management", data.burnsValues?.woundManagement),
            infoRow("Conservative Method", data.burnsValues?.conservative),
            infoRow("Other Conservative", data.burnsValues?.othConservative),
            infoRow("Hyper Baric",
                data.burnsValues?.hyperBaric == true ? "Yes" : "No"),
            infoRow("Hyper Baric Nos", data.burnsValues?.hyperBaricNos),
            infoRow("Surgery Emergency", data.burnsValues?.surgeryEmergency),
            infoRow("Is Surgery Emergency",
                data.burnsValues?.isSurgeryEmergency == true ? "Yes" : "No"),
            infoRow("Surgery Performed Date",
                data.burnsValues?.surgeryPerformedDate),
            infoRow("Supportive Measures", data.burnsValues?.supportiveMeasures),
            infoRow("Complications During Stay",
                data.burnsValues?.complicationsHospitalStay),
            infoRow("Multidisciplinary Support",
                data.burnsValues?.multidisciplinarySupport),
            infoRow("Other Multidisciplinary Support",
                data.burnsValues?.othMultidisciplinarySupport),
            infoRow("Skin Bank Available",
                data.burnsValues?.skinBankAvailable == true ? "Yes" : "No"),
            infoRow("Skin Bank Details",
                data.burnsValues?.skinBankAvailableValue),

            pw.Divider(),

            // 🏁 OUTCOME
            sectionTitle("Burns Outcome"),
            infoRow("Outcome", data.burnsOutcome?.outcome),
            infoRow("Discharge Date", data.burnsOutcome?.dischargeDate),
            infoRow("Absconded Date", data.burnsOutcome?.abscondedDate),
            infoRow("Death Date", data.burnsOutcome?.deathDate),
            infoRow("Cause of Death", data.burnsOutcome?.causeofdeath),
            infoRow("Transferred To", data.burnsOutcome?.transferredTo),
            infoRow("Ward Name", data.burnsOutcome?.wardName),
            infoRow("Ward Date & Time", data.burnsOutcome?.wardDatetime),
            infoRow("ICU Date & Time", data.burnsOutcome?.icuDatetime),
            infoRow("Hospital Type", data.burnsOutcome?.hospitalType),
            infoRow("Destination Hospital",
                data.burnsOutcome?.destinationHospital),
            infoRow("Reason for Referral",
                data.burnsOutcome?.reasonForReferral),
            infoRow("Condition of Patient",
                data.burnsOutcome?.conditionOfPatient),

            infoRow("Referring Doctor",
                data.burnsOutcome?.referringDoctorName),
            infoRow("TAEI Sheet Documented",
                data.burnsOutcome?.documentedTaeiSheet == true ? "Yes" : "No"),
            infoRow("Patient Exit Date",
                data.burnsOutcome?.patientExitDate),

            pw.SizedBox(height: 20),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                "Generated by TAEI System  ${DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now())}",
                style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
              ),
            ),
          ],
        ),
      );


      // Step 3: Save or download PDF
      final bytes = await pdf.save();

      if (kIsWeb) {
        final blob = html.Blob([bytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download",
              "Burns_Case_${DateTime.now().millisecondsSinceEpoch}.pdf")
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        final dir = await getApplicationDocumentsDirectory();
        final file = File(
            "${dir.path}/Burns_Case_${DateTime.now().millisecondsSinceEpoch}.pdf");
        await file.writeAsBytes(bytes);
        Fluttertoast.showToast(msg: "PDF saved to: ${file.path}");
      }
    } catch (e, st) {
      log("Error generating burns PDF: $e\n$st");
      Fluttertoast.showToast(msg: "Failed to generate PDF");
    }
  }

  /// Pagination
  var burnsStartDate = Rxn<DateTime>();
  var burnsEndDate = Rxn<DateTime>();
  var burnsCurrentPage = 1.obs;
  var burnsTotalPages = 1.obs;
  final int burnsLimit = 20;
  var burnsTotalCount = 0.obs;

  var searchText = "".obs;

// filtered list getter
  List<BurnsListData> get filteredBurnsList {
    if (searchText.value.isEmpty) {
      return burnCaseList;
    }

    return burnCaseList.where((e) {
      final name = (e.nameOfPatient ?? "").toLowerCase();
      return name.contains(searchText.value.toLowerCase());
    }).toList();
  }

  Future<bool> getBurnList({
    required String startDate,
    required String endDate,
    String patientName = "",
    String dischargeStatus = "",
    int pageNumber = 1, // offset in your API
  }) async {
    try {
      //list?limit=10&offset=1&start_date=2025-10-13 00:00:00&end_date=2025-10-26 23:59:59
      var url = Uri.parse(Urls.getBurnList +
          "list?limit=$burnsLimit&offset=$pageNumber&start_date=$startDate&end_date=$endDate&patient_name=$patientName&discharge_status=$dischargeStatus");
      var response = await _client.get(url);
      log('New getListEmo response: ${response.body}');

      if (response.body.isNotEmpty) {
        var data = burnsListModelFromJson(response.body);
        burnCaseList.assignAll(data.rows ?? []);
        log('HHHHHHHHHHHH ${burnCaseList.length} items loaded');
        burnsTotalCount.value = data.totalCount ?? 0;
        burnsTotalPages.value = (burnsTotalCount.value / burnsLimit)
            .ceil()
            .clamp(1, double.infinity)
            .toInt();
        burnsStartDate.value = DateTime.parse(startDate);
        burnsEndDate.value = DateTime.parse(endDate);
        burnsCurrentPage.value = pageNumber;
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

  Future<bool> getLookup() async {
    try {
      lookupList.value = null;
      var data = await BurnService.getLookup();
      log(data.toString());
      if (data != null) {
        lookupList.value = data;
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> createBurns({required BurnsModel data}) async {
    try {
      isLoading.value = true;
      log(data.toString());
      var url = Uri.parse(Urls.createBurnRecord);
      var response = await _client.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(data.toCleanJson()));
      log(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var d = jsonDecode(response.body);
        Fluttertoast.showToast(msg: d["message"]);
        isLoading.value = false;
        Get.back();
        getBurnList(
          startDate: DateFormat('yyyy-MM-dd 00:00:00')
              .format(DateTime.now().subtract(Duration(days: 7))),
          endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
          dischargeStatus: dischargeStatus.value,
        );
        getBurnsDashboard(
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

  Future<bool> getBurnById({required String id}) async {
    try {
      log(id.toString());
      var url = Uri.parse(Urls.getBurnById + id);
      var response = await _client.get(
        url,
        headers: {
          "Content-Type": "application/json",
        },
      );
      print(url);
      log('getBurnById response: ${response.body}');
      print('Status code: ${response.statusCode}');
      log('Response body: ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        var d = jsonDecode(response.body);
        log('getBurnById response Value Test: ${d.toString()}');
        burnFormData.value = BurnsModel(
          burns: Burns.fromJson(d["burns"]),
          burnsValues: BurnsValues.fromJson(d["burns_values"]),
          burnsTbsa: BurnsTbsa.fromJson(d["burns_tbsa"]),
          burnsOutcome: BurnsOutcome.fromJson(d["burns_outcome"]),
          burnsSurgeryElective: List<BurnsSurgeryElective>.from(
            (d["burns_surgery_elective"] ?? [])
                .map((x) => BurnsSurgeryElective.fromJson(x)),
          ),
        );
        log('getBurnById response Value Final: ${burnFormData.value.toString()}');
        return true;
      } else {
        print('FAILED LLK');
        Fluttertoast.showToast(msg: "Failed to get burn record");
        return false;
      }
    } catch (ex) {
      print('FAILED');
      return false;
    }
  }

  /// Get Burns Details
  Future<bool> getBurnsDetails({required String id}) async {
    try {
      log(id.toString());
      var url = Uri.parse(Urls.getBurnDetails + id);
      var response = await _client.get(
        url,
      );
      log(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var d = jsonDecode(response.body);
        burnsDetails.value = BurnsDetailsModel.fromJson(d);
        Fluttertoast.showToast(msg: "Burns details fetched successfully");
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      return false;
    }
  }

  Future<bool> updateBurns(
      {required BurnsModel data, required String id}) async {
    try {
      isLoading.value = true;
      // log(data.toString());
      var url = Uri.parse(Urls.updateBurnRecord + id);
      var response = await _client.put(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(data.toJson()));
      if (response.statusCode == 200 || response.statusCode == 201) {
        log('updateEmo response: ${response.body}');
        // var d = jsonDecode(response.body);
        Fluttertoast.showToast(msg: "Data updated successfully");
        log("Test Discharge ${dischargeStatus.value}");
        isLoading.value = false;
        getBurnList(
          startDate: DateFormat('yyyy-MM-dd 00:00:00')
              .format(DateTime.now().subtract(Duration(days: 7))),
          endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
          dischargeStatus: dischargeStatus.value,
        );
        log("Test Discharge 2${dischargeStatus.value}");
        getBurnsDashboard(
          startDate: DateFormat('yyyy-MM-dd 00:00:00')
              .format(DateTime.now().subtract(Duration(days: 7))),
          endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
        );
        Get.back();

        return true;
      } else if (response.statusCode == 500) {
        Fluttertoast.showToast(
          msg: response.body.toString(),
          timeInSecForIosWeb: 3,
        );

        isLoading.value = false;
        return false;
      } else {
        Fluttertoast.showToast(msg: "Failed to update burn record");
        isLoading.value = false;
        return false;
      }
    } catch (ex) {
      Fluttertoast.showToast(msg: "Failed to update burn record");
      isLoading.value = false;
      return false;
    }
  }

  // get burns dashboard
  Future<bool> getBurnsDashboard(
      {required String startDate, required String endDate}) async {
    try {
      var url = Uri.parse(
          Urls.getBurnsDashboard + "?start_date=$startDate&end_date=$endDate");
      var response = await _client.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      });
      log('getEmoLookup response: ${response.body}');
      if (response.body.isNotEmpty) {
        var list = burnsDashBoardFromJson(response.body);
        burnsDashBoard.value = list.first.getBurnsSummary ?? GetBurnsSummary();

        burnsDataMap.value = {
          "Total": burnsDashBoard.value.total.toString(),
          "TBSA > 40 %": burnsDashBoard.value.tabaGt40.toString(),
          "TBSA < 40 %": burnsDashBoard.value.tabaLt40.toString(),
          "Pediatrics": burnsDashBoard.value.pediatrics.toString(),
          "Admitted": burnsDashBoard.value.admitted.toString(),
          "Pending": burnsDashBoard.value.pending.toString(),
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

  void calculateTbsaTotal() {
    final tbsa = burnFormData.value.burnsTbsa;
    if (tbsa == null) return;
    double total = 0;
    total += tbsa.head ?? 0;
    total += tbsa.neck ?? 0;
    total += tbsa.anteriorTrunk ?? 0;
    total += tbsa.posteriorTrunk ?? 0;
    total += tbsa.rightGluteal ?? 0;
    total += tbsa.leftGluteal ?? 0;
    total += tbsa.genital ?? 0;
    total += tbsa.rightArm ?? 0;
    total += tbsa.leftArm ?? 0;
    total += tbsa.rightForearm ?? 0;
    total += tbsa.leftForearm ?? 0;
    total += tbsa.rightHand ?? 0;
    total += tbsa.leftHand ?? 0;
    total += tbsa.rightThigh ?? 0;
    total += tbsa.leftThigh ?? 0;
    total += tbsa.rightLeg ?? 0;
    total += tbsa.leftLeg ?? 0;
    total += tbsa.rightFoot ?? 0;
    total += tbsa.leftFoot ?? 0;

    burnFormData.value.burns?.tbsaTotalPer = total.toString();
    burnFormData.refresh();
  }
}
