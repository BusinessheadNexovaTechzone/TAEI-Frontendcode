import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as _client;
import 'package:intl/intl.dart';
import 'package:taei_gov/src/drowning/models/drowning_list_model.dart';
import 'package:taei_gov/src/drowning/models/drowning_lookup_model.dart';
import 'package:taei_gov/src/drowning/models/drowning_model.dart';
import 'package:taei_gov/src/drowning/service/drowning_service.dart';

import '../../../constants/urls.dart';
import '../../../utils/helpers/http_helper.dart';
import '../../../utils/helpers/loading_helper.dart';
import '../../stemi/model/stemi_dashboard.dart';
import '../models/Dashboard.dart';
import '../models/non_index.dart';
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

class DrowningController extends GetxController {
  var drowningModel = Rxn<DrowningModel>();
  var lookupList = Rxn<DrowninglookupModel>();
  RxInt currentIndex = 0.obs;
  RxBool notFound = false.obs;
  static final _client = CustomHttpHelper();

  var drowningStartDate = Rxn<DateTime>();
  var drowningEndDate = Rxn<DateTime>();

  RxBool isLookupLoading = true.obs;
  var ListData1 = <NonIndexDrowningDataModel>[].obs;
  RxBool isLoading = false.obs;
  var drowningDashboard = DrowningSummary().obs;
  var drowningDataMap = <String, String>{}.obs;



  Future<T> _withLoader<T>(Future<T> Function() task) async {
    try {
      isLookupLoading.value = true;
      return await task();
    } finally {
      isLookupLoading.value = false;
    }
  }

