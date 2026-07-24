import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;
import '../../../constants/urls.dart';
import '../../../utils/helpers/http_helper.dart';
import '../model/getOpList.dart';
import '../model/get_model.dart';
import '../model/lookupmodel.dart';
import '../model/non_index_model.dart';
import '../model/request_model.dart';
import 'package:taei_gov/src/stemi/model/request_model.dart' as stemi;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
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
import '../model/stemi_dashboard.dart';
import '../model/stemi_op_details_page.dart';
import 'package:taei_gov/src/stemi/model/request_model.dart' as p;

class StemiController extends GetxController {
  RxInt currentIndex = 0.obs;

  var stemiStartDate = Rxn<DateTime>();
  var stemiEndDate = Rxn<DateTime>();
  var ListData1 = <NonIndexStemi>[].obs;
  var ListDataOp1 = <AcsCaseDataModel>[].obs;



  void changeIndex(int index) {
    currentIndex.value = index;
  }

  Rx<RequestModel> stemiModel = RequestModel(
    opPatient: p.OpPatient(),
    stemiAdmission: StemiAdmission(),
    stemiClinicalAssessment: StemiClinicalAssessment(),
    stemiTreatment: stemi.StemiTreatment(),
    stemiOutcome: StemiOutcome(),
    nstemiTreatment: stemi.NstemiTreatment(),
    nstemiOutcome: NstemiOutcome(),
    unstableanginaTreatment:stemi.UnstableAnginaTreatment(),
    unstableanginaOutcome: UnstableAnginaOutcome(),
    othersTreatment: OthersTreatment(),
  ).obs;

  // Rx<RequestModel1> stemiModel1 = RequestModel1().obs;

  RequestModel? datamodel;
  RequestModel? getdatamodel;

  RxList<StemiListData> stemiListData = <StemiListData>[].obs;
  RxList<PatientResponseModel> stemiListDataOp = <PatientResponseModel>[].obs;

  Rx<lookUpModelnew> stemiLookup = lookUpModelnew().obs;

  RxBool isLoading = false.obs;
  RxInt pastHistory = 0.obs;
  RxString emergencyCategory = ''.obs;
  var stemiDashboard = StemiSummary().obs;
  var stemiDataMap = <String, String>{}.obs;


  static final _client = CustomHttpHelper();

