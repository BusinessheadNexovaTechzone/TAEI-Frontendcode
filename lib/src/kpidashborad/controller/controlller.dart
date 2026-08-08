import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:taei_gov/constants/urls.dart';
import 'package:taei_gov/src/kpidashborad/model/poisoning_kpi.dart';
import 'package:taei_gov/src/kpidashborad/service/kpi_service.dart';
import 'package:taei_gov/src/login/controller/login_controller.dart';

// KPI Models
import '../../report_dashboard/models/institution_model.dart';
import '../model/trauma_kpi.dart';
import '../model/burns_kpi.dart';
import '../model/stroke_kpi.dart';
import '../model/prem_kpi.dart';
import '../model/stemi_kpi.dart';
import '../model/taei_kpi.dart';

class KpiDashboard extends GetxController {
  final LoginController loginController = Get.find();

  RxInt selectedPillar = 0.obs; // 0 = TAEI
  RxBool isLoading = false.obs;

  var StartDate = Rxn<DateTime>();
  var EndDate = Rxn<DateTime>();

  // KPI model objects
  var trauma = DashboardTraumaData().obs;
  var burns = DashboardBurnsResponse().obs;

  // var poisoning = PoisoningKpi().obs;
  var stroke = StrokeDashboardResponse().obs;
  var prem = PremDashboardResponse().obs;
  var stemi = StemikpiDashboardModel().obs;
  var taeiDashboard = DashboardData().obs;
  var poisoningKpi = PoisoningKpiDashboardModel().obs;

  /*Future<bool> getKPIDashboard({
    required String startDate,
    required String endDate,
    required int reportType,
  }) async {
    try {
      isLoading.value = true;

      final url = Uri.parse(Urls.getKPI);

      final requestBody = jsonEncode({
        "from_date": startDate,
        "to_date": endDate,
        "report_type": reportType,
        "institution_id": loginController.isAdmin.value
            ? 0
            : loginController.checkIsInstitution()
                ? loginController.getInsId()
                : selectedInstitution.value ?? 0,
        "district_id":
            loginController.isAdmin.value ? 0 : loginController.getDisrictId()
      });

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: requestBody,
      );

      log("KPI Response => ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);

        if (decoded["data"] == null) {
          log("⚠ No 'data' found in response");
          return false;
        }

        final dataJson = decoded["data"];

        // ---------------------------------------------------------------
        // ✔ Select correct KPI model based on pillar (same as your format)
        // ---------------------------------------------------------------
        switch (selectedPillar.value) {
          case 0: // ⭐ TAEI Dashboard
            taeiDashboard.value = DashboardData.fromJson(dataJson);
            break;

          case 3: // ⭐ Trauma
            trauma.value = DashboardTraumaData.fromJson(dataJson);
            break;

          case 4: // ⭐ Burns
            burns.value = DashboardBurnsResponse.fromJson(dataJson);
            break;

          case 5: // ⭐ Poisoning
            // var poisoningKpiData =
            //     PoisoningKpiDashboardModel.fromJson(dataJson);
            poisoningKpi.value = PoisoningKpiDashboardModel.fromJson(decoded);
            log("Poisoning KPI Data => ${jsonEncode(poisoningKpi.value.toJson())}");

            break;

          case 8: // ⭐ Stroke
            stroke.value = StrokeDashboardResponse.fromJson(dataJson);
            break;

          case 9: // ⭐ Prem
            prem.value = PremDashboardResponse.fromJson(dataJson);
            break;

          case 10: // ⭐ STEMI
            stemi.value = StemikpiDashboardModel.fromJson(dataJson);
            break;

          default:
            log("Unknown pillar selected");
        }

        return true;
      }

      return false;
    } catch (e) {
      log("❌ KPI Dashboard Error: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }*/

  Future<bool> getKPIDashboard({
    required String startDate,
    required String endDate,
    required int reportType,
    required String institutionId,
    required String districtId,
    required int directorateId,
  }) async {
    try {
      isLoading.value = true;

      final url = Uri.parse(Urls.getKPI);

      final requestBody = jsonEncode({
        "from_date": startDate,
        "to_date": endDate,
        "report_type": reportType,
        "institution_id": institutionId.toString(),
        "district_id": districtId,
        "directorate_id": directorateId,
      });

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: requestBody,
      );

      log("KPI Response => ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        StartDate.value = DateTime.parse(startDate);
        EndDate.value = DateTime.parse(endDate);
        final decoded = jsonDecode(response.body);

        if (decoded["data"] == null) {
          log("⚠ No 'data' found in response");
          return false;
        }

        final dataJson = decoded["data"];

        // ---------------------------------------------------------------
        // ✔ Select correct KPI model based on pillar (same as your format)
        // ---------------------------------------------------------------
        switch (selectedPillar.value) {
          case 0: // ⭐ TAEI Dashboard
            taeiDashboard.value = DashboardData.fromJson(dataJson);
            break;

          case 3: // ⭐ Trauma
            trauma.value = DashboardTraumaData.fromJson(dataJson);
            break;

          case 4: // ⭐ Burns
            burns.value = DashboardBurnsResponse.fromJson(dataJson);
            break;

          case 5: // ⭐ Poisoning
            // var poisoningKpiData =
            //     PoisoningKpiDashboardModel.fromJson(dataJson);
            poisoningKpi.value = PoisoningKpiDashboardModel.fromJson(decoded);
            log("Poisoning KPI Data => ${jsonEncode(poisoningKpi.value.toJson())}");

            break;

          case 8: // ⭐ Stroke
            stroke.value = StrokeDashboardResponse.fromJson(dataJson);
            break;

          case 9: // ⭐ Prem
            prem.value = PremDashboardResponse.fromJson(dataJson);
            break;

          case 10: // ⭐ STEMI
            stemi.value = StemikpiDashboardModel.fromJson(dataJson);
            break;

          default:
            log("Unknown pillar selected");
        }

        return true;
      }

      return false;
    } catch (e) {
      log("❌ KPI Dashboard Error: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  RxBool isInstitutionLoading = true.obs;
  var selectedInstitution = Rxn<int>();

  RxList<InstitutionModel> institutionData = <InstitutionModel>[].obs;

  Future<bool> getInstitutionById() async {
    isInstitutionLoading(true);
    try {
      institutionData.clear();
      var data = await KpiService.getInstitutionList(
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
}
