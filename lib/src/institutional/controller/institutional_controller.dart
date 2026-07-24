import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:taei_gov/constants/urls.dart';
import 'package:taei_gov/src/institutional/model/institutional_list_model.dart';
import 'package:taei_gov/src/login/controller/login_controller.dart';
import 'package:taei_gov/utils/helpers/http_helper.dart';

class InstitutionalController extends GetxController {
  final LoginController loginController = Get.find();
  static final _client = CustomHttpHelper();
  var isLoading = false.obs;
  var institutionList = <InstitutionalListModel>[].obs;
  var institutionId = 0.obs;

  /// New Institutional Selection Variable

  var selectedInstitutionIds = <int>{}.obs;

  //// Helper to send API value////
  String get institutionIdPayload =>
      selectedInstitutionIds.isEmpty ? "" : selectedInstitutionIds.join(',');

  ///...............................///

  // TransitCare 108

  RxList<String> transitCareHospital108List = <String>[].obs;
  RxString selectedTransitCareHospital = "Select Hospital Name".obs;

  Future<bool> getInstitutionListData({
    String? districtId,
    int? directorateId,
  }) async {
    isLoading.value = true;
    try {
      final String finalDistrictId =
          districtId ?? loginController.districtId.value.toString();

      final int finalDirectorateId =
          directorateId ?? loginController.directorateId.value;
      final int finalInstitutionId =
          loginController.userDetails.value?.user?.hospital?.hospitalid ?? 0;

      var url = Uri.parse(
        "${Urls.getInstitutionList}"
        "?district_id=$finalDistrictId&directorate_id=$finalDirectorateId&hospital_id=$finalInstitutionId",
      );
      var response =
          await _client.get(url, headers: {"Content-Type": "application/json"});
      log("Institution List Data Get: ${response.body}");
      if (response.body.isNotEmpty) {
        /// ✅ CHECK ROLE (example – adjust if needed)
        final list = institutionalListModelFromJson(response.body);
        final role = loginController.userDetails.value?.user?.role;

        final bool needAllHospital =
            role != 'admin'; // state, district, dms, dme, gh

        if (needAllHospital && list.length > 1) {
          // institutionList.value = [
          //   InstitutionalListModel(
          //     hospitalId: 0,
          //     hospitalName: "All Hospitals",
          //   ),
          //   ...list,
          // ];
          institutionList.value = list;
          institutionId.value = 0; // default selection
          transitCareHospital108List.assignAll(
            institutionList
                .map((h) => h.hospitalName108)
                .where((name) => name != null && name.isNotEmpty)
                .cast<String>()
                .toList(),
          );
          selectedTransitCareHospital.value = transitCareHospital108List.first;
        } else {
          institutionList.value = institutionalListModelFromJson(response.body);
          institutionId.value =
              int.parse(institutionList.first.hospitalId.toString());
          selectedInstitutionIds.value = {
            int.parse(institutionList.first.hospitalId.toString()),
          };
          transitCareHospital108List.assignAll(
            institutionList
                .map((h) => h.hospitalName108)
                .where((name) => name != null && name.isNotEmpty)
                .cast<String>()
                .toList(),
          );
          selectedTransitCareHospital.value = transitCareHospital108List.first;
          Fluttertoast.showToast(msg: "Data loaded successfully");
        }
        isLoading.value = false;
        return true;
      } else {
        Fluttertoast.showToast(msg: "No data found");
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
