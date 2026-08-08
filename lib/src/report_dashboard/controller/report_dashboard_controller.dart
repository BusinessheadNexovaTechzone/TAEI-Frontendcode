import 'dart:developer';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/src/login/controller/login_controller.dart';
import 'package:taei_gov/src/report_dashboard/models/burns_report_model.dart';
import 'package:taei_gov/src/report_dashboard/models/byte_report_model.dart';
import 'package:taei_gov/src/report_dashboard/models/poisoning_report_model.dart';
import 'package:taei_gov/src/report_dashboard/models/prem_report_model.dart';
import 'package:taei_gov/src/report_dashboard/models/stemi_repprt_model.dart';
import 'package:taei_gov/src/report_dashboard/models/stroke_report_model.dart';
import 'package:taei_gov/src/report_dashboard/models/trauma_report_model.dart';

import '../models/institution_model.dart';
import '../service/report_dashboard_service.dart';

class ReportDashboardController extends GetxController {
  RxInt reportType = 3.obs;
  var fromDate = Rxn<DateTime>();
  var toDate = Rxn<DateTime>();
  RxBool isDataLoading = false.obs;
  var traumaData = Rxn<TraumaReportModel>();
  var burnsData = Rxn<BurnsReportModel>();
  RxList<PoisoningReportModel> poisonData = <PoisoningReportModel>[].obs;
  RxList<ByteReportModel> byteData = <ByteReportModel>[].obs;
  var strokeData = Rxn<StrokeReportModel>();
  var premData = Rxn<PremReportModel>();
  var stemiData = Rxn<StemiReportModel>();
  final loginController = Get.find<LoginController>();

  ///
  List<dynamic> get selectedReportData {
    switch (reportType.value) {
      case 3: // Trauma
        return traumaData.value?.data ?? [];

      case 4: // Burns
        return burnsData.value?.data ?? [];

      case 5: // Poisoning
        return poisonData;

      case 6: // Bites & Stings
        return byteData;

      case 8: // Stroke
        return strokeData.value?.data ?? [];

      case 9: // Prem
        return premData.value?.data ?? [];

      case 10: // Stemi
        return stemiData.value?.data ?? [];

      default:
        return [];
    }
  }

  Future<bool> getData({
    required String startDate,
    required String endDate,
    required int reportType,
    required String institutionId,
    String? districtId,
    int? directorateId,
  }) async {
    isDataLoading(true);
    try {
      stemiData.value = null;
      var data = await ReportDashboardService.getData(
        reportType: reportType,
        endDate: endDate,
        startDate: startDate,
        institutionId: institutionId,
        districtId: districtId ?? loginController.districtId.value.toString(),
        directorateId: directorateId ?? loginController.directorateId.value,
      );
      log(data.toString());
      if (data != null && data != "") {
        fromDate.value = DateTime.parse(startDate);
        toDate.value = DateTime.parse(endDate);
        if (reportType == 3) {
          //Trauma
          traumaData.value = traumaReportModelFromJson(data);
        } else if (reportType == 4) {
          // Burns
          burnsData.value = burnsReportModelFromJson(data);
        } else if (reportType == 5) {
          // Poisoning
          poisonData.value = poisoningReportModelFromJson(data);
        } else if (reportType == 6) {
          // BitesStings
          byteData.value = byteReportModelFromJson(data);
        } else if (reportType == 8) {
          // Stroke
          strokeData.value = strokeReportModelFromJson(data);
        } else if (reportType == 9) {
          // Prem
          premData.value = premReportModelFromJson(data);
        } else if (reportType == 10) {
          // Stemi
          stemiData.value = stemiReportModelFromJson(data);
        }
        isDataLoading(false);
        return true;
      } else {
        isDataLoading(false);
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}

// 3 -"Trauma"
// 4 -"Burns"
// 5 -"Poisoning"
// 6 -"BitesStings"
// 8 -"Stroke"
// 9 -"Prem"
// 10 -"Stemi"