  Future<bool> createSteam({required RequestModel data}) async {
    isLoading.value = true;
    try {
      final jsonBody = jsonEncode(data.toJson());
      final prettyJson =
          const JsonEncoder.withIndent('  ').convert(data.toJson());
      log("🔍 createSteam Request Body:\n$prettyJson");
      var url = Uri.parse(Urls.createStemi);
      var response = await _client.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonBody,
      );
      log("Response: ${response.statusCode} | ${response.body}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        var d = jsonDecode(response.body);
        getListStemi(
          startDate: DateFormat('yyyy-MM-dd HH:mm:ss')
              .format(DateTime.now().subtract(const Duration(days: 7))),
          endDate: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        );
        // if (d["message"] != null) Fluttertoast.showToast(msg: d["message"]);
        return true;
      } else {
        // Fluttertoast.showToast(msg: "Failed to create record: ${response.statusCode}");
        return false;
      }
    } catch (ex, stackTrace) {
      log("createSteam exception: $ex\n$stackTrace");
      // Fluttertoast.showToast(msg: "Error: $ex");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Get STEMI by ID
  Future<bool> getStemiById({required String id}) async {
    isLoading.value = true;
    try {
      var url = Uri.parse("${Urls.getStemiById}$id" + "/" + "0");
      var response = await _client.get(url);
      log('getStemiById response: ${response.statusCode} | ${response.body}');
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        var d = jsonDecode(response.body);
        stemiModel.value = RequestModel.fromJson(d);
        print("${stemiModel.value.opPatient?.nameOfPatient} jksj");
        return true;
      } else {
        return false;
      }
    } catch (ex, stackTrace) {
      log("getStemiById exception: $ex\n$stackTrace");
      // Fluttertoast.showToast(msg: "Error: $ex");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> getStemiLookup() async {
    isLoading.value = true;
    try {
      var url = Uri.parse(Urls.getStemiLookup);
      var response = await _client.get(url);
      log('getStemiLookup response: ${response.body}');
      if (response.body.isNotEmpty) {
        var list = lookUpModelnewFromJson(response.body);
        stemiLookup.value = list;
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      log("getStemiLookup error: $ex");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Pagination
  var stemiCurrentPage = 1.obs;
  var stemiTotalPages = 1.obs;
  final int stemiLimit = 20;
  var stemiTotalCount = 0.obs;

  var searchText = "".obs;

// filtered list getter
  List<StemiListData> get filteredTraumaList {
    if (searchText.value.isEmpty) {
      return stemiListData;
    }
    return stemiListData.where((e) {
      final name = (e.nameOfPatient ?? "").toLowerCase();
      return name.contains(searchText.value.toLowerCase());
    }).toList();
  }

  Future<bool> getListStemi({
    required String startDate,
    required String endDate,
    String patientName = "",
    int dischargeStatus = 0,
    int pageNumber = 1,
  }) async {
    isLoading.value = true;

    try {
      final url = Uri.parse(
        '${Urls.getStemiList}?'
            'limit=$stemiLimit'
            '&offset=$pageNumber'
            '&start_date=$startDate'
            '&end_date=$endDate'
            '&patient_name=$patientName'
            '&discharge_status=$dischargeStatus',
      );

      log('Request URL: $url');

      final response = await _client.get(url);

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final model = stemiListModelFromJson(response.body);

        stemiListData.assignAll(model.rows ?? []);
        stemiTotalCount.value = model.totalCount ?? 0;

        stemiTotalPages.value =
            (stemiTotalCount.value / stemiLimit)
                .ceil()
                .clamp(1, double.infinity)
                .toInt();

        stemiStartDate.value = DateTime.parse(startDate);
        stemiEndDate.value = DateTime.parse(endDate);
        stemiCurrentPage.value = pageNumber;

        return true;
      }

      return false;
    } catch (ex, stackTrace) {
      log("getListStemi error: $ex\n$stackTrace");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> getListStemiOp({
    required String startDate,
    required String endDate,
  }) async {
    isLoading.value = true;
    try {
      final url = Uri.parse(
        '${Urls.getOp}?start_date=$startDate&end_date=$endDate',
      );

      final response = await _client.get(url);

      log('getListStemi response: ${response.statusCode} | ${response.body}');
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final model = patientResponseModelFromJson(response.body);
        stemiListDataOp.assignAll([model]);
        return true;
      } else {
        return false;
      }
    } catch (ex, stackTrace) {
      log("getListStemi exception: $ex\n$stackTrace");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> getStemiOpById({required String id}) async {
    isLoading.value = true;
    try {
      var url = Uri.parse("${Urls.getStemiOpList}$id");
      var response = await _client.get(url);
      log('getStemiByIdOP response: ${response.statusCode} | ${response.body}');
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        var d = jsonDecode(response.body);
        stemiModel.value = RequestModel.fromJson(d);
        print("${stemiModel.value.opPatient?.nameOfPatient} jksj");
        return true;
      } else {
        return false;
      }
    } catch (ex, stackTrace) {
      log("getStemiById exception: $ex\n$stackTrace");
      // Fluttertoast.showToast(msg: "Error: $ex");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> getStemiDetails({required String id}) async {
    try {
      log("Fetching PREM Details for ID: $id");

      var response = await _client.get(Uri.parse("${Urls.getStemiDetails}$id"));
      log("Response (${response.statusCode}): ${response.body}");

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final data = stemiNonIndex(response.body);
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


  Future<bool> getStemiDetailsOp({required String id}) async {
    try {
      log("Fetching PREM Details for ID: $id");

      var response = await _client.get(Uri.parse("${Urls.getStemiDetailsOp}$id"));
      log("Response (${response.statusCode}): ${response.body}");

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final data = stemiNonIndexOp(response.body);
        ListDataOp1.assignAll([data]);
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


  Future<void> exportStemiFullPdf(NonIndexStemi data) async {
    try {
      final pdf = pw.Document();

      final s = data.stemi;
      final n = data.nstemi;
      final ua = data.unstableAngina;

      final Map<String, dynamic> map = {
        // ===== STEMI Admission =====
        "STEMI - Is Admitted": s?.admission?.isAdmitted,
        "STEMI - Date Entry": s?.admission?.dateTimeEntry,
        "STEMI - Department": s?.admission?.departmentName,
        "STEMI - Date Admission": s?.admission?.dateTimeAdmission,

        // ===== Clinical Assessment =====
        "Symptom Onset": s?.clinicalAssessment?.symptomOnsetDatetime,
        "Risk Factors": s?.clinicalAssessment?.riskFactors,
        "Other Risk Factor": s?.clinicalAssessment?.otherRiskFactor,
        "Signs and Symptoms": s?.clinicalAssessment?.signsSymptoms,
        "FMC Type": s?.clinicalAssessment?.fmcType,
        "FMC Datetime": s?.clinicalAssessment?.fmcDatetime,
        "ECG Datetime": s?.clinicalAssessment?.ecgDatetime,
        "ECG Location": s?.clinicalAssessment?.ecgLocation,
        "Diagnosis": s?.clinicalAssessment?.diagnosis,
        "Other Diagnosis": s?.clinicalAssessment?.otherDiagnosis,

        // ===== STEMI Treatment =====
        "STEMI Confirmed At": s?.treatment?.stemiConfirmedAt,
        "Infarction Location": s?.treatment?.infarctionLocation,
        "Loading Dose Location": s?.treatment?.loadingDoseLocation,
        "Loading Dose Drug": s?.treatment?.loadingDoseDrug,
        "Loading Dose Time": s?.treatment?.loadingDoseTime,
        "Loading Dose Admin Date": s?.treatment?.loadingDoseAdministrationDate,
        "Thrombolysis Location": s?.treatment?.thrombolysisLocation,
        "Thrombolytic Agent": s?.treatment?.thrombolyticAgent,
        "Thrombolysis Start": s?.treatment?.thrombolysisStart,
        "Thrombolysis End": s?.treatment?.thrombolysisEnd,
        "Thrombolysis Outcome": s?.treatment?.thrombolysisOutcome,
        "Not Done Reason": s?.treatment?.thrombolysisNotDoneReason,
        "Thrombolysis Date": s?.treatment?.thrombolysisDate,
        "Treatment Strategy": s?.treatment?.treatmentStrategy,
        "Conservative Management": s?.treatment?.conservativeManagement,
        "Killip Score": s?.treatment?.killipRiskScore,
        "Planned CAG": s?.treatment?.plannedCag,
        "Cath Lab Arrival": s?.treatment?.cathLabArrival,
        "Balloon Inflation": s?.treatment?.balloonInflation,
        "Stent Type": s?.treatment?.stentType,
        "Complications": s?.treatment?.complications,
        "Other Complications": s?.treatment?.otherComplications,
        "Transfer Location": s?.treatment?.transferLocation,
        "Counselling ID": s?.treatment?.counsellingId,
        "Symptom to FMC": s?.treatment?.symptomToFmc,
        "FMC to ECG": s?.treatment?.fmcToEcg,
        "Door To Needle": s?.treatment?.doorToNeedle,
        "Door To Balloon": s?.treatment?.doorToBalloon,
        "Total Ischemic Time": s?.treatment?.totalIschemicTime,
        "ICU Admission": s?.treatment?.icuAdmission,
        "Hospital Stay Days": s?.treatment?.hospitalStayDays,
        "In Hospital Complication": s?.treatment?.inHospitalComplication,
        "Coronary Angiography": s?.treatment?.coronoryAngiography,

        // ===== STEMI Outcome =====
        "Outcome Type": s?.outcome?.outcomeType,
        "Discharge Datetime": s?.outcome?.dischargeDatetime,
        "Absconded Datetime": s?.outcome?.abscondedDatetime,
        "Death Datetime": s?.outcome?.deathDatetime,
        "Death Timing": s?.outcome?.deathTiming,
        "Other Death Timing": s?.outcome?.otherDeathTiming,
        "Cause Of Death": s?.outcome?.causeOfDeath,
        "Hospital Type": s?.outcome?.hospitalType,
        "Destination Hospital": s?.outcome?.destinationHospital,
        "Referral Reason": s?.outcome?.referralReason,
        "Other Referral Reason": s?.outcome?.otherReferralReason,
        "Patient Condition": s?.outcome?.patientCondition,
        "Referring Doctor": s?.outcome?.referringDoctor,
        "Case Sheet Documented": s?.outcome?.documentedInTaeiCaseSheet,

        // ===== NSTEMI =====
        "NSTEMI Confirmed": n?.treatment?.nstemiConfirmedAt,
        "NSTEMI TIMI Score": n?.treatment?.timiRiskScore,
        "NSTEMI Strategy": n?.treatment?.treatmentStrategy,
        "NSTEMI Planned CAG": n?.treatment?.plannedCag,
        "NSTEMI Complications": n?.treatment?.complications,
        "NSTEMI ICU": n?.treatment?.icuAdmission,
        "NSTEMI Hospital Days": n?.treatment?.hospitalStayDays,
        "NSTEMI Outcome": n?.outcome?.outcomeType,

        // ===== Unstable Angina =====
        "UA Confirmed": ua?.treatment?.uaConfirmedAt,
        "UA TIMI": ua?.treatment?.timiRiskScore,
        "UA Complications": ua?.treatment?.complications,
        "UA ICU": ua?.treatment?.icuAdmission,
        "UA Outcome": ua?.outcome?.outcomeType,
      };

      pdf.addPage(
        pw.MultiPage(
          build: (_) => [
            pw.Center(child: pw.Text("STEMI CASE DETAILS")),
            pw.SizedBox(height: 12),

            ...map.entries.map((e) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 6),
              child: pw.Row(children: [
                pw.Expanded(flex: 4, child: pw.Text("${e.key}:")),
                pw.Expanded(flex: 6, child: pw.Text("${e.value ?? '-'}")),
              ]),
            )),

            pw.Divider(),

            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                "Generated: ${DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now())}",
              ),
            )
          ],
        ),
      );

      final bytes = await pdf.save();

      if (kIsWeb) {
        final blob = html.Blob([bytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final a = html.AnchorElement(href: url)
          ..setAttribute("download", "STEMI_${DateTime.now().millisecondsSinceEpoch}.pdf")
          ..click();
        html.Url.revokeObjectUrl(url);
        return;
      }

      final downloads = await getDownloadsDirectory();
      final file = File("${downloads!.path}/STEMI_${DateTime.now().millisecondsSinceEpoch}.pdf");
      await file.writeAsBytes(bytes);

      Fluttertoast.showToast(msg: "Saved in Downloads: ${file.path}");

    } catch (e) {
      print("PDF Error: $e");
    }
  }


  // import 'dart:io';
  // import 'package:intl/intl.dart';
  // import 'package:pdf/widgets.dart' as pw;
  // import 'package:pdf/pdf.dart';
  // import 'package:flutter/foundation.dart' show kIsWeb;
  // import 'package:universal_html/html.dart' as html; // only for web build
  // import 'package:path_provider/path_provider.dart';
  //
  // import '../model/acs_case_data_model.dart';

  Future<void> exportStemiOpPdf(AcsCaseDataModel data) async {
    try {
      final pdf = pw.Document();

      final op = data.opPatient;
      final stemi = data.stemi;
      final nstemi = data.nstemi;
      final ua = data.unstableAngina;

      // ====== FLAT MAP OF ALL FIELDS ======
      final Map<String, dynamic> map = {
        // ---------- OP PATIENT ----------
        "Patient ID": op?.patientId,
        "OP Number": op?.patientOpNumber,
        "Patient Admitted": op?.patientAdmitted,
        "Name of Patient": op?.nameOfPatient,
        "Gender": op?.gender,
        "Mobile": op?.mobile,
        "Father Name": op?.fathername,
        "Mother Name": op?.mothername,
        "Address": op?.address,
        "Pincode": op?.pincode,
        "Marital Status": op?.maritalStatus,
        "Education": op?.education,
        "Employment Status": op?.employmentStatus,
        "Occupation": op?.occupation,
        "State": op?.state,
        "District": op?.district,
        "Triage Datetime": op?.dateTimeOfTriage,
        "Risk Factors": op?.riskFactors,
        "Other Risk Factor": op?.otherRiskFactor,
        "Signs / Symptoms": op?.signsSymptoms,
        "ECG Datetime": op?.ecgDatetime,
        "ECG Location": op?.ecgLocation,
        "Diagnosis": op?.diagnosis,
        "Other Diagnosis": op?.otherDiagnosis,

        // ---------- STEMI TREATMENT ----------
        "STEMI Confirmed At": stemi?.treatment?.stemiConfirmedAt,
        "STEMI Infarction Location": stemi?.treatment?.infarctionLocation,
        "STEMI Loading Dose Location": stemi?.treatment?.loadingDoseLocation,
        "STEMI Loading Dose Drug": stemi?.treatment?.loadingDoseDrug,
        "STEMI Loading Dose Time": stemi?.treatment?.loadingDoseTime,
        "STEMI Loading Dose Admin Date":
        stemi?.treatment?.loadingDoseAdministrationDate,
        "STEMI Thrombolysis Location": stemi?.treatment?.thrombolysisLocation,
        "STEMI Thrombolytic Agent": stemi?.treatment?.thrombolyticAgent,
        "STEMI Thrombolysis Start": stemi?.treatment?.thrombolysisStart,
        "STEMI Thrombolysis End": stemi?.treatment?.thrombolysisEnd,
        "STEMI Thrombolysis Outcome": stemi?.treatment?.thrombolysisOutcome,
        "STEMI Thrombolysis Not Done Reason":
        stemi?.treatment?.thrombolysisNotDoneReason,
        "STEMI Thrombolysis Date": stemi?.treatment?.thrombolysisDate,
        "STEMI Treatment Strategy": stemi?.treatment?.treatmentStrategy,
        "STEMI Conservative Management":
        stemi?.treatment?.conservativeManagement,
        "STEMI Killip Risk Score": stemi?.treatment?.killipRiskScore,
        "STEMI Planned CAG": stemi?.treatment?.plannedCag,
        "STEMI Cath Lab Arrival": stemi?.treatment?.cathLabArrival,
        "STEMI Balloon Inflation": stemi?.treatment?.balloonInflation,
        "STEMI Stent Type": stemi?.treatment?.stentType,
        "STEMI Complications": stemi?.treatment?.complications,
        "STEMI Other Complications": stemi?.treatment?.otherComplications,
        "STEMI Transfer Location": stemi?.treatment?.transferLocation,
        "STEMI Counselling ID": stemi?.treatment?.counsellingId,
        "STEMI Symptom to FMC": stemi?.treatment?.symptomToFmc,
        "STEMI FMC to ECG": stemi?.treatment?.fmcToEcg,
        "STEMI Door to Needle": stemi?.treatment?.doorToNeedle,
        "STEMI Door to Balloon": stemi?.treatment?.doorToBalloon,
        "STEMI Total Ischemic Time": stemi?.treatment?.totalIschemicTime,
        "STEMI ICU Admission": stemi?.treatment?.icuAdmission,
        "STEMI Hospital Stay Days": stemi?.treatment?.hospitalStayDays,
        "STEMI In-Hospital Complication":
        stemi?.treatment?.inHospitalComplication,
        "STEMI Coronary Angiography": stemi?.treatment?.coronoryAngiography,

        // ---------- STEMI OUTCOME ----------
        "STEMI Outcome Type": stemi?.outcome?.outcomeType,
        "STEMI Discharge Datetime": stemi?.outcome?.dischargeDatetime,
        "STEMI Absconded Datetime": stemi?.outcome?.abscondedDatetime,
        "STEMI Death Datetime": stemi?.outcome?.deathDatetime,
        "STEMI Death Timing": stemi?.outcome?.deathTiming,
        "STEMI Other Death Timing": stemi?.outcome?.otherDeathTiming,
        "STEMI Cause of Death": stemi?.outcome?.causeOfDeath,
        "STEMI Hospital Type": stemi?.outcome?.hospitalType,
        "STEMI Destination Hospital": stemi?.outcome?.destinationHospital,
        "STEMI Referral Reason": stemi?.outcome?.referralReason,
        "STEMI Other Referral Reason": stemi?.outcome?.otherReferralReason,
        "STEMI Patient Condition": stemi?.outcome?.patientCondition,
        "STEMI Referring Doctor": stemi?.outcome?.referringDoctor,
        "STEMI Documented in TAEI Case Sheet":
        stemi?.outcome?.documentedInTaeiCaseSheet,

        // ---------- NSTEMI TREATMENT ----------
        "NSTEMI Confirmed At": nstemi?.treatment?.nstemiConfirmedAt,
        "NSTEMI Loading Dose Location": nstemi?.treatment?.loadingDoseLocation,
        "NSTEMI Loading Dose Drug": nstemi?.treatment?.loadingDoseDrug,
        "NSTEMI Loading Dose Time": nstemi?.treatment?.loadingDoseTime,
        "NSTEMI Loading Dose Admin Date":
        nstemi?.treatment?.loadingDoseAdministrationDate,
        "NSTEMI TIMI Risk Score": nstemi?.treatment?.timiRiskScore,
        "NSTEMI Treatment Strategy": nstemi?.treatment?.treatmentStrategy,
        "NSTEMI Conservative Management":
        nstemi?.treatment?.conservativeManagement,
        "NSTEMI Planned CAG": nstemi?.treatment?.plannedCag,
        "NSTEMI Cath Lab Arrival": nstemi?.treatment?.cathLabArrival,
        "NSTEMI Balloon Inflation": nstemi?.treatment?.balloonInflation,
        "NSTEMI Stent Type": nstemi?.treatment?.stentType,
        "NSTEMI Complications": nstemi?.treatment?.complications,
        "NSTEMI Other Complications": nstemi?.treatment?.otherComplications,
        "NSTEMI Transfer Location": nstemi?.treatment?.transferLocation,
        "NSTEMI Symptom to FMC": nstemi?.treatment?.symptomToFmc,
        "NSTEMI FMC to ECG": nstemi?.treatment?.fmcToEcg,
        "NSTEMI Door To Balloon": nstemi?.treatment?.doorToBalloon,
        "NSTEMI ICU Admission": nstemi?.treatment?.icuAdmission,
        "NSTEMI Hospital Stay Days": nstemi?.treatment?.hospitalStayDays,
        "NSTEMI In-Hospital Complications":
        nstemi?.treatment?.inHospitalComplications,
        "NSTEMI Coronary Angiography": nstemi?.treatment?.coronoryAngiography,

        // ---------- NSTEMI OUTCOME ----------
        "NSTEMI Outcome Type": nstemi?.outcome?.outcomeType,
        "NSTEMI Discharge Datetime": nstemi?.outcome?.dischargeDatetime,
        "NSTEMI Absconded Datetime": nstemi?.outcome?.abscondedDatetime,
        "NSTEMI Death Datetime": nstemi?.outcome?.deathDatetime,
        "NSTEMI Death Timing": nstemi?.outcome?.deathTiming,
        "NSTEMI Other Death Timing": nstemi?.outcome?.otherDeathTiming,
        "NSTEMI Hospital Type": nstemi?.outcome?.hospitalType,
        "NSTEMI Destination Hospital": nstemi?.outcome?.destinationHospital,
        "NSTEMI Referral Reason": nstemi?.outcome?.referralReason,
        "NSTEMI Other Referral Reason": nstemi?.outcome?.otherReferralReason,
        "NSTEMI Patient Condition": nstemi?.outcome?.patientCondition,
        "NSTEMI Referring Doctor": nstemi?.outcome?.referringDoctor,
        "NSTEMI Documented in TAEI Case Sheet":
        nstemi?.outcome?.documentedInTaeiCaseSheet,

        // ---------- UA TREATMENT ----------
        "UA Confirmed At": ua?.treatment?.uaConfirmedAt,
        "UA Loading Dose Location": ua?.treatment?.loadingDoseLocation,
        "UA Loading Dose Drug": ua?.treatment?.loadingDoseDrug,
        "UA Loading Dose Time": ua?.treatment?.loadingDoseTime,
        "UA Loading Dose Admin Date":
        ua?.treatment?.loadingDoseAdministrationDate,
        "UA TIMI Risk Score": ua?.treatment?.timiRiskScore,
        "UA Management ID": ua?.treatment?.managementId,
        "UA Complications": ua?.treatment?.complications,
        "UA Other Complications": ua?.treatment?.otherComplications,
        "UA Counselling ID": ua?.treatment?.counsellingId,
        "UA ICU Admission": ua?.treatment?.icuAdmission,
        "UA Hospital Stay Days": ua?.treatment?.hospitalStayDays,
        "UA In-Hospital Complications":
        ua?.treatment?.inHospitalComplications,
        "UA Symptom to FMC": ua?.treatment?.symptomToFmc,
        "UA FMC to ECG": ua?.treatment?.fmcToEcg,
        "UA Door To Balloon": ua?.treatment?.doorToBalloon,
        "UA Coronary Angiography": ua?.treatment?.coronoryAngiography,

        // ---------- UA OUTCOME ----------
        "UA Outcome Type": ua?.outcome?.outcomeType,
        "UA Discharge Datetime": ua?.outcome?.dischargeDatetime,
        "UA Absconded Datetime": ua?.outcome?.abscondedDatetime,
        "UA Death Datetime": ua?.outcome?.deathDatetime,
        "UA Death Timing": ua?.outcome?.deathTiming,
        "UA Other Death Timing": ua?.outcome?.otherDeathTiming,
        "UA Hospital Type": ua?.outcome?.hospitalType,
        "UA Destination Hospital": ua?.outcome?.destinationHospital,
        "UA Referral Reason": ua?.outcome?.referralReason,
        "UA Other Referral Reason": ua?.outcome?.otherReferralReason,
        "UA Patient Condition": ua?.outcome?.patientCondition,
        "UA Referring Doctor": ua?.outcome?.referringDoctor,
        "UA Documented in TAEI Case Sheet":
        ua?.outcome?.documentedInTaeiCaseSheet,
      };

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (_) => [
            pw.Center(
              child: pw.Text("CARDIOLOGY OP CASE DETAILS"),
            ),
            pw.SizedBox(height: 12),
            ...map.entries.map(
                  (e) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 6),
                child: pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 4,
                      child: pw.Text("${e.key}:"),
                    ),
                    pw.Expanded(
                      flex: 6,
                      child: pw.Text("${e.value ?? '-'}"),
                    ),
                  ],
                ),
              ),
            ),
            pw.Divider(),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                "Generated: ${DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now())}",
              ),
            ),
          ],
        ),
      );

      final bytes = await pdf.save();

      if (kIsWeb) {
        final blob = html.Blob([bytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        html.AnchorElement(href: url)
          ..setAttribute(
            "download",
            "CARDIOLOGY_OP_${DateTime.now().millisecondsSinceEpoch}.pdf",
          )
          ..click();
        html.Url.revokeObjectUrl(url);
        return;
      }

      final downloadsDir = await getDownloadsDirectory();
      final file = File(
        "${downloadsDir!.path}/ACS_OP_${DateTime.now().millisecondsSinceEpoch}.pdf",
      );
      await file.writeAsBytes(bytes);
      // Optional: show toast / snackbar
    } catch (e) {
      debugPrint("PDF Error: $e");
    }
  }



  Future<bool> getStemiDashboard({
    required String startDate,
    required String endDate,
  }) async {
    try {
      var url = Uri.parse(
        Urls.getStemiDashboard + "?start_date=$startDate&end_date=$endDate",
      );

      var response = await _client.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      });


      log('getStemiDashboard response: ${response.body}');


      if (response.body.isNotEmpty) {
        /// Parse list
        var list = getStemiSummaryListFromJson(response.body);

        /// Assign to observable
        stemiDashboard.value = list.first.stemiSummary ?? StemiSummary();

        /// UI Map
        stemiDataMap.value = {
          "Total": stemiDashboard.value.total.toString(),
          "STEMI": stemiDashboard.value.stemi.toString(),
          "NSTEMI": stemiDashboard.value.nstemi.toString(),
          "USA": stemiDashboard.value.usa.toString(),
          "Admitted": stemiDashboard.value.admitted.toString(),
          "Pending": stemiDashboard.value.pending.toString(),
        };

        return true;
      } else {
        return false;
      }
    } catch (ex) {
      log("getStemiDashboard error: $ex");
      return false;
    }
  }





}
