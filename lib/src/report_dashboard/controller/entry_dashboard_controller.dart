import 'dart:developer';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/src/login/controller/login_controller.dart';
import 'package:taei_gov/src/report_dashboard/models/entry_dashboard_model.dart';
import 'package:taei_gov/src/report_dashboard/models/institution_model.dart';
import 'package:taei_gov/src/report_dashboard/models/patient_entry_report_model.dart';
import 'package:taei_gov/src/report_dashboard/service/entry_service.dart';

class EntryDashboardController extends GetxController {
  RxInt selectedIndex = (-1).obs;
  Rx<EntryDashboardData?> selectedDatum = Rx<EntryDashboardData?>(null);

  void selectHospital(int index, EntryDashboardData datum) {
    selectedIndex.value = index;
    selectedDatum.value = datum;
  }

  RxBool isLoading = true.obs;
  var fromDate = Rxn<DateTime>();
  var toDate = Rxn<DateTime>();
  var entryData = Rxn<EntryDashboardModel>();
  final loginController = Get.find<LoginController>();

  // Future<bool> getData() async {
  //   isLoading(true);
  //   try {
  //     var data = await EntryDashboardService.getData(
  //       reportType: 1,
  //       endDate: DateFormat("yyyy-MM-dd").format(toDate.value!),
  //       startDate: DateFormat("yyyy-MM-dd").format(fromDate.value!),
  //       districtId:
  //           loginController.isAdmin.value ? 0 : loginController.getDisrictId(),
  //       institutionId: loginController.isAdmin.value
  //           ? 0
  //           : loginController.checkIsInstitution()
  //               ? loginController.getInsId()
  //               : selectedInstitution.value ?? 0,
  //     );
  //     log(data.toString());
  //     if (data != null && data != "") {
  //       // if (reportType.value == 3) {
  //       //   //Trauma
  //       //   traumaData.value = traumaReportModelFromJson(data);
  //       // }
  //       // else if (reportType.value == 4) {
  //       //   // Burns
  //       //   burnsData.value = burnsReportModelFromJson(data);
  //       // } else if (reportType.value == 5) {
  //       //   // Poisoning
  //       //   poisonData.value = poisoningReportModelFromJson(data);
  //       // } else if (reportType.value == 6) {
  //       //   // BitesStings
  //       //   byteData.value = byteReportModelFromJson(data);
  //       // } else if (reportType.value == 8) {
  //       //   // Stroke
  //       //   strokeData.value = strokeReportModelFromJson(data);
  //       // } else if (reportType.value == 9) {
  //       //   // Prem
  //       //   premData.value = premReportModelFromJson(data);
  //       // } else if (reportType.value == 10) {
  //       //   // Stemi
  //       //   stemiData.value = stemiReportModelFromJson(data);
  //       // }
  //       entryData.value = entryDashboardModelFromJson(data);
  //       isLoading(false);
  //       return true;
  //     } else {
  //       isLoading(false);
  //       return false;
  //     }
  //   } catch (e) {
  //     return false;
  //   }
  // }

/*  Future<bool> getData2({
    required String startDate,
    required String endDate,
    required String institutionId,
  }) async {
    isLoading(true);
    try {
      var data = await EntryDashboardService.getData(
        reportType: 1,
        endDate: endDate,
        startDate: startDate,
        districtId: loginController.districtId.value,
        institutionId: institutionId,
        directorateId: loginController.directorateId.value,
      );
      log("Entry Report = ${data.toString()}");
      if (data != null && data != "") {
        log("Test Entry Dashboard");
        entryData.value = entryDashboardModelFromJson(data);
        isLoading(false);
        return true;
      } else {
        isLoading(false);
        return false;
      }
    } catch (e) {
      return false;
    }
  }*/

  Future<bool> getData2({
    required String startDate,
    required String endDate,
    required String institutionId,
    String? districtId,
    int? directorateId,
  }) async {
    isLoading(true);
    try {
      var data = await EntryDashboardService.getData(
        reportType: 1,
        endDate: endDate,
        startDate: startDate,
        institutionId: institutionId,
        districtId: districtId ?? loginController.districtId.value.toString(),
        directorateId: directorateId ?? loginController.directorateId.value,
      );

      log("Raw Response = $data");
      fromDate.value = DateTime.parse(startDate);
      toDate.value = DateTime.parse(endDate);

      if (data == null ||
          data.toString().trim().isEmpty ||
          data.toString().trim() == '""') {
        log("Empty Response from API");
        isLoading(false);
        return false;
      } else {
        log("ADDED ");
        entryData.value = entryDashboardModelFromJson(data);
        isLoading(false);
        return true;
      }
    } catch (e) {
      log("Error: $e");
      isLoading(false);
      return false;
    }
  }

  RxBool isPatientReportLoading = true.obs;
  var patientReportData = Rxn<PatientEntryReportModel>();
  RxInt patientReportType = 1.obs;
  RxInt patientHospitalId = 0.obs;
  RxInt patientPillerType = 0.obs;
  RxInt patientOffset = 1.obs;

  Future<bool> getPatientReport() async {
    isPatientReportLoading(true);
    try {
      var data = await EntryDashboardService.getPatientReport(
          reportType: patientReportType.value,
          hospital_id: patientHospitalId.value,
          offset: patientOffset.value,
          pillar_type: patientPillerType.value,
          endDate: DateFormat("yyyy-MM-dd").format(toDate.value!),
          startDate: DateFormat("yyyy-MM-dd").format(fromDate.value!));
      log(data.toString());
      if (data != null && data != "") {
        patientReportData.value = data;
        isPatientReportLoading(false);
        return true;
      } else {
        isPatientReportLoading(false);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  RxBool isInstitutionLoading = true.obs;
  var selectedInstitution = Rxn<int>();

  RxList<InstitutionModel> institutionData = <InstitutionModel>[].obs;

  Future<bool> getInstitutionById() async {
    isInstitutionLoading(true);
    try {
      institutionData.clear();
      var data = await EntryDashboardService.getInstitutionList(
          district_id: loginController.getDisrictId(),
          dirId: loginController.getDir());
      if (data.isNotEmpty) {
        institutionData.value = data;
        selectedInstitution.value = data.isEmpty ? 0 : data.first.hospitalid;
        isInstitutionLoading(false);
        return true;
      } else {
        isInstitutionLoading(false);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  List<Map<String, dynamic>> dk = [
    {"id": 1, "name": "Pending"},
    {"id": 2, "name": "Entry Done"},
    {"id": 3, "name": "Total"},
  ];
}
