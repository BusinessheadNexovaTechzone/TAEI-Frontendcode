import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:taei_gov/constants/urls.dart';
import 'package:taei_gov/src/institutional/controller/institutional_controller.dart';
import 'package:taei_gov/src/institutional_dashboard/model/burns_institutional_dashboard_model.dart';
import 'package:taei_gov/src/institutional_dashboard/model/in_hospital_institutional_dashboard_model.dart';
import 'package:taei_gov/src/institutional_dashboard/model/poisoning_institutional_dashboard_model.dart';
import 'package:taei_gov/src/institutional_dashboard/model/pre_hospital_institutional_dashboard_model.dart';
import 'package:taei_gov/src/institutional_dashboard/model/prem_institutional_dashboard_model.dart'
    show
        PremInstitutionalDashboardModel,
        premInstitutionalDashboardModelFromJson;
import 'package:taei_gov/src/institutional_dashboard/model/stemi_institutional_dashboard_model.dart';
import 'package:taei_gov/src/institutional_dashboard/model/stroke_institutional_dashboard_model.dart'
    hide Data;
import 'package:taei_gov/src/institutional_dashboard/model/trauma_institutional_dashboard_model.dart'
    hide Data;
import 'package:taei_gov/src/institutional_dashboard/service/institution_service.dart';
import 'package:taei_gov/src/login/controller/login_controller.dart';
// import 'package:taei_gov/utils/helpers/http_helper.dart';

import '../../report_dashboard/models/institution_model.dart';

// git
class InstitutionalDashboardController extends GetxController {
  final LoginController loginController = Get.find();

  var selectedPillar = 20.obs;
  RxBool isLoading = false.obs;

  var StartDate = Rxn<DateTime>();
  var EndDate = Rxn<DateTime>();

  var burnsDashboard = BurnsInstitutionalDashboardModel().obs;
  var traumaDashboard = TraumaInstitutionalDashboardModel().obs;
  var scriptDashboard = StrokeInstitutionalDashboardModel().obs;
  var premDashboard = PremInstitutionalDashboardModel().obs;
  var stemiDashboard = STEMIInstitutionalDashboardModel().obs;
  var poisoningDashboard = PoisoningInstitutionalDashboardModel().obs;
  var preHospitalDashboard = PreHospitalInstitutionalDashboardModel().obs;
  var inHospitalDashboard = InHospitalInstitutionalDashboardModel().obs;

  List<GenderWise> normalizeGender(List<GenderWise> list) {
    final map = {for (var g in list) g.gender ?? 'Unknown': g.totalCount ?? 0};

    return [
      GenderWise(gender: 'Male', totalCount: map['Male'] ?? 0),
      GenderWise(gender: 'Female', totalCount: map['Female'] ?? 0),
      GenderWise(gender: 'Transgender', totalCount: map['Transgender'] ?? 0),
      GenderWise(gender: 'Unknown', totalCount: map['Unknown'] ?? 0),
    ];
  }

  Future<bool> getInstitutionalDashboard({
    required String startDate,
    required String endDate,
    required int reportType,
    required String institutionId,
    required String districtId,
    required int directorateId,
  }) async {
    try {
      log("getInstitutionalDashboard: ${loginController.userDetails.value?.user?.hospital?.hospitalid}");
      isLoading.value = true;
      var url = Uri.parse(Urls.getInstitutionalDashboard);
      var response = await http.post(url,
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "from_date": startDate,
            "to_date": endDate,
            "report_type": reportType,
            "institution_id": institutionId.toString(),
            "district_id": districtId,
            "directorate_id": directorateId,
          }));
      log(jsonEncode({
        "from_date": startDate,
        "to_date": endDate,
        "report_type": reportType,
        "institution_id": institutionId.toString(),
        "district_id": districtId,
        "directorate_id": directorateId,
      }));
      log("from Date: ${startDate}");
      log("to Date: ${endDate}");
      log("reportType: ${reportType}");
      log("institutionId: ${institutionId}");
      log("districtId: ${loginController.districtId.value}");
      log("directorateId: ${loginController.directorateId.value}");
      log(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        StartDate.value = DateTime.parse(startDate);
        EndDate.value = DateTime.parse(endDate);
        if (selectedPillar.value == 3) {
          traumaDashboard.value =
              traumaInstitutionalDashboardModelFromJson(response.body);
        } else if (selectedPillar.value == 4) {
          burnsDashboard.value =
              burnsInstitutionalDashboardModelFromJson(response.body);
        } else if (selectedPillar.value == 5) {
          poisoningDashboard.value =
              poisoningInstitutionalDashboardModelFromJson(response.body);
        } else if (selectedPillar.value == 8) {
          scriptDashboard.value =
              strokeInstitutionalDashboardModelFromJson(response.body);
        } else if (selectedPillar.value == 9) {
          premDashboard.value =
              premInstitutionalDashboardModelFromJson(response.body);
        } else if (selectedPillar.value == 10) {
          stemiDashboard.value =
              stemiInstitutionalDashboardModelFromJson(response.body);
        } else if (selectedPillar.value == 20) {
          preHospitalDashboard.value =
              preHospitalInstitutionalDashboardModelFromJson(response.body);
        } else if (selectedPillar.value == 21) {
          inHospitalDashboard.value =
              inHospitalInstitutionalDashboardModelFromJson(response.body);
        }

        log('getInstitutionalDashboard response: ${response.body}');
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      log("getInstitutionalDashboard error: $ex");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

/* var burnsDashboardList = BurnsInstitutionalDashboardModel(
      data: Data(
    totalBurns: 34,
    totalTreated: 22,
    totalSurgery: 22,
    totalIft: 10,
    avgStay: 2,
    outcome: [
      BurnsInstitutionOutcome(
        id: 1,
        name: "Discharged",
        totalCount: 22,
      ),
      BurnsInstitutionOutcome(
        id: 2,
        name: "Discharge at request",
        totalCount: 190,
      ),
      BurnsInstitutionOutcome(
        id: 3,
        name: "DAMA",
        totalCount: 200,
      ),
      BurnsInstitutionOutcome(
        id: 4,
        name: "Absconded",
        totalCount: 1000,
      ),
      BurnsInstitutionOutcome(
        id: 5,
        name: "Death",
        totalCount: 400,
      ),
      BurnsInstitutionOutcome(
        id: 6,
        name: "Transferred to other hospital",
        totalCount: 50,
      ),
      BurnsInstitutionOutcome(
        id: 7,
        name: "Treated as OP",
        totalCount: 40,
      ),
    ],
  ));*/
}
