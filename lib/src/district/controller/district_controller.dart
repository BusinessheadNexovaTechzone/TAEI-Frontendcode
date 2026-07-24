import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:taei_gov/constants/urls.dart';
import 'package:taei_gov/src/district/model/district_list_model.dart';
import 'package:taei_gov/src/login/controller/login_controller.dart';
import 'package:taei_gov/utils/helpers/http_helper.dart';

class DistrictController extends GetxController {
  final LoginController loginController = Get.find();
  var isLoading = false.obs;
  static final _client = CustomHttpHelper();
  var districtList = <DistrictListModel>[].obs;
  var selectedDistrictId = "".obs;

  //  /// New Institutional Selection Variable
  //
  //   var selectedInstitutionIds = <int>{}.obs;
  //
  //   //// Helper to send API value////
  //   String get institutionIdPayload =>
  //       selectedInstitutionIds.isEmpty ? "" : selectedInstitutionIds.join(',');

  // var selectedSetDistrictId = <int>{}.obs;
  //
  // //// Helper to send API value////
  // String get districtIdPayload =>
  //     selectedSetDistrictId.isEmpty ? "" : selectedSetDistrictId.join(',');

  Future<bool> getDistrictListData() async {
    isLoading.value = true;
    try {
      var url = Uri.parse(Urls.getDistrict);
      var response =
          await _client.get(url, headers: {"Content-Type": "application/json"});
      if (response.body.isNotEmpty) {
        var data = districtListModelFromJson(response.body);
        if (data.length > 1) {
          districtList.value = [
            DistrictListModel(
              id: 0,
              name: "All Districts",
            ),
            ...data,
          ];
        }
        log("Login DistrictId ${loginController.districtId.value.toString()}");
        selectedDistrictId.value =
            loginController.districtId.value.toString() ?? "";
        // selectedSetDistrictId.value = {
        //   int.parse(districtList.first.id.toString()),
        // };
        log("KKKKK${districtList.toString()}");
        Fluttertoast.showToast(msg: "Data loaded successfully");
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