  Future<bool> getLookup() async {
    isLookupLoading(true);
    try {
      lookupList.value = null;
      var data = await DrowningService.getLookup();
      if (data != null) {
        lookupList.value = data;
        isLookupLoading(false);
        return true;
      } else {
        isLookupLoading(false);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> createDrowning() async {
    loadingIndicator(Get.context!);
    try {
      log(drowningModel.toJson().toString());
      var data =
          await DrowningService.CreateDrowning(data: drowningModel.value!);
      if (data) {
        Get.back();
        getDrowningList(
          startDate: DateFormat('yyyy-MM-dd 00:00:00')
              .format(DateTime.now().subtract(Duration(days: 7))),
          endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
        );
        return true;
      } else {
        Get.back();
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  // var drowningList = Rxn<DrowningListModel>();
  // RxBool isDrowningLoading = true.obs;
  //
  // Future<bool> getDrowingList({
  //   required String startDate,
  //   required String endDate,
  // }) async {
  //   isDrowningLoading(true);
  //   try {
  //     drowningList.value = null;
  //
  //     // Pass the date range to the service
  //     var data = await DrowningService.getDrowningList(
  //       startDate: startDate,
  //       endDate: endDate,
  //     );
  //
  //     log(data.toString());
  //
  //     if (data != null) {
  //       drowningList.value = data;
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     log("getDrowingList exception: $e");
  //     return false;
  //   } finally {
  //     isDrowningLoading(false);
  //   }
  // }

  var drowningList = <DrowningListData>[].obs;
  RxBool isDrowningLoading = true.obs;

  /// Pagination
  var drowningCurrentPage = 1.obs;
  var drowningTotalPages = 1.obs;
  final int drowningLimit = 20;
  var drowningTotalCount = 0.obs;

  var searchText = "".obs;

// filtered list getter
  List<DrowningListData> get filteredDrowningList {
    if (searchText.value.isEmpty) {
      return drowningList;
    }
    return drowningList.where((e) {
      final name = (e.nameOfPatient ?? "").toLowerCase();
      return name.contains(searchText.value.toLowerCase());
    }).toList();
  }

  Future<bool> getDrowningList({
    required String startDate,
    required String endDate,
    String patientName = "",
    int dischargeStatus = 0,
    int pageNumber = 1,
  }) async {
    try {
      final queryParams = {
        "limit": drowningLimit.toString(),
        "offset": pageNumber.toString(),
        "start_date": startDate,
        "end_date": endDate,
        "patient_name": patientName,
        "discharge_status": dischargeStatus.toString(),
      };

      final uri = Uri.parse(Urls.getDrowningRecord)
          .replace(queryParameters: queryParams);

      log("Request URL: $uri");

      final response = await _client.get(uri);

      log("getDrowningList response: ${response.statusCode}");

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final list = drowningListModelFromJson(response.body);

        drowningList.assignAll(list.rows ?? []);
        drowningTotalCount.value = list.totalCount ?? 0;

        drowningTotalPages.value =
            (drowningTotalCount.value / drowningLimit)
                .ceil()
                .clamp(1, double.infinity)
                .toInt();

        drowningStartDate.value = DateTime.parse(startDate);
        drowningEndDate.value = DateTime.parse(endDate);
        drowningCurrentPage.value = pageNumber;

        Fluttertoast.showToast(msg: "Data loaded successfully");

        return true;
      }

      return false;
    } catch (ex, stackTrace) {
      log("getDrowningList error: $ex");
      log("StackTrace: $stackTrace");
      return false;
    }
  }

  RxBool isUpdateDrowningLoading = true.obs;

  Future<bool> getDrowningById(id) async {
    isUpdateDrowningLoading(true);
    try {
      drowningModel.value = null;
      var data = await DrowningService.getHangById(id);
      log(data.toString());
      if (data != null) {
        drowningModel.value = data;
        isUpdateDrowningLoading(false);
        return true;
      } else {
        isUpdateDrowningLoading(false);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateDrowning() async {
    loadingIndicator(Get.context!);
    try {
      log(drowningModel.toJson().toString());
      var data = await DrowningService.updateHang(data: drowningModel.value!);
      if (data) {
        Get.back();
        getDrowningList(
          startDate: DateFormat('yyyy-MM-dd 00:00:00')
              .format(DateTime.now().subtract(Duration(days: 7))),
          endDate: DateFormat('yyyy-MM-dd 23:59:59').format(DateTime.now()),
        );
        return true;
      } else {
        Get.back();
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> getDrowningByTriageId({required String id}) async {
    return _withLoader(() async {
      try {
        final url = Uri.parse("${Urls.getDrowningRecordById}$id");
        final response = await _client.get(url);

        log('getDrowningByTriageId response: ${response.statusCode} | ${response.body}');

        if (response.statusCode == 200 && response.body.isNotEmpty) {
          final data = jsonDecode(response.body);

          if (data["error"] == "Not found") {
            notFound.value = true;
            drowningModel.value = DrowningModel(); // clear model
            Fluttertoast.showToast(msg: "Record not found");
            return false;
          }

          drowningModel.value = DrowningModel.fromJson(data);
          notFound.value = false;
          return true;
        } else if (response.statusCode == 404) {
          notFound.value = true;
          drowningModel.value = DrowningModel();
          Fluttertoast.showToast(msg: "Record not found (404)");
          return false;
        } else {
          Fluttertoast.showToast(
              msg: "Unexpected error: ${response.statusCode}");
          return false;
        }
      } catch (ex, stackTrace) {
        log("getDrowningByTriageId exception: $ex\n$stackTrace");
        Fluttertoast.showToast(msg: "Error: $ex");
        return false;
      }
    });
  }

  Future<bool> getDrowningDetails({required String id}) async {
    try {
      log("Fetching PREM Details for ID: $id");

      var response = await _client.get(Uri.parse("${Urls.getDrowningDetails}$id"));
      log("Response (${response.statusCode}): ${response.body}");

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final data = drowningNonIndex(response.body);
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

  Future<void> exportDrowningPdf(NonIndexDrowningDataModel data) async {
    try {
      final pdf = pw.Document();

      final d = data.drowning;
      final caseData = d?.caseDetails;
      final outcome = d?.outcome;

      final Map<String, dynamic> map = {
        "Triage ID": caseData?.triageId,
        "Date Entry": caseData?.dateTimeEntry,
        "Patient Admitted": caseData?.patientAdmitted,
        "Admitting Department": caseData?.admittingDepartment,
        "Admission Datetime": caseData?.admissionDatetime,

        "Place of Incident": caseData?.placeOfIncident,
        "Other Place": caseData?.otherPlace,

        "Type of Water": caseData?.typeOfWater,
        "Other Type of Water": caseData?.otherTypeOfWater,

        "Activity During Drowning": caseData?.activityDuringDrowning,
        "Other Activity": caseData?.otherActivity,

        "Assessment": caseData?.assessment,
        "Intervention": caseData?.intervention,
        "Other Interventions": caseData?.otherInterventions,

        "Supportive Care": caseData?.supportiveCare,
        "Other Supportive Care": caseData?.otherSupportiveCare,

        "Complications During Admission": caseData?.complicationsAdmission,
        "Other Complication (Admit)": caseData?.otherComplicationAdmitted,

        "Complications Developed": caseData?.complicationsDeveloped,
        "Other Complications Developed": caseData?.otherComplicationsDeveloped,

        "Counselling Before Discharge": caseData?.counsellingBeforeDischarge,
        "Discharge Datetime": caseData?.dischargeDatetime,
        "Duration of Hospital Stay": caseData?.durationOfHospitalStay,

        "Outcome Type": outcome?.outcomeType,
        "Is Discharged": outcome?.isDischarged,
        "Discharge Datetime": outcome?.dischargeDatetime,
        "Absconded Datetime": outcome?.abscondedDatetime,
        "Death Datetime": outcome?.deathDatetime,
        "Cause of Death": outcome?.causeOfDeath,
        "Hospital Type": outcome?.hospitalType,
        "Destination Hospital": outcome?.destinationHospital,
        "Referral Reason": outcome?.referralReason,
        "Other Reason Referral": outcome?.otherReasonReferral,
        "Patient Condition": outcome?.patientCondition,
        "Referring Doctor": outcome?.referringDoctor,
        "Documented in Case Sheet": outcome?.documentedInTaeiCaseSheet,
        "Created At": outcome?.createdAt,
        "Updated At": outcome?.updatedAt,
      };

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (_) => [
            pw.Center(
              child: pw.Text("DROWNING CASE DETAILS"),
            ),

            pw.SizedBox(height: 12),

            ...map.entries.map((e) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 6),
              child: pw.Row(children: [
                pw.Expanded(
                  flex: 4,
                  child: pw.Text("${e.key}:"),
                ),
                pw.Expanded(
                  flex: 6,
                  child: pw.Text("${e.value ?? '-'}"),
                ),
              ]),
            )),

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
        final a = html.AnchorElement(href: url)
          ..setAttribute("download", "Drowning_${DateTime.now().millisecondsSinceEpoch}.pdf")
          ..click();
        html.Url.revokeObjectUrl(url);
        return;
      }
      final downloadsDir = await getDownloadsDirectory();
      final file = File(
          "${downloadsDir!.path}/Drowning_${DateTime.now().millisecondsSinceEpoch}.pdf");
      await file.writeAsBytes(bytes);
      Fluttertoast.showToast(
        msg: "Saved in Downloads folder: ${file.path}",
      );

    } catch (e) {
      print("PDF Error: $e");
    }
  }

  Future<bool> getDrowningDashboard({
    required String startDate,
    required String endDate,
  }) async {
    try {
      var url = Uri.parse(
        Urls.getDrowningDashboard + "?start_date=$startDate&end_date=$endDate",
      );

      var response = await _client.get(url, headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      });

      log('getStemiDashboard response: ${response.body}');

      if (response.body.isNotEmpty) {
        // Parse list
        var list = getDrowningSummaryListFromJson(response.body);

        // Assign to observable
        drowningDashboard.value = list.first.drowningSummary ?? DrowningSummary();

        // Convert to map for UI
        drowningDataMap.value = {
          "Total": drowningDashboard.value.total.toString(),
          "IFT": drowningDashboard.value.ift.toString(),
          "Admitted": drowningDashboard.value.admitted.toString(),
          "Pending": drowningDashboard.value.pending.toString(),
          "Mild": drowningDashboard.value.mild.toString(),
          "Moderate": drowningDashboard.value.moderate.toString(),
          "Severe": drowningDashboard.value.severe.toString(),
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
